// ignore_for_file: public_member_api_docs, sort_constructors_first

class Exercise {
  final String id;
  final String name;
  final String category;

  Exercise({ this.id = '',required this.name, required this.category});

  factory Exercise.fromFireStoreMap(Map<String, dynamic> map) {
    return Exercise(id: map['id'],name: map['name'], category: map['category']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'category': category};
  }

  @override
  String toString() => 'Exercise(name: $name, category: $category)';
}

// class OrderedExercise {
//   final String id;
//   final String name;
//   final int order;

//   OrderedExercise({required this.id, required this.name, required this.order});
// }
