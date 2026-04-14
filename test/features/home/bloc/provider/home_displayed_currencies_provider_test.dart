// ignore_for_file: invalid_use_of_protected_member

import 'package:f_crypto/core/entities/currency.dart';
import 'package:f_crypto/features/home/bloc/home_bloc.dart';
import 'package:f_crypto/features/home/bloc/provider/home_displayed_currencies_provider.dart';
import 'package:f_crypto/features/home/bloc/provider/home_state_provider.dart';
import 'package:f_crypto/features/home/state/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late ProviderContainer container;
  late MockHomeBloc mockHomeBloc;

  const tCurrencyList = [
    Currency(
        symbol: 'BTC', price: 70000.0, priceChangePercent: 2.15, volume: 100),
    Currency(
        symbol: 'ETH', price: 2000.0, priceChangePercent: 3.0, volume: 500),
    Currency(symbol: 'USDT', price: 1.0, priceChangePercent: 1.5, volume: 50),
  ];

  setUp(() {
    mockHomeBloc = MockHomeBloc();
    container = ProviderContainer(
      overrides: [
        homeStateProvider.overrideWith((ref) => mockHomeBloc),
      ],
    );
  });

  group('homeDisplayedCurrenciesProvider', () {
    test('should return unsorted list when sort type is base', () {
      mockHomeBloc.state = HomeState(
        currencyList: tCurrencyList,
        currenciesSortType: HomeCurrenciesSortType.base,
      );

      final result = container.read(homeDisplayedCurrenciesProvider);

      expect(result, tCurrencyList);
    });

    test('should sort currencies by symbol in descending order', () {
      mockHomeBloc.state = HomeState(
        currencyList: tCurrencyList,
        currenciesSortType: HomeCurrenciesSortType.symbol,
        currenciesSortIsAscending: false,
      );

      final result = container.read(homeDisplayedCurrenciesProvider);

      expect(result.first.symbol, equals(tCurrencyList[2].symbol));
      expect(result.last.symbol, equals(tCurrencyList[0].symbol));
    });

    test('should sort currencies by price in ascending order', () {
      mockHomeBloc.state = HomeState(
        currencyList: tCurrencyList,
        currenciesSortType: HomeCurrenciesSortType.price,
        currenciesSortIsAscending: true,
      );

      final result = container.read(homeDisplayedCurrenciesProvider);

      expect(result[0], equals(tCurrencyList[2]));
      expect(result[1], equals(tCurrencyList[1]));
      expect(result[2], equals(tCurrencyList[0]));
    });

    test('should sort currencies by volume in descending order', () {
      mockHomeBloc.state = HomeState(
        currencyList: tCurrencyList,
        currenciesSortType: HomeCurrenciesSortType.volume,
        currenciesSortIsAscending: false,
      );

      final result = container.read(homeDisplayedCurrenciesProvider);

      expect(result.first.symbol, equals(tCurrencyList[1].symbol));
      expect(result[1].symbol, equals(tCurrencyList[0].symbol));
      expect(result.last.symbol, equals(tCurrencyList[2].symbol));
    });

    test('should apply sorting to the already filtered list', () {
      mockHomeBloc.state = HomeState(
        currencyList: tCurrencyList,
        currencySearchQuery: tCurrencyList[1].symbol.toLowerCase(),
        currenciesSortType: HomeCurrenciesSortType.price,
        currenciesSortIsAscending: true,
      );

      final result = container.read(homeDisplayedCurrenciesProvider);

      expect(result.length, 1);
      expect(result.first, equals(tCurrencyList[1]));
    });
  });
}

class MockHomeBloc extends StateNotifier<HomeState>
    with Mock
    implements HomeBloc {
  MockHomeBloc() : super(HomeState());
}
