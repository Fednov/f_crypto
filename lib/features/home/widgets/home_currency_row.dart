import 'package:cached_network_image/cached_network_image.dart';
import 'package:f_crypto/core/extensions/buildcontext_extensions.dart';
import 'package:f_crypto/core/extensions/double_formatter.dart';
import 'package:f_crypto/core/services/currency_metadata/provider/currency_metadata_provider.dart';
import 'package:f_crypto/core/ui/theme/extensions/currency_theme_extension.dart';
import 'package:f_crypto/features/home/widgets/home_base_currency_table_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bloc/provider/home_single_currency_provider.dart';

class HomeCurrencyRow extends StatelessWidget {
  const HomeCurrencyRow({
    super.key,
    required this.index,
  });

  final int index;

  static const double _rowHeightFactor = 0.0724;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: calculateHeight(context),
      child: HomeBaseCurrencyTableRow(
        icon: _CurrencyIcon(
          index: index,
        ),
        name: _CurrencyName(
          index: index,
        ),
        price: _CurrencyPrice(
          index: index,
        ),
        changePercent: _PercentBadge(
          index: index,
        ),
      ),
    );
  }

  static double calculateHeight(BuildContext context) {
    var size = context.sizeOf;
    var textScale =
        MediaQuery.maybeTextScalerOf(context) ?? TextScaler.noScaling;
    return textScale.scale(size.height * _rowHeightFactor);
  }
}

class _CurrencyIcon extends ConsumerWidget {
  const _CurrencyIcon({
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = context.themeOf;

    var currencySymbol = ref.watch(
      homeSingleCurrencyProvider(index).select((state) => state?.symbol),
    );

    if (currencySymbol == null) {
      return const SizedBox.shrink();
    }

    var currencyMetadataIconUrl = ref.watch(
      currencyMetadataProvider(
        currencySymbol.toLowerCase(),
      ).select((state) => state?.iconUrl),
    );

    return CircleAvatar(
      backgroundColor: theme.colorScheme.surfaceBright,
      child: ClipOval(
        child: currencyMetadataIconUrl != null
            ? CachedNetworkImage(imageUrl: currencyMetadataIconUrl)
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  currencySymbol.isEmpty ? '' : currencySymbol.characters.first,
                  style: theme.textTheme.titleMedium,
                ),
              ),
      ),
    );
  }
}

class _CurrencyName extends ConsumerWidget {
  const _CurrencyName({
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = context.themeOf;

    var currencySymbol = ref.watch(
      homeSingleCurrencyProvider(index).select((state) => state?.symbol),
    );

    if (currencySymbol == null) {
      return const SizedBox.shrink();
    }

    var currencyMetadataName = ref.watch(
      currencyMetadataProvider(
        currencySymbol.toLowerCase(),
      ).select((state) => state?.name),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            currencySymbol,
            maxLines: 1,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        if (currencyMetadataName != null)
          Text(
            currencyMetadataName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _CurrencyPrice extends ConsumerWidget {
  const _CurrencyPrice({
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = context.themeOf;

    var currencyPrice = ref.watch(
      homeSingleCurrencyProvider(index).select((state) => state?.price),
    );

    if (currencyPrice == null) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: FittedBox(
        child: Text(
          '${currencyPrice.toSmartPrice()} \$',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}

class _PercentBadge extends ConsumerWidget {
  const _PercentBadge({required this.index});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = context.themeOf;
    var currencyTheme = context.themeOf.extension<CurrencyThemeExtension>();

    var changePercent = ref.watch(
      homeSingleCurrencyProvider(index)
          .select((state) => state?.priceChangePercent),
    );

    if (changePercent == null) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _calculateBadgeColor(
            context: context,
            changePercent: changePercent,
          ),
          borderRadius: BorderRadius.circular(
            4,
          ),
        ),
        child: Text(
          '${_calculatePrefixSign(changePercent: changePercent)}${changePercent.asPercentChangeString}%',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge?.copyWith(
            color: currencyTheme?.text ?? Colors.white,
          ),
        ),
      ),
    );
  }

  Color _calculateBadgeColor({
    required BuildContext context,
    required double changePercent,
  }) {
    var currencyTheme = context.themeOf.extension<CurrencyThemeExtension>();
    var formattedChangePercent = changePercent.asPercentChange;

    if (formattedChangePercent > 0) {
      return currencyTheme?.positive ?? const Color(0xff21BF73);
    }
    if (formattedChangePercent < 0) {
      return currencyTheme?.negative ?? const Color(0xffD9534F);
    }

    return currencyTheme?.neutral ?? Colors.grey;
  }

  String _calculatePrefixSign({required double changePercent}) {
    bool isPositive = changePercent.asPercentChange >= 0;
    return isPositive ? '+' : '';
  }
}
