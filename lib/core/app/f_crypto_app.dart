import 'package:f_crypto/core/ui/theme/provider/theme_mode_provider.dart';
import 'package:f_crypto/core/ui/theme/app_theme.dart';
import 'package:f_crypto/core/ui/widgets/app_screen_size_limiter.dart';
import 'package:f_crypto/core/ui/widgets/app_system_events_wrapper.dart';
import 'package:f_crypto/core/utils/constants/app_strings.dart';
import 'package:f_crypto/core/utils/globals/app_globals.dart';
import 'package:f_crypto/features/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FCryptoApp extends ConsumerWidget {
  const FCryptoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      scaffoldMessengerKey: AppGlobals.scaffoldMessengerKey,
      navigatorKey: AppGlobals.navigatorKey,
      builder: (context, child) {
        return AppScreenSizeLimiter(
          child: AppSystemEventsWrapper(
            child: child ?? Container(),
          ),
        );
      },
      home: const HomePageScreen(),
    );
  }
}
