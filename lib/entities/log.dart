// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  final DateTime date;
  final double weight;
  final int reps;
  final String notes;

  Log({required this.date, required this.weight, required this.reps, required this.notes});

  factory Log.fromFireStoreMap(Map<String, dynamic> map) {
    return Log(
      date: (map['dateTime'] as Timestamp).toDate(),
      weight: map['weight'],
      reps: map['reps'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': date,
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

  // TODO(corrigir)
  @override
  bool operator ==(covariant Log other) {
    if (identical(this, other)) return true;

    return other.date == date && other.weight == weight && other.reps == reps && other.notes == notes;
  }

  @override
  int get hashCode {
    return date.hashCode ^ weight.hashCode ^ reps.hashCode ^ notes.hashCode;
  }
}
