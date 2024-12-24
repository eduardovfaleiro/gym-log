import 'package:intl/intl.dart';

class Log {
  final DateTime date;
  final double weight;
  final int reps;
  final String notes;

  Log({required this.date, required this.weight, required this.reps, required this.notes});

  factory Log.fromFireStoreMap(Map<String, dynamic> map) {
    return Log(
        date: DateFormat('dd-MM-yyyy').parse(map['date']),
        weight: map['weight'],
        reps: map['reps'],
        notes: map['notes']);
  }

  Map<String, dynamic> toMap() {
    return {
      'date': DateFormat('dd-MM-yyyy').format(date),
      'weight': weight,
      'reps': reps,
      'notes': notes,
    };
  }
}
