import 'package:f_crypto/core/extensions/buildcontext_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bloc/provider/home_state_provider.dart';

class HomeTextField extends ConsumerWidget {
  const HomeTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = context.themeOf;

    return TextField(
      onChanged:
          ref.read(homeStateProvider.notifier).onCurrencySearchQueryChanged,
      decoration: InputDecoration(
        hintText: 'Search Coin',
        filled: true,
        fillColor: theme.colorScheme.onSurface.withOpacity(0.1),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}
