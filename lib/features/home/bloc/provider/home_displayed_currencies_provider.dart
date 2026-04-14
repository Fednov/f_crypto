import 'package:f_crypto/core/entities/currency.dart';
import 'package:f_crypto/core/utils/currency_comparator/currency_comparator.dart';
import 'package:f_crypto/features/home/bloc/provider/home_filtered_currencies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/home_state.dart';
import 'home_state_provider.dart';

final homeDisplayedCurrenciesProvider = Provider.autoDispose<List<Currency>>(
  (ref) {
    var currenciesSortType = ref.watch(
      homeStateProvider.select((state) => state.currenciesSortType),
    );

    var currenciesSortIsAscending = ref.watch(
        homeStateProvider.select((state) => state.currenciesSortIsAscending));

    var currencyList = ref.watch(homeFilteredCurrenciesProvider);

    var comparator = _comparators[currenciesSortType];

    if (comparator != null) {
      var sortedList = [...currencyList]..sort(
          (a, b) => comparator(a, b, currenciesSortIsAscending),
        );

      return sortedList;
    }

    return currencyList;
  },
);

const Map<HomeCurrenciesSortType, CurrencyComparator?> _comparators = {
  HomeCurrenciesSortType.base: null,
  HomeCurrenciesSortType.symbol: SymbolComparator(),
  HomeCurrenciesSortType.price: PriceComparator(),
  HomeCurrenciesSortType.changePercent: ChangePercentComparator(),
  HomeCurrenciesSortType.volume: VolumePercentComparator(),
};
