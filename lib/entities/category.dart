class Category {
  final String id;
  final String name;

  const Category({required this.id, required this.name});

  factory Category.fromMap(Map<String, dynamic> map) {}
}
