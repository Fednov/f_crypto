import 'package:flutter/foundation.dart';

import 'package:f_crypto/core/entities/currency.dart';

enum HomeCurrenciesSortType {
  base,
  symbol,
  price,
  changePercent,
  volume,
}

class HomeState {
  final List<Currency> currencyList;
  final String currencySearchQuery;
  final HomeCurrenciesSortType currenciesSortType;
  final bool currenciesSortIsAscending;
  HomeState({
    this.currencyList = const [],
    this.currencySearchQuery = '',
    this.currenciesSortType = HomeCurrenciesSortType.volume,
    this.currenciesSortIsAscending = false,
  });

  HomeState copyWith({
    List<Currency>? currencyList,
    String? currencySearchQuery,
    HomeCurrenciesSortType? currenciesSortType,
    bool? currenciesSortIsAscending,
  }) {
    return HomeState(
      currencyList: currencyList ?? this.currencyList,
      currencySearchQuery: currencySearchQuery ?? this.currencySearchQuery,
      currenciesSortType: currenciesSortType ?? this.currenciesSortType,
      currenciesSortIsAscending:
          currenciesSortIsAscending ?? this.currenciesSortIsAscending,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeState &&
        listEquals(other.currencyList, currencyList) &&
        other.currencySearchQuery == currencySearchQuery &&
        other.currenciesSortType == currenciesSortType &&
        other.currenciesSortIsAscending == currenciesSortIsAscending;
  }

  @override
  int get hashCode {
    return currencyList.hashCode ^
        currencySearchQuery.hashCode ^
        currenciesSortType.hashCode ^
        currenciesSortIsAscending.hashCode;
  }

  @override
  String toString() {
    return 'HomeState(currencyList: $currencyList, currencySearchQuery: $currencySearchQuery, currenciesSortType: $currenciesSortType, currenciesSortIsAscending: $currenciesSortIsAscending)';
  }
}
