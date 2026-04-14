import 'package:f_crypto/core/network/api_service/app_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:f_crypto/core/entities/currency.dart';
import 'package:f_crypto/core/network/internet_connection/app_internet_connection.dart';
import 'package:f_crypto/core/network/reconnector/app_reconnector.dart';
import 'package:f_crypto/core/network/websocket_client/app_websocket_client.dart';
import 'package:f_crypto/core/services/crypto/binance_crypto_service/binance_crypto_service.dart';
import 'package:f_crypto/core/services/crypto/binance_crypto_service/binance_storage.dart';
import 'package:f_crypto/core/services/logger/app_logger.dart';
import 'package:f_crypto/core/services/worker/app_worker_service.dart';

import 'package:mocktail/mocktail.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  late BinanceCryptoService service;
  late MockInternet internet;
  late MockWSClient wsClient;
  late MockApiService apiService;
  late MockStorage storage;
  late MockReconnector reconnector;
  late MockWorker worker;
  late MockLogger logger;

  final restUrl = Uri.parse('https://example.com');
  final wsUrl = Uri.parse('wss://example.com');

  const tCurrency = Currency(
    symbol: 'BTC',
    price: 60000,
    priceChangePercent: 1.5,
    volume: 1000,
  );

  const tCurrencies = [tCurrency];

  // Helper to emit internet status
  late StreamController<AppInternetStatus> internetStatusController;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue((String data) => <Currency>[]);
  });

  setUp(() {
    internet = MockInternet();
    wsClient = MockWSClient();
    apiService = MockApiService();
    storage = MockStorage();
    reconnector = MockReconnector();
    worker = MockWorker();
    logger = MockLogger();

    internetStatusController = StreamController<AppInternetStatus>.broadcast();

    service = BinanceCryptoService(
      internet: internet,
      websocketClient: wsClient,
      apiService: apiService,
      storage: storage,
      reconnector: reconnector,
      worker: worker,
      logger: logger,
      restUrl: restUrl,
      wsUrl: wsUrl,
    );

    // Default Mocks
    when(() => internet.onStatusChange)
        .thenAnswer((_) => internetStatusController.stream);
    when(() => internet.status)
        .thenAnswer((_) async => AppInternetStatus.connected);
    when(() => storage.currenciesStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => reconnector.reset()).thenAnswer((_) async {});
    when(() => reconnector.waitNext()).thenAnswer((_) async {});
    when(() => wsClient.disconnect()).thenAnswer((_) async {});
  });

  tearDown(() {
    internetStatusController.close();
    service.dispose();
  });

  group('Initialization and Flow', () {
    test('Should fetch REST data and clear storage on successful connection',
        () {
      fakeAsync((async) {
        when(() => apiService.get(restUrl))
            .thenAnswer((_) async => 'raw_rest_data');
        when(() => worker.execute<String, List<Currency>>(any(), any()))
            .thenAnswer((_) async => tCurrencies);
        when(() => wsClient.connect(wsUrl)).thenAnswer((_) async {});
        when(() => wsClient.rawStream)
            .thenAnswer((_) => const Stream<String>.empty());

        service.init();
        internetStatusController.add(AppInternetStatus.connected);

        async.flushMicrotasks();

        verify(() => apiService.get(restUrl)).called(1);
        verify(() => storage.clear()).called(1);
        verify(() => storage.updateCurrencies(tCurrencies)).called(1);
      });
    });

    test('Should trigger Reconnector when REST API fails', () {
      fakeAsync((async) {
        when(() => apiService.get(restUrl))
            .thenThrow(Exception('Network Error'));

        when(() => reconnector.waitNext())
            .thenAnswer((_) => Completer<void>().future);

        service.init();
        internetStatusController.add(AppInternetStatus.connected);

        async.flushMicrotasks();

        verify(() => reconnector.waitNext()).called(1);
        verify(() => wsClient.disconnect()).called(1);
      });
    });
  });

  group('WebSocket and Throttling', () {
    test('Should throttle multiple WS messages within 2 seconds', () {
      fakeAsync((async) {
        var wsEmitter = StreamController<String>();

        when(() => apiService.get(restUrl)).thenAnswer((_) async => '[]');
        when(() => worker.execute<String, List<Currency>>(any(), any()))
            .thenAnswer((_) async => tCurrencies);
        when(() => wsClient.connect(wsUrl)).thenAnswer((_) async {});
        when(() => wsClient.rawStream).thenAnswer((_) => wsEmitter.stream);

        service.init();
        internetStatusController.add(AppInternetStatus.connected);

        async.elapse(const Duration(milliseconds: 100));

        wsEmitter.add('msg1');
        async.elapse(Duration.zero);

        async.elapse(const Duration(milliseconds: 500));
        wsEmitter.add('msg2');
        async.elapse(const Duration(milliseconds: 500));
        wsEmitter.add('msg3');

        async.elapse(Duration.zero);

        verify(() => storage.updateCurrencies(tCurrencies)).called(2);

        async.elapse(const Duration(milliseconds: 1100));

        wsEmitter.add('msg4');
        async.elapse(Duration.zero);

        verify(() => storage.updateCurrencies(tCurrencies)).called(1);

        wsEmitter.close();
        service.dispose();
        async.flushMicrotasks();
      });
    });

    test('Should disconnect WS when internet is lost', () {
      fakeAsync((async) {
        when(() => apiService.get(any())).thenAnswer((_) async => '[]');
        when(() => worker.execute<String, List<Currency>>(any(), any()))
            .thenAnswer((_) async => []);
        when(() => wsClient.connect(any())).thenAnswer((_) async {});

        var wsController = StreamController<String>();
        when(() => wsClient.rawStream).thenAnswer((_) => wsController.stream);

        service.init();

        internetStatusController.add(AppInternetStatus.connected);
        async.elapse(const Duration(milliseconds: 100));

        internetStatusController.add(AppInternetStatus.disconnected);
        async.elapse(const Duration(milliseconds: 100));

        verify(() => wsClient.disconnect()).called(greaterThan(0));

        service.dispose();
        wsController.close();
        async.flushTimers();
      });
    });

    test('Should reconnect when WS stream times out (no messages for 30s)', () {
      fakeAsync((async) {
        when(() => apiService.get(restUrl)).thenAnswer((_) async => '[]');
        when(() => worker.execute<String, List<Currency>>(any(), any()))
            .thenAnswer((_) async => []);
        when(() => wsClient.connect(wsUrl)).thenAnswer((_) async {});

        when(() => wsClient.rawStream)
            .thenAnswer((_) => StreamController<String>().stream);

        service.init();
        internetStatusController.add(AppInternetStatus.connected);
        async.elapse(const Duration(milliseconds: 100));

        async.elapse(const Duration(seconds: 31));

        verify(() => wsClient.disconnect()).called(greaterThan(0));
        verify(() => reconnector.waitNext()).called(1);
      });
    });

    test('Should reset reconnector when valid WS message is received', () {
      fakeAsync((async) {
        var wsController = StreamController<String>();
        when(() => apiService.get(restUrl)).thenAnswer((_) async => '[]');
        when(() => worker.execute<String, List<Currency>>(any(), any()))
            .thenAnswer((_) async => tCurrencies);
        when(() => wsClient.connect(wsUrl)).thenAnswer((_) async {});
        when(() => wsClient.rawStream).thenAnswer((_) => wsController.stream);

        service.init();
        internetStatusController.add(AppInternetStatus.connected);
        async.elapse(const Duration(milliseconds: 100));

        wsController.add('some_data');
        async.elapse(Duration.zero);

        verify(() => reconnector.reset()).called(1);

        wsController.close();
      });
    });
  });
}

class MockInternet extends Mock implements AppInternetConnection {}

class MockWSClient extends Mock implements AppWebsocketClient {}

class MockApiService extends Mock implements AppApiService {}

class MockStorage extends Mock implements BinanceStorage {}

class MockReconnector extends Mock implements AppReconnector {}

class MockWorker extends Mock implements AppWorkerService {}

class MockLogger extends Mock implements AppLogger {}

class FakeCurrencyList extends Fake implements List<Currency> {}

class FakeWorker implements AppWorkerService {
  @override
  Future<R> execute<T, R>(T message, R Function(T) action) async =>
      action(message);
}
