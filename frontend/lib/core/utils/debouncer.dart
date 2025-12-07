import 'dart:async';
import '../../shared/constants/app_constants.dart' as constants;

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({Duration? duration})
      : duration = duration ?? constants.AppConstants.searchDebounce;

  void run(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    cancel();
  }
}
