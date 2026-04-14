import 'package:f_crypto/core/ui/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeBloc, ThemeMode>((ref) => ThemeBloc());
