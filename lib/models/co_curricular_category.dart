class CoCurricularCategory {
  final int id;
  final String name;
  final String description;

  CoCurricularCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CoCurricularCategory.fromJson(Map<String, dynamic> json) {
    return CoCurricularCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
    );
  }
}
