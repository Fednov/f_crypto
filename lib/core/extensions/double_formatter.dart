import 'package:intl/intl.dart';

extension DoubleFormatter on double {
  static const int _defaultPercentDigits = 2;

  String toSmartPrice() {
    if (this >= 1000) {
      return NumberFormat('#,##0.00', 'en_US').format(this);
    } else if (this >= 1) {
      return toStringAsFixed(2);
    } else if (this >= 0.01) {
      return toStringAsFixed(4);
    } else {
      return toStringAsFixed(8);
    }
  }

  double get asPercentChange {
    double rounded = double.parse(toStringAsFixed(_defaultPercentDigits));

    return rounded == 0.0 ? 0.0 : rounded;
  }

  String get asPercentChangeString {
    return asPercentChange.toStringAsFixed(_defaultPercentDigits);
  }
}
