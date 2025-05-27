import 'dart:async';

import 'package:gym_log/main.dart';

class NoNetworkException implements Exception {}

Future<void> runFsOnlyOnline<T>(Future<T> Function() func) async {
  try {
    await func().timeout(kTimeoutDuration);
  } on TimeoutException {
    throw NoNetworkException();
  }
}

Future<void> runFs(func) async {
  if (!hasInternetConnectionNotifier.value) {
    func();
  } else {
    try {
      await func()?.timeout(kTimeoutDuration);
    } on TimeoutException {
      await fs.disableNetwork();
      hasInternetConnectionNotifier.value = false;
    }
  }
}
