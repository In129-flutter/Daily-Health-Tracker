import 'dart:async';

class TimerService {
  static Timer? _timer;
  static int seconds = 600; 

  static void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds > 0) {
        seconds--;
      } else {
        t.cancel();
      }
    });
  }

  static void reset() {
    seconds = 600;
    start();
  }

  static void dispose() {
    _timer?.cancel();
  }
}
