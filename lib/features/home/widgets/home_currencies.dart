import 'package:f_crypto/core/utils/constants/app_strings.dart';
import 'package:f_crypto/features/home/bloc/provider/home_displayed_currencies_provider.dart';
import 'package:f_crypto/features/home/bloc/provider/home_state_provider.dart';
import 'package:f_crypto/features/home/widgets/home_currency_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeCurrencies extends ConsumerWidget {
  const HomeCurrencies({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var listLength = ref.watch(
      homeDisplayedCurrenciesProvider.select(
        (list) => list.length,
      ),
    );

    var isSearching = ref.watch(
      homeStateProvider.select(
        (state) => state.currencySearchQuery.isNotEmpty,
      ),
    );

    if (listLength == 0 && isSearching) {
      return const Center(
        child: Text(AppStrings.messageNoMatchingItems),
      );
    }

    if (listLength == 0) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    var itemExtent = HomeCurrencyRow.calculateHeight(context);

    return ListView.builder(
      itemExtent: itemExtent,
      itemCount: listLength,
      itemBuilder: (context, index) {
        return HomeCurrencyRow(
          index: index,
        );
      },
    );
  }
}