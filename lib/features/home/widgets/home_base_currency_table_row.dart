import 'package:flutter/material.dart';

class HomeBaseCurrencyTableRow extends StatelessWidget {
  const HomeBaseCurrencyTableRow({
    super.key,
    required this.name,
    required this.price,
    required this.changePercent,
    this.icon,
  });

  final Widget? icon;
  final Widget name;
  final Widget price;
  final Widget changePercent;

  static const _horizontalPading = 16.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 9,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: icon,
          ),
          const SizedBox(
            width: _horizontalPading,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: name,
            ),
          ),
          const SizedBox(
            width: _horizontalPading,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: price,
            ),
          ),
          const SizedBox(
            width: _horizontalPading,
          ),
          SizedBox(
            width: 80,
            child: Align(
              alignment: Alignment.centerRight,
              child: changePercent,
            ),
          ),
        ],
      ),
    );
  }
}
