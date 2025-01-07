// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';

class Log {
  final DateTime date;
  final double weight;
  final int reps;
  final String notes;

  Log({required this.date, required this.weight, required this.reps, required this.notes});

  factory Log.fromFireStoreMap(Map<String, dynamic> map) {
    return Log(
      date: map['date'].toDate(),
      weight: map['weight'],
      reps: map['reps'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'weight': weight,
      'reps': reps,
      'notes': notes,
    };
  }

  Log copyWith({
    DateTime? date,
    double? weight,
    int? reps,
    String? notes,
  }) {
    return Log(
      date: date ?? this.date,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      notes: notes ?? this.notes,
    );
  }
}
