import 'package:f_crypto/core/entities/currency.dart';
import 'package:f_crypto/core/services/crypto/crypto_service.dart';

class HomeRepository {
  HomeRepository({
    required CryptoService cryptoService,
  }) : _cryptoService = cryptoService;

  final CryptoService _cryptoService;

  Stream<List<Currency>> allCurrenciesStream() {
    return _cryptoService.allCurrenciesStream();
  }

  void restartCurrenciesStream() {
    _cryptoService.restartService();
  }
}

