import 'package:f_crypto/core/entities/currency.dart';

abstract class CryptoService {
  Stream<List<Currency>> allCurrenciesStream();
  void restartService();
}
