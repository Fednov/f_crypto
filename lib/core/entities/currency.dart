class Currency {
  final String symbol;
  final double price;
  final double priceChangePercent;
  final double volume;

  const Currency({
    required this.symbol,
    required this.price,
    required this.priceChangePercent,
    required this.volume,
  });

  Currency copyWith({
    String? symbol,
    double? price,
    double? priceChangePercent,
    double? volume,
  }) {
    return Currency(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      priceChangePercent: priceChangePercent ?? this.priceChangePercent,
      volume: volume ?? this.volume,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Currency &&
        other.symbol == symbol &&
        other.price == price &&
        other.priceChangePercent == priceChangePercent &&
        other.volume == volume;
  }

  @override
  int get hashCode {
    return symbol.hashCode ^
        price.hashCode ^
        priceChangePercent.hashCode ^
        volume.hashCode;
  }

  @override
  String toString() {
    return 'Currency(symbol: $symbol, price: $price, priceChangePercent: $priceChangePercent, volume: $volume)';
  }
}
