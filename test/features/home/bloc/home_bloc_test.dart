import 'dart:async';

import 'package:f_crypto/core/entities/currency.dart';
import 'package:f_crypto/core/services/logger/app_logger.dart';
import 'package:f_crypto/features/home/bloc/home_bloc.dart';
import 'package:f_crypto/features/home/repository/home_repository.dart';
import 'package:f_crypto/features/home/state/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

void main() {
  late HomeRepository mockRepository;
  late HomeBloc homeBloc;
  late AppLogger logger;

  const tCurrency = Currency(
    symbol: '',
    price: 5072,
    priceChangePercent: 2.27,
    volume: 10.0,
  );

  const tSearchQuery = 'btc';

  setUp(() {
    mockRepository = MockHomeRepository();
    logger = MockAppLogger();

    when(() => mockRepository.allCurrenciesStream())
        .thenAnswer((_) => const Stream.empty());
    homeBloc = HomeBloc(
      homePageRepository: mockRepository,
      logger: logger,
    );
  });

  group('HomeBloc Tests', () {
    // 1. Initial State
    test('should have initial state with default values', () {
      expect(homeBloc.debugState, HomeState());
    });

    // 2. Initialization & Stream Subscription
    stateNotifierTest<HomeBloc, HomeState>(
      'should subscribe to repository stream and update currencyList when init is called',
      build: () => homeBloc,
      setUp: () {
        when(() => mockRepository.allCurrenciesStream()).thenAnswer(
          (_) => Stream.value([tCurrency]),
        );
      },
      actions: (bloc) => bloc.init(),
      expect: () => [
        isA<HomeState>()
            .having((state) => state.currencyList, 'currencyList', [tCurrency]),
      ],
      verify: (_) {
        verify(() => mockRepository.allCurrenciesStream()).called(1);
      },
    );

    // 3. Search Logic
    stateNotifierTest<HomeBloc, HomeState>(
      'should update currencySearchQuery when query is changed',
      build: () => homeBloc,
      actions: (bloc) => bloc.onCurrencySearchQueryChanged(tSearchQuery),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.currencySearchQuery, 'query', tSearchQuery),
      ],
    );

    // 4. Sorting Logic - New Type Selected
    stateNotifierTest<HomeBloc, HomeState>(
      'should update sortType and reset ascending to false when a new sort type is selected',
      build: () => homeBloc,
      seed: () => [
        HomeState(
          currenciesSortType: HomeCurrenciesSortType.base,
          currenciesSortIsAscending: true,
        )
      ],
      actions: (bloc) =>
          bloc.onSortButtonPressed(sortType: HomeCurrenciesSortType.price),
      skip: 1,
      expect: () => [
        isA<HomeState>()
            .having((s) => s.currenciesSortType, 'type',
                HomeCurrenciesSortType.price)
            .having((s) => s.currenciesSortIsAscending, 'isAscending', false),
      ],
    );

    // 5. Sorting Logic - Toggle Ascending
    stateNotifierTest<HomeBloc, HomeState>(
      'should toggle currenciesSortIsAscending when the same sort type is selected (not base or volume)',
      build: () => homeBloc,
      seed: () => [
        HomeState(
          currenciesSortType: HomeCurrenciesSortType.price,
          currenciesSortIsAscending: false,
        )
      ],
      actions: (bloc) =>
          bloc.onSortButtonPressed(sortType: HomeCurrenciesSortType.price),
      skip: 1,
      expect: () => [
        isA<HomeState>()
            .having((s) => s.currenciesSortIsAscending, 'isAscending', true),
      ],
    );

    // 6. Sorting Logic - No Toggle for Base/Volume
    stateNotifierTest<HomeBloc, HomeState>(
      'should not toggle currenciesSortIsAscending if the same sort type is base',
      build: () => homeBloc,
      seed: () => [
        HomeState(
          currenciesSortType: HomeCurrenciesSortType.base,
          currenciesSortIsAscending: false,
        )
      ],
      actions: (bloc) =>
          bloc.onSortButtonPressed(sortType: HomeCurrenciesSortType.base),
      skip: 1,
      expect: () => [], // No state change expected
    );

    // 7. Repository Interaction
    test(
        'should call restartCurrenciesStream in repository when restart button is pressed',
        () {
      when(() => mockRepository.restartCurrenciesStream()).thenReturn(null);

      homeBloc.onRestartCurrenciesStreamButtonPressed();

      verify(() => mockRepository.restartCurrenciesStream()).called(1);
    });

    // 8. Lifecycle/Dispose
    test('should cancel stream subscription when dispose is called', () async {
      var controller = StreamController<List<Currency>>();
      when(() => mockRepository.allCurrenciesStream())
          .thenAnswer((_) => controller.stream);

      homeBloc.init();
      expect(controller.hasListener, isTrue);

      homeBloc.dispose();
      // Small delay to allow subscription cancellation to propagate
      await Future.delayed(Duration.zero);
      expect(controller.hasListener, isFalse);
    });
  });
}

class MockHomeRepository extends Mock implements HomeRepository {}

class MockAppLogger extends Mock implements AppLogger {}
