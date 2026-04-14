import 'package:f_crypto/core/entities/currency.dart';
import 'package:f_crypto/features/home/bloc/provider/home_displayed_currencies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeSingleCurrencyProvider = Provider.family.autoDispose<Currency?, int>(
  (ref, index) {
    var homeFilteredList = ref.watch(homeDisplayedCurrenciesProvider);

    return homeFilteredList.length > index ? homeFilteredList[index] : null;
  },
);
