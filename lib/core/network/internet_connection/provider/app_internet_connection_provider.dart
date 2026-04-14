import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../app_internet_connection.dart';
import '../app_internet_connection_checker_plus.dart';

final appInternetConnectionProvider =
    Provider.autoDispose<AppInternetConnection>((ref) {
  var internetConnection = InternetConnection();

  return AppInternetConnectionCheckerPlus(
    internetConnection: internetConnection,
  );
});

final appInternetStatusProvider =
    StreamProvider.autoDispose<AppInternetStatus>((ref) {
  var connection = ref.watch(appInternetConnectionProvider);
  return connection.onStatusChange;
});
