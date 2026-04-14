import 'binance_currency.dart';

class BinanceCurrencyFromApi extends BinanceCurrency<BinanceCurrencyFromApi> {
  const BinanceCurrencyFromApi({
    required super.symbol,
    required super.lastPrice,
    required super.openPrice,
    required super.volume,
  });

  factory BinanceCurrencyFromApi.fromJson(Map<String, dynamic> json) {
    return BinanceCurrencyFromApi(
      symbol: json['symbol'] ?? '',
      lastPrice: double.tryParse(json['lastPrice'].toString()) ?? 0.0,
      openPrice: double.tryParse(json['openPrice'].toString()) ?? 0.0,
      volume: double.tryParse(json['quoteVolume'].toString()) ?? 0.0,
    );
  }

  @override
  BinanceCurrencyFromApi copyWith({
    String? symbol,
    double? lastPrice,
    double? openPrice,
    double? volume,
  }) {
    return BinanceCurrencyFromApi(
      symbol: symbol ?? this.symbol,
      lastPrice: lastPrice ?? this.lastPrice,
      openPrice: openPrice ?? this.openPrice,
      volume: volume ?? this.volume,
    );
  }

  @override
  String get rawSymbol => symbol;
}
