class CurrencyMetadata {
  final String? name;
  final String? iconUrl;

  const CurrencyMetadata({
    this.name,
    this.iconUrl,
  });

  CurrencyMetadata copyWith({
    String? name,
    String? iconUrl,
  }) {
    return CurrencyMetadata(
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrencyMetadata &&
        other.name == name &&
        other.iconUrl == iconUrl;
  }

  @override
  int get hashCode => name.hashCode ^ iconUrl.hashCode;

  @override
  String toString() => 'CurrencyMetadata(name: $name, iconUrl: $iconUrl)';
}
