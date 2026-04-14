import 'package:f_crypto/core/entities/currency_metadata.dart';
import 'package:f_crypto/core/services/currency_metadata/provider/currencies_metadata_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currencyMetadataProvider =
    Provider.family.autoDispose<CurrencyMetadata?, String>((ref, symbol) {
  return ref.watch(currenciesMetadataProvider.select(
    (asyncMap) => asyncMap.valueOrNull?[symbol],
  ));
});
