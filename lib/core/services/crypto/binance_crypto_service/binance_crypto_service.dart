import 'package:f_crypto/core/network/api_service/app_api_service.dart';
import 'package:rxdart/rxdart.dart';

import 'package:f_crypto/core/entities/currency.dart';
import 'package:f_crypto/core/network/internet_connection/app_internet_connection.dart';
import 'package:f_crypto/core/network/reconnector/app_reconnector.dart';
import 'package:f_crypto/core/network/websocket_client/app_websocket_client.dart';
import 'package:f_crypto/core/services/logger/app_logger.dart';
import 'package:f_crypto/core/services/worker/app_worker_service.dart';

import '../crypto_service.dart';
import 'binance_mapper.dart';
import 'binance_storage.dart';
import 'data_model/binance_currency_from_api.dart';
import 'data_model/binance_currency_from_socket.dart';

class BinanceCryptoService implements CryptoService {
  BinanceCryptoService({
    required AppInternetConnection internet,
    required AppWebsocketClient websocketClient,
    required AppApiService apiService,
    required BinanceStorage storage,
    required AppReconnector reconnector,
    required AppWorkerService worker,
    required AppLogger logger,
    required Uri restUrl,
    required Uri wsUrl,
  })  : _internet = internet,
        _websocketClient = websocketClient,
        _apiService = apiService,
        _storage = storage,
        _reconnector = reconnector,
        _worker = worker,
        _logger = logger,
        _restUrl = restUrl,
        _wsUrl = wsUrl;

  final AppInternetConnection _internet;
  final AppWebsocketClient _websocketClient;
  final AppApiService _apiService;
  final BinanceStorage _storage;
  final AppReconnector _reconnector;
  final AppWorkerService _worker;
  final AppLogger _logger;

  final Uri _restUrl;
  final Uri _wsUrl;

  static const _socketThrottleDuration = Duration(seconds: 2);
  static const _socketTimeoutDuration = Duration(seconds: 30);

  final _subscriptions = CompositeSubscription();

  final _restartTrigger = PublishSubject<void>();

  @override
  Stream<List<Currency>> allCurrenciesStream() => _storage.currenciesStream;

  @override
  void restartService() => _restartTrigger.add(null);

  Future<void> init() async {
    if (_subscriptions.isDisposed) return;

    _lifecycleStream()
        .listen(_handleUpdate, onError: _handleError)
        .addTo(_subscriptions);
  }

  Stream<List<Currency>> _lifecycleStream() {
    return MergeStream<AppInternetStatus>([
      _internet.onStatusChange.distinct(),
      _restartTrigger.switchMap(
        (_) => Stream.fromFuture(_internet.status),
      ),
    ])
        .doOnData((data) => _logger.log('Internet status: ${data.name}'))
        .switchMap<List<Currency>>(
      (status) {
        if (status != AppInternetStatus.connected) {
          _websocketClient.disconnect();
          return const Stream.empty();
        }

        return _createDataPipeline();
      },
    );
  }

  Stream<List<Currency>> _createDataPipeline() {
    return Rx.retryWhen(
      () => Rx.defer(
        () {
          return Rx.fromCallable(() => _fetchInitialCurrencies())
              .doOnData((data) => _storage.clear())
              .flatMap(
                (initialData) => _wsConnect().startWith(initialData),
              );
        },
      ),
      (errors, stack) {
        _logger.log('Crypto initial fetch error: $errors', stackTrace: null);
        _websocketClient.disconnect();
        return _reconnector.waitNext().asStream();
      },
    );
  }

  Stream<List<Currency>> _wsConnect() {
    return Rx.defer(
      () => Stream.fromFuture(
        _websocketClient.connect(_wsUrl),
      ),
    )
        .doOnListen(() => _logger.log('Connecting to Binance api...'))
        .asyncExpand((_) {
          var stream = _websocketClient.rawStream;
          if (stream == null) {
            _logger.log('WS Stream is null, retrying...');
            return Stream.error(Exception('Stream not initialized'));
          }
          _logger.log('Connected to Binance WS');

          return stream.timeout(_socketTimeoutDuration);
        })
        .whereType<String>()
        .throttleTime(
          _socketThrottleDuration,
        )
        .asyncMap((data) => _worker.execute(data, _parseSocketData))
        .doOnData((_) => _reconnector.reset());
  }

  Future<List<Currency>> _fetchInitialCurrencies() async {
    try {
      _logger.log('Fetching initial snapshot via REST...');

      var data = await _apiService.get(_restUrl);

      List<Currency> parsedData = await _worker.execute(data, _parseRestData);

      return parsedData;
    } catch (e) {
      _logger.log('Crypto initial fetch error: $e', stackTrace: null);
      rethrow;
    }
  }

  static List<Currency> _parseSocketData(String data) =>
      BinanceMapper.parse<BinanceCurrencyFromSocket>(
        data,
        BinanceCurrencyFromSocket.fromJson,
        formatter: BinanceMapper.cleanUSDTFormatter,
      );

  static List<Currency> _parseRestData(String data) =>
      BinanceMapper.parse<BinanceCurrencyFromApi>(
        data,
        BinanceCurrencyFromApi.fromJson,
        formatter: BinanceMapper.cleanUSDTFormatter,
        sort: BinanceMapper.sortByVolumeDesc,
      );

  void _handleUpdate(List<Currency> data) {
    if (data.isNotEmpty) {
      _storage.updateCurrencies(data);
    }
  }

  void _handleError(Object error, StackTrace stack) {
    _logger.log(
      'Service Error: $error',
      stackTrace: stack,
    );
  }

  void dispose() {
    _subscriptions.dispose();
    _restartTrigger.close();
    _reconnector.dispose();
    _storage.dispose();
    _websocketClient.disconnect();
  }
}
