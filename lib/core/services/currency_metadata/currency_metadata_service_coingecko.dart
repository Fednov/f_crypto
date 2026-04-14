import 'dart:convert';
import 'dart:developer';

import 'package:f_crypto/core/network/api_service/app_api_service.dart';
import 'package:f_crypto/core/entities/currency_metadata.dart';

import 'currency_metadata_service.dart';
import 'data_model/currency_metadata_coingecko.dart';

class CurrencyMetadataServiceCoingecko implements CryptoMetadataService {
  CurrencyMetadataServiceCoingecko({
    required AppApiService appApiService,
  }) : _appApiService = appApiService;

  final AppApiService _appApiService;

  @override
  Future<Map<String, CurrencyMetadata?>> fetchCurrenciesMetadata() async {
    try {
      var responseBody = await _appApiService.get(
        Uri.parse(
            'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'),
      );

      List<dynamic> decodedData = json.decode(responseBody);
      var currenciesMetadataFromJson = {
        for (var json in decodedData)
          json['symbol'].toString().toLowerCase():
              CurrencyMetadataCoingecko.fromJson(json).toEntity()
      };

      return currenciesMetadataFromJson;
    } catch (e, stack) {
      log('Error when fetching currencies metadata: $e \n $stack');
      rethrow;
    }
  }
}
