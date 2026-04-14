import 'package:f_crypto/core/network/api_service/provider/app_api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../currency_metadata_service.dart';
import '../currency_metadata_service_coingecko.dart';

final currencyMetadataServiceProvider =
    Provider.autoDispose<CryptoMetadataService>((ref) {
  var appApiService = ref.watch(appApiServiceProvider);

  return CurrencyMetadataServiceCoingecko(
    appApiService: appApiService,
  );
});
