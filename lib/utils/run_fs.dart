import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gym_log/widgets/brightness_manager.dart';

Future<void> runFs(Function func) async {
  if (await CheckConnectionController.checkConnection()) {
    await func();
  } else {
    func();
  }
}
