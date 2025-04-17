import 'dart:async';

import 'package:gym_log/main.dart';

Future<void> runFs(func) async {
  if (!hasInternetConnectionNotifier.value) {
    func();
  } else {
    try {
      await func()?.timeout(kTimeoutDuration);
    } on TimeoutException {
      hasInternetConnectionNotifier.value = false;
    }
  }
}
