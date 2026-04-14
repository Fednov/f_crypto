import 'package:f_crypto/core/entities/currency.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_state_provider.dart';

final homeFilteredCurrenciesProvider = Provider.autoDispose<List<Currency>>(
  (ref) {
    var currencySearchQuery = ref.watch(
      homeStateProvider
          .select((state) => state.currencySearchQuery.toLowerCase()),
    );

    var currencyList = ref.watch(
      homeStateProvider.select((state) => state.currencyList),
    );

    return currencySearchQuery.isEmpty
        ? currencyList
        : currencyList
            .where((element) =>
                element.symbol.toLowerCase().contains(currencySearchQuery))
            .toList();
  },
);
