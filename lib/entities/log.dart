// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Log {
  final String? id;
  final DateTime date;
  final double weight;
  final int reps;
  final String notes;

  Log({
    String? id,
    required this.date,
    required this.weight,
    required this.reps,
    required this.notes,
  }) : id = id ?? const Uuid().v4();

  factory Log.fromFireStoreMap(Map<String, dynamic> map) {
    return Log(
      id: map['id'],
      date: (map['dateTime'] as Timestamp).toDate(),
      weight: map['weight'],
      reps: map['reps'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': date,
      'weight': weight,
      'reps': reps,
      'notes': notes,
    };
  }

  Log copyWith({
    String? id,
    DateTime? date,
    double? weight,
    int? reps,
    String? notes,
  }) {
    return Log(
      id: id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(covariant Log other) {
    return id == other.id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
