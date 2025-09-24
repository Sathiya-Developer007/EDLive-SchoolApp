class SpecialCareCategory {
  final int id;
  final String name;
  final String description;

  SpecialCareCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory SpecialCareCategory.fromJson(Map<String, dynamic> json) {
    return SpecialCareCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
