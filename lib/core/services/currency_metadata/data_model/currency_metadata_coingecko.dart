import 'package:f_crypto/core/entities/currency_metadata.dart';
import 'package:f_crypto/core/models/data_model.dart';

class CurrencyMetadataCoingecko implements DataModel<CurrencyMetadata> {
  String? name;
  String? iconUrl;

  CurrencyMetadataCoingecko({
    this.name,
    this.iconUrl,
  });

  CurrencyMetadataCoingecko copyWith({
    String? name,
    String? iconUrl,
  }) {
    return CurrencyMetadataCoingecko(
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  factory CurrencyMetadataCoingecko.fromJson(Map<String, dynamic> json) {
    return CurrencyMetadataCoingecko(
      name: json['name'].toString(),
      iconUrl: json['image'].toString(),
    );
  }

  @override
  CurrencyMetadata toEntity() {
    return CurrencyMetadata(
      name: name,
      iconUrl: iconUrl,
    );
  }
}
