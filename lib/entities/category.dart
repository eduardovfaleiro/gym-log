// ignore_for_file: public_member_api_docs, sort_constructors_first

class Category {
  final String id;
  final int order;
  final String name;

  Category({
    required this.id,
    required this.order,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'order': order,
      'name': name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      order: map['order'] as int,
      name: map['name'] as String,
    );
  }
}
