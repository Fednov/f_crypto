import 'package:f_crypto/core/entities/currency_metadata.dart';

abstract class CryptoMetadataService {
  Future<Map<String, CurrencyMetadata?>> fetchCurrenciesMetadata();
}
