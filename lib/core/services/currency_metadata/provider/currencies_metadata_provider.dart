import 'dart:developer';

import 'package:f_crypto/core/entities/currency_metadata.dart';
import 'package:f_crypto/core/network/reconnector/app_reconnector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'currency_metadata_service_provider.dart';

final currenciesMetadataProvider =
    FutureProvider<Map<String, CurrencyMetadata?>>((ref) async {
  final service = ref.watch(currencyMetadataServiceProvider);
  final reconnector = AppReconnector();

  ref.keepAlive();

  ref.onDispose(() => reconnector.dispose());

  try {
    final data = await service.fetchCurrenciesMetadata();

    reconnector.reset();
    return data;
  } catch (e, stack) {
    log('Error when fetching currencies metadata: $e \n $stack');
    await reconnector.waitNext();

    ref.invalidateSelf();

    rethrow;
  }
});
