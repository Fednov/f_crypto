import 'dart:async';
import 'dart:math' as math;

class AppReconnector {
  int _retryCount = 0;
  Timer? _timer;

  void perform({required Function onReconnect}) {
    _timer?.cancel();
    final delay = math.pow(2, _retryCount).clamp(2, 60).toInt();
    _timer = Timer(Duration(seconds: delay), () {
      _retryCount++;
      onReconnect();
    });
  }

  Future<void> waitNext() async {
    final delay = math.pow(2, _retryCount).clamp(2, 60).toInt();
    await Future.delayed(Duration(seconds: delay));
    _retryCount++;
  }

  void reset() => _retryCount = 0;

  void dispose() => _timer?.cancel();
}
