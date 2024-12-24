import '../repositories/exercise_repository.dart';

class Exercise {
  final String name;
  final String category;

  Exercise({required this.name, required this.category});

  factory Exercise.fromFireStoreMap(Map<String, dynamic> map) {
    return Exercise(name: map['name'], category: map['category']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'category': translator[category]};
  }
}
