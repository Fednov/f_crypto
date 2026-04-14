import 'package:f_crypto/core/entities/currency.dart';
import 'package:f_crypto/core/models/data_model.dart';

abstract class BinanceCurrency<T extends BinanceCurrency<T>>
    implements DataModel<Currency> {
  const BinanceCurrency({
    required this.symbol,
    required this.lastPrice,
    required this.openPrice,
    required this.volume,
  });

  final String symbol;
  final double lastPrice;
  final double openPrice;
  final double volume;

  String get rawSymbol;

  T copyWith({
    String? symbol,
    double? lastPrice,
    double? openPrice,
    double? volume,
  });

  @override
  Currency toEntity() {
    return Currency(
      symbol: symbol,
      price: lastPrice,
      priceChangePercent: getPriceChangePercent,
      volume: volume,
    );
  }

  double get getPriceChangePercent {
    if (openPrice == 0) return 0.0;
    return ((lastPrice - openPrice) / openPrice) * 100;
  }
}
