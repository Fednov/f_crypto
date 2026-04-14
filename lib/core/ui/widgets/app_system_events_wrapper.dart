import 'package:f_crypto/core/network/internet_connection/app_internet_connection.dart';
import 'package:f_crypto/core/network/internet_connection/provider/app_internet_connection_provider.dart';
import 'package:f_crypto/core/utils/constants/app_strings.dart';
import 'package:f_crypto/core/utils/system_functions/app_system_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSystemEventsWrapper extends ConsumerWidget {
  const AppSystemEventsWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AppInternetStatus>>(appInternetStatusProvider,
        (previous, next) {
      next.whenData((status) {
        if (status == AppInternetStatus.disconnected) {
          AppSystemFunctions.showSnackBar(
            context: context,
            content: AppStrings.messageInternetConnectionLost,
          );
        } else if (previous?.value == AppInternetStatus.disconnected &&
            status == AppInternetStatus.connected) {
          AppSystemFunctions.showSnackBar(
            context: context,
            content: AppStrings.messageInternetConnectionRestored,
          );
        }
      });
    });

    return child;
  }
}
