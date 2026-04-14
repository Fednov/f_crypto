// ignore_for_file: invalid_use_of_protected_member

import 'package:f_crypto/features/home/bloc/home_bloc.dart';
import 'package:f_crypto/features/home/bloc/provider/home_filtered_currencies_provider.dart';
import 'package:f_crypto/features/home/state/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:f_crypto/core/entities/currency.dart';
import 'package:f_crypto/features/home/bloc/provider/home_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late ProviderContainer container;
  late MockHomeBloc mockHomeBloc;

  const tCurrencyList = [
    Currency(
        symbol: 'BTC', price: 70000.0, priceChangePercent: 2.15, volume: 100),
    Currency(symbol: 'ETH', price: 2000.0, priceChangePercent: 3.0, volume: 500),
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

  group('homeFilteredCurrenciesProvider', () {
    test('should return all currencies when search query is empty', () {
      mockHomeBloc.state = HomeState(
        currencyList: tCurrencyList,
        currencySearchQuery: '',
      );

      final filtered = container.read(homeFilteredCurrenciesProvider);

      expect(filtered.length, tCurrencyList.length);
      expect(filtered, tCurrencyList);
    });

    test('should filter list by symbol regardless of case', () {
      mockHomeBloc.state = HomeState(
        currencyList: tCurrencyList,
        currencySearchQuery: tCurrencyList.first.symbol.toLowerCase(),
      );

      final filtered = container.read(homeFilteredCurrenciesProvider);

      expect(filtered.length, 1);
      expect(filtered.first.symbol, tCurrencyList.first.symbol);
    });

    test('should return empty list if no matches', () {
      mockHomeBloc.state = HomeState(
        currencyList: tCurrencyList,
        currencySearchQuery: 'unknown',
      );

      final filtered = container.read(homeFilteredCurrenciesProvider);

      expect(filtered, isEmpty);
    });
  });
}

class MockHomeBloc extends StateNotifier<HomeState>
    with Mock
    implements HomeBloc {
  MockHomeBloc() : super(HomeState());
}

