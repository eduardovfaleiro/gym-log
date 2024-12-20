class Exercise {
  final String name;
  final String section;

  Exercise({required this.name, required this.section});

  factory Exercise.fromFireStoreMap(Map<String, dynamic> map) {
    return Exercise(name: map[''], section: map['section']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'section': section};
  }
}
