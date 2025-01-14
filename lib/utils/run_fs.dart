import 'package:gym_log/main.dart';

Future<void> runFs(Function func) async {
  if (networkDisabled) {
    func();
  } else {
    await func();
  }
}
