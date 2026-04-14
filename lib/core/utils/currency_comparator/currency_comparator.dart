import 'package:f_crypto/core/entities/currency.dart';

enum SortOrder { asc, desc }

sealed class CurrencyComparator {
  const CurrencyComparator();

  int call(Currency a, Currency b, bool order);
}

class SymbolComparator implements CurrencyComparator {
  const SymbolComparator();

  @override
  int call(Currency a, Currency b, bool order) {
    return order ? a.symbol.compareTo(b.symbol) : b.symbol.compareTo(a.symbol);
  }
}

class PriceComparator implements CurrencyComparator {
  const PriceComparator();

  @override
  int call(Currency a, Currency b, bool order) {
    return order ? a.price.compareTo(b.price) : b.price.compareTo(a.price);
  }
}

class ChangePercentComparator implements CurrencyComparator {
  const ChangePercentComparator();

  @override
  int call(Currency a, Currency b, bool order) {
    return order
        ? a.priceChangePercent.compareTo(b.priceChangePercent)
        : b.priceChangePercent.compareTo(a.priceChangePercent);
  }
}

class VolumePercentComparator implements CurrencyComparator {
  const VolumePercentComparator();

  @override
  int call(Currency a, Currency b, bool order) {
    return order ? a.volume.compareTo(b.volume) : b.volume.compareTo(a.volume);
  }
}
