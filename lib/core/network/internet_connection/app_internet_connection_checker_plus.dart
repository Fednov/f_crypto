import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'app_internet_connection.dart';

class AppInternetConnectionCheckerPlus implements AppInternetConnection {
  AppInternetConnectionCheckerPlus({
    required this.internetConnection,
  }) {
    onStatusChange = internetConnection.onStatusChange
        .map(_mapInternetStatusToAppInternetStatus)
        .asBroadcastStream();
  }

  final InternetConnection internetConnection;

  @override
  late final Stream<AppInternetStatus> onStatusChange;

  @override
  Future<AppInternetStatus> get status => internetConnection.internetStatus
      .then(_mapInternetStatusToAppInternetStatus);

  AppInternetStatus _mapInternetStatusToAppInternetStatus(
      InternetStatus internetStatus) {
    switch (internetStatus) {
      case InternetStatus.connected:
        return AppInternetStatus.connected;
      case InternetStatus.disconnected:
        return AppInternetStatus.disconnected;
    }
  }
}
