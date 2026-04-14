import 'package:f_crypto/core/extensions/buildcontext_extensions.dart';
import 'package:flutter/material.dart';

import '../widgets/home_currencies.dart';
import '../widgets/home_currency_table_header.dart';
import '../widgets/home_text_field.dart';
import '../widgets/home_theme_mode_change_button.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = context.sizeOf;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Market'),
        actions: const [
          HomeThemeModeChangeButton(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.035,
        ),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.06,
              child: const HomeTextField(),
            ),
            SizedBox(height: size.height * 0.02),
            const HomeCurrencyTableHeader(),
            const Expanded(
              child: HomeCurrencies(),
            )
          ],
        ),
      ),
    );
  }
}
