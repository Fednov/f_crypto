import 'package:flutter/material.dart';

class CurrencyThemeExtension extends ThemeExtension<CurrencyThemeExtension> {
  final Color positive;
  final Color negative;
  final Color neutral;
  final Color text;

  const CurrencyThemeExtension({
    required this.positive,
    required this.negative,
    required this.neutral,
    required this.text,
  });

  @override
  ThemeExtension<CurrencyThemeExtension> copyWith(
      {Color? positive, Color? negative, Color? neutral, Color? text}) {
    return CurrencyThemeExtension(
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
      neutral: neutral ?? this.neutral,
      text: text ?? this.text,
    );
  }

  @override
  ThemeExtension<CurrencyThemeExtension> lerp(
    ThemeExtension<CurrencyThemeExtension>? other,
    double t,
  ) {
    if (other is! CurrencyThemeExtension) return this;
    return CurrencyThemeExtension(
      positive: Color.lerp(positive, other.positive, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      text: Color.lerp(text, other.text, t)!,
    );
  }
}
