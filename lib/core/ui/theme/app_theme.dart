import 'package:flutter/material.dart';

import 'extensions/currency_theme_extension.dart';

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: Colors.pink,
      surface: Color(0xffFFFFFF),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xFF8A919E),
    ),
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
    ),
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecoratonTheme,
    extensions: const [
      _baseCurrencyThemeExtension,
    ],
  );

  static final dark = ThemeData(
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Colors.pink,
      surface: Color(0xff161D26),
      surfaceBright: Color(0xff222B35),
      onSurface: Colors.white,
      onSurfaceVariant: Color(0xff8A919E),
    ),
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
    ),
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecoratonTheme,
    extensions: const [
      _baseCurrencyThemeExtension,
    ],
  );

  static const _textTheme = TextTheme(
    bodyMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  );

  static const _inputDecoratonTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(
      vertical: 0,
      horizontal: 12,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  static const _baseCurrencyThemeExtension = CurrencyThemeExtension(
    positive: Color(0xff21BF73),
    negative: Color(0xffD9534F),
    neutral: Colors.grey,
    text: Colors.white,
  );
}
