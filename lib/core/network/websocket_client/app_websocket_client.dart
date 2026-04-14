abstract class AppWebsocketClient {
  Future<void> connect(Uri url);
  Future<void> disconnect();
  Stream<dynamic>? rawStream;
  void send(dynamic message);
}
