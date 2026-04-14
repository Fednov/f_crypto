import 'dart:async';

import 'package:f_crypto/core/network/websocket_client/app_websocket_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AppWSClientWebsocketChannel implements AppWebsocketClient {
  WebSocketChannel? _channel;
  bool _isConnecting = false;

  @override
  Stream<dynamic>? rawStream;

  @override
  Future<void> connect(Uri url) async {
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      await disconnect();
      _channel = WebSocketChannel.connect(url);

      rawStream = _channel?.stream.asBroadcastStream();
      await _channel?.ready.timeout(const Duration(seconds: 10));
    } finally {
      _isConnecting = false;
    }
  }

  @override
  void send(dynamic message) {
    _channel?.sink.add(message);
  }

  @override
  Future<void> disconnect() async {
    // if (_channel?.sink != null) Future.microtask(() => _channel?.sink.close());
    var channelToClose = _channel;
    _channel = null;
    rawStream = null;

    await channelToClose?.sink.close();
  }
}
