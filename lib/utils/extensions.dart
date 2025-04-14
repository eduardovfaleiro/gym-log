import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_log/widgets/brightness_manager.dart';
import 'package:intl/intl.dart';

extension FormatDate on DateTime {
  String formatReadable() => DateFormat('dd/MM/yyyy').format(this);
  String formatReadableShort() => DateFormat('dd/MM/yy').format(this);
}

extension IsBlank on String {
  bool get isBlank => trim().isEmpty;
}

extension GetX<T> on Query<T> {
  Future<QuerySnapshot<T>> getX() async {
    bool hasInternetConnection =
        await CheckConnectionController.checkConnection();

    if (hasInternetConnection) {
      return get();
    } else {
      return get(const GetOptions(source: Source.cache));
    }
  }
}
