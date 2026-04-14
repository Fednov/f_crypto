enum AppInternetStatus { connected, disconnected }

abstract class AppInternetConnection {
  Stream<AppInternetStatus> get onStatusChange;
  Future<AppInternetStatus> get status;
}
