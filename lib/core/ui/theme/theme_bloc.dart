import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeBloc extends StateNotifier<ThemeMode> {
  ThemeBloc() : super(ThemeMode.dark);

  bool get isDarkMode => state == ThemeMode.dark;

  void onThemeModeChanged() {
    state = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }
}
