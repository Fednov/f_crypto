import 'package:f_crypto/core/network/api_service/provider/app_api_service_provider.dart';
import 'package:f_crypto/core/network/internet_connection/provider/app_internet_connection_provider.dart';
import 'package:f_crypto/core/network/reconnector/app_reconnector.dart';
import 'package:f_crypto/core/network/websocket_client/app_ws_client_websocket_channel.dart';
import 'package:f_crypto/core/services/crypto/crypto_service.dart';
import 'package:f_crypto/core/services/logger/app_logger_developer.dart';
import 'package:f_crypto/core/services/worker/app_worker_service_worker_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../binance_crypto_service/binance_storage.dart';
import '../binance_crypto_service/binance_crypto_service.dart';

final cryptoServiceProvider = Provider.autoDispose<CryptoService>(
  (ref) {
    var internetConnection = ref.watch(appInternetConnectionProvider);
    var appApiService = ref.watch(appApiServiceProvider);
    var appWebsocketClient = AppWSClientWebsocketChannel();
    var binanceStorage = BinanceStorage();
    var reconnector = AppReconnector();
    var worker = AppWorkerServiceWorkerManager();
    var logger = AppLoggerDeveloper();

    var wsUrl = Uri(
      scheme: 'wss',
      host: 'stream.binance.com',
      port: 9443,
      path: '/ws/!miniTicker@arr',
    );

    var restUrl = Uri.parse('https://api.binance.com/api/v3/ticker/24hr');

    var binanceCryptoService = BinanceCryptoService(
      internet: internetConnection,
      websocketClient: appWebsocketClient,
      storage: binanceStorage,
      reconnector: reconnector,
      apiService: appApiService,
      worker: worker,
      logger: logger,
      restUrl: restUrl,
      wsUrl: wsUrl,
    );

    binanceCryptoService.init();

    ref.onDispose(() => binanceCryptoService.dispose());

    return binanceCryptoService;
  },
);
