import 'dart:async';

import 'package:f_crypto/core/services/logger/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/home_repository.dart';
import '../state/home_state.dart';

class HomeBloc extends StateNotifier<HomeState> {
  HomeBloc({
    required HomeRepository homePageRepository,
    required AppLogger logger,
  })  : _homePageRepository = homePageRepository,
        _logger = logger,
        super(HomeState());

  final HomeRepository _homePageRepository;
  final AppLogger _logger;

  StreamSubscription? _currencyListSubscription;

  void init() {
    _currencyListSubscription?.cancel();

    _currencyListSubscription =
        _homePageRepository.allCurrenciesStream().listen(
      (data) {
        if (!mounted) return;

        var updatedList = data;

        state = state.copyWith(currencyList: [...updatedList]);
      },
      onError: (error, stack) => _logger.log(error, stackTrace: stack),
    );
  }

  void onRestartCurrenciesStreamButtonPressed() {
    _homePageRepository.restartCurrenciesStream();
  }

  void onCurrencySearchQueryChanged(String query) {
    state = state.copyWith(currencySearchQuery: query);
  }

  void onSortButtonPressed({required HomeCurrenciesSortType sortType}) {
    _selectCurrenciesSortType(sortType: sortType);
  }

  void _selectCurrenciesSortType({required HomeCurrenciesSortType sortType}) {
    final isSameType = state.currenciesSortType == sortType;
    final isBaseType = sortType == HomeCurrenciesSortType.base;
    final isVolumeType = sortType == HomeCurrenciesSortType.volume;

    if (!isSameType) {
      state = state.copyWith(
        currenciesSortType: sortType,
        currenciesSortIsAscending: false,
      );
      return;
    }

    if (!isBaseType && !isVolumeType) {
      state = state.copyWith(
        currenciesSortIsAscending: !state.currenciesSortIsAscending,
      );
    }
  }

  @override
  void dispose() {
    _currencyListSubscription?.cancel();
    super.dispose();
  }
}
