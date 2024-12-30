// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../repositories/exercise_repository.dart';

class Exercise {
  final String name;
  final String category;

  Exercise({required this.name, required this.category});

  factory Exercise.fromFireStoreMap(Map<String, dynamic> map) {
    return Exercise(name: map['name'], category: map['category']);
  }

  Map<String, dynamic> toMap() {
    // return {'name': name, 'category': translator[category]};
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
