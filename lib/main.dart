import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worker_manager/worker_manager.dart';

import 'core/app/f_crypto_app.dart';
import 'core/utils/system_functions/app_system_functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await workerManager.init();

  await AppSystemFunctions.adjustSystemUiOverlay();
  await AppSystemFunctions.setPrefferedOrientations();

  runApp(
    const ProviderScope(
      child: FCryptoApp(),
    ),
  );
}
