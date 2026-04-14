import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../globals/app_globals.dart';

final class AppSystemFunctions {
  AppSystemFunctions._();

  static void showSnackBar({
    required BuildContext context,
    required String content,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(content),
        ),
      );
  }

  static void showSnackBarGlobal({required String content}) {
    var context = AppGlobals.scaffoldMessengerKey.currentContext;

    if (context != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(content),
          ),
        );
    }
  }

  static Future<void> setPrefferedOrientations() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Future<void> adjustSystemUiOverlay() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [
          SystemUiOverlay.top,
          SystemUiOverlay.bottom,
        ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
