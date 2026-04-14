import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../app_api_service.dart';
import '../app_api_service_http.dart';

final appApiServiceProvider = Provider<AppApiService>((ref) {
  var client = http.Client();

  var apiService = AppApiServiceHttp(client: client);

  ref.onDispose(() => client.close());

  return apiService;
});
