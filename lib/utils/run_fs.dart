import 'init.dart';

Future<void> runFs(Function func) async {
  if (networkDisabled) {
    func();
  } else {
    await func();
  }
}
