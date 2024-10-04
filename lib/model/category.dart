class Category {
  final String name;
  final String id;

  Category({required this.name, required this.id});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}
