import 'package:intl/intl.dart';

class Log {
  final DateTime date;
  final double weight;
  final int reps;

  Log({required this.date, required this.weight, required this.reps});

  static Log fromStr(String str) {
    return Log(
      date: DateFormat('dd-MM-yyyy').parse(str.split(';')[0]),
      weight: double.parse(str.split(';')[1]),
      reps: int.parse(str.split(';')[2]),
    );
  }

  factory Log.fromFireStoreMap(Map<String, dynamic> map) {
    return Log(date: DateFormat('dd-MM-yyyy').parse(map['date']), weight: map['weight'], reps: map['reps']);
  }

  Map<String, dynamic> toMap() {
    return {'date': DateFormat('dd-MM-yyyy').format(date), 'weight': weight, 'reps': reps};
  }
}
