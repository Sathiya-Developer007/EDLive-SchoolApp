class ClassSection {
  final int id;
  final String className;
  final String section;

  ClassSection({
    required this.id,
    required this.className,
    required this.section,
  });

  factory ClassSection.fromJson(Map<String, dynamic> json) {
    return ClassSection(
      id: json['id'],
      className: json['class'],
      section: json['section'],
    );
  }

  String get fullName => "$className${section.toUpperCase()}";
}
