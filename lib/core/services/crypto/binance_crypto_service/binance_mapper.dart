import 'dart:convert';
import 'dart:developer';

import 'package:f_crypto/core/entities/currency.dart';

import 'data_model/binance_currency.dart';

final class BinanceMapper {
  BinanceMapper._();

  static List<Currency> parse<T extends BinanceCurrency<T>>(
    String data,
    T Function(Map<String, dynamic> json) fromJson, {
    T Function(T model)? formatter,
    bool Function(T model)? filter,
    int Function(T a, T b)? sort,
  }) {
    try {
      List<dynamic> decoded = jsonDecode(data);
      var dataModels = decoded
          .whereType<Map<String, dynamic>>()
          .map(fromJson)
          .where(filter ?? filterUSDT)
          .toList();

      if (sort != null) {
        dataModels.sort(sort);
      }

      return dataModels
          .map((model) => (formatter?.call(model) ?? model).toEntity())
          .toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  static bool filterAll<T extends BinanceCurrency<T>>(T model) => true;
  static bool filterUSDT<T extends BinanceCurrency<T>>(T model) =>
      model.rawSymbol.endsWith('USDT');

  static T cleanUSDTFormatter<T extends BinanceCurrency<T>>(T model) {
    return model.copyWith(symbol: model.symbol.replaceAll('USDT', ''));
  }

  static int sortByVolumeDesc(BinanceCurrency a, BinanceCurrency b) =>
      b.volume.compareTo(a.volume);
}
