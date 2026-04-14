import 'package:f_crypto/core/ui/theme/provider/theme_mode_provider.dart';
import 'package:f_crypto/core/utils/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeThemeModeChangeButton extends ConsumerWidget {
  const HomeThemeModeChangeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentThemeMode = ref.watch(themeModeProvider);

    return IconButton(
      tooltip: AppStrings.tooltipThemeModeChange,
      onPressed: () =>
          ref.read(themeModeProvider.notifier).onThemeModeChanged(),
      icon: Icon(
        currentThemeMode == ThemeMode.light ? Icons.dark_mode : Icons.sunny,
      ),
    );
  }
}
