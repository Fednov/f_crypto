import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'app_api_service.dart';

class AppApiServiceHttp implements AppApiService {
  final http.Client _client;
  AppApiServiceHttp({
    required http.Client client,
  }) : _client = client;

  @override
  Future<String> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client.get(url, headers: headers).timeout(
            const Duration(seconds: 10),
          );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw ApiException('The request waiting time has expired');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  String _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body;
      case 400:
        throw BadRequestException();
      case 401:
        throw UnauthorizedException();
      case 500:
        throw ServerSideException();
      default:
        throw ApiException('Unknown server error', response.statusCode);
    }
  }
}
