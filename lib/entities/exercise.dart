// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseX {
  final String id;
  final String name;
  final String categoryId;

  const ExerciseX({
    required this.id,
    required this.name,
    required this.categoryId,
  });

  factory ExerciseX.fromFireStoreSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();

    return ExerciseX(
      id: snapshot.id,
      name: data['name'],
      categoryId: data['categoryId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'categoryId': categoryId};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseX && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Exercise {
  final String name;
  final String category;

  Exercise({required this.name, required this.category});

  factory Exercise.fromFireStoreMap(Map<String, dynamic> map) {
    return Exercise(name: map['name'], category: map['category']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'category': category};
  }

  @override
  String toString() => 'Exercise(name: $name, category: $category)';
}

class OrderedExercise {
  final String name;
  final int order;

  OrderedExercise({required this.name, required this.order});
}
