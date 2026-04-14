import 'dart:async';

import 'package:f_crypto/core/entities/currency.dart';
import 'package:rxdart/rxdart.dart';

class BinanceStorage {
  final _currenciescontroller = BehaviorSubject<List<Currency>>();
  Stream<List<Currency>> get currenciesStream => _currenciescontroller.stream;

  final Map<String, Currency> _currencies = {};

  void updateCurrencies(List<Currency> newList) {
    bool hasChanges = false;

    for (final updated in newList) {
      final existing = _currencies[updated.symbol];

      if (existing == null ||
          existing.price != updated.price ||
          existing.priceChangePercent != updated.priceChangePercent) {
        _currencies[updated.symbol] = updated;
        hasChanges = true;
      }
    }

    if (hasChanges) {
      _currenciescontroller.add(_currencies.values.toList());
    }
  }

  void clear() {
    _currencies.clear();
  }

  void refresh(List<Currency> newList) {
    _currencies.clear();
    updateCurrencies(newList);
  }

  void dispose() => _currenciescontroller.close();
}
