import 'binance_currency.dart';

class BinanceCurrencyFromSocket
    extends BinanceCurrency<BinanceCurrencyFromSocket> {
  const BinanceCurrencyFromSocket({
    required super.symbol,
    required super.lastPrice,
    required super.openPrice,
    required super.volume,
  });

  factory BinanceCurrencyFromSocket.fromJson(Map<String, dynamic> json) {
    return BinanceCurrencyFromSocket(
      symbol: json['s'] ?? '',
      lastPrice: double.tryParse(json['c'].toString()) ?? 0.0,
      openPrice: double.tryParse(json['o'].toString()) ?? 0.0,
      volume: double.tryParse(json['q'].toString()) ?? 0.0,
    );
  }

  @override
  BinanceCurrencyFromSocket copyWith({
    String? symbol,
    double? lastPrice,
    double? openPrice,
    double? volume,
  }) {
    return BinanceCurrencyFromSocket(
      symbol: symbol ?? this.symbol,
      lastPrice: lastPrice ?? this.lastPrice,
      openPrice: openPrice ?? this.openPrice,
      volume: volume ?? this.volume,
    );
  }

  @override
  String get rawSymbol => symbol;
}
