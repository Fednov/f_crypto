import 'package:f_crypto/core/extensions/buildcontext_extensions.dart';
import 'package:f_crypto/core/utils/constants/app_strings.dart';
import 'package:f_crypto/features/home/bloc/provider/home_state_provider.dart';
import 'package:f_crypto/features/home/widgets/home_base_currency_table_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/home_state.dart';

class HomeCurrencyTableHeader extends ConsumerWidget {
  const HomeCurrencyTableHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = context.themeOf;

    return DefaultTextStyle(
      style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ) ??
          const TextStyle(),
      child: IntrinsicHeight(
        child: HomeBaseCurrencyTableRow(
            icon: IconButton(
              tooltip: AppStrings.tooltipResetSorting,
              onPressed: () => ref
                  .read(homeStateProvider.notifier)
                  .onSortButtonPressed(sortType: HomeCurrenciesSortType.volume),
              icon: const Icon(Icons.refresh),
            ),
            name: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HeaderText(
                  sortType: HomeCurrenciesSortType.symbol,
                  isArrowOnRight: true,
                  text: 'Name',
                ),
              ],
            ),
            price: const _HeaderText(
              sortType: HomeCurrenciesSortType.price,
              text: 'Price',
            ),
            changePercent: const _HeaderText(
              sortType: HomeCurrenciesSortType.changePercent,
              text: '24h change',
            )),
      ),
    );
  }
}

class _HeaderText extends ConsumerWidget {
  const _HeaderText({
    required this.text,
    required this.sortType,
    this.isArrowOnRight = false,
  });

  final String text;
  final HomeCurrenciesSortType sortType;
  final bool isArrowOnRight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isSelected = ref.watch(
      homeStateProvider.select(
        (state) => state.currenciesSortType == sortType,
      ),
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => ref
            .read(homeStateProvider.notifier)
            .onSortButtonPressed(sortType: sortType),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isArrowOnRight)
              _OrderArrow(
                isSelected: isSelected,
              ),
            Text(
              text,
            ),
            if (isArrowOnRight)
              _OrderArrow(
                isSelected: isSelected,
              ),
          ],
        ),
      ),
    );
  }
}

class _OrderArrow extends ConsumerWidget {
  const _OrderArrow({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isAscending = ref.watch(
      homeStateProvider.select(
        (state) => state.currenciesSortIsAscending,
      ),
    );

    return Visibility(
      visible: isSelected,
      maintainAnimation: true,
      maintainState: true,
      maintainSize: true,
      child: Icon(
        isAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
      ),
    );
  }
}
