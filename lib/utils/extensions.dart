import 'package:intl/intl.dart';

extension FormatDate on DateTime {
  String formatReadable() => DateFormat('dd/MM/yyyy').format(this);
  String formatReadableShort() => DateFormat('dd/MM/yy').format(this);
}

extension IsBlank on String {
  bool get isBlank => trim().isEmpty;
}
