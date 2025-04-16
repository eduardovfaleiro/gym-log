import 'dart:async';

import 'package:gym_log/main.dart';

Future<void> runFs(func) async {
  if (!hasInternetConnectionNotifier.value) {
    func();
  } else {
    try {
      await func().timeout(const Duration(seconds: 4));
    } on TimeoutException {
      hasInternetConnectionNotifier.value = false;
      runFs(func);
    }
  }

  // if (await CheckConnectionController.checkConnection()) {
  //   await func();
  // } else {
  //   func();
  // }
}
