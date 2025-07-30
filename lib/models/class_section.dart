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
      className: json['class'],   // "10", "9"
      section: json['section'],   // "A", "B"
    );
  }

  String get fullName => "$className$section"; // e.g. "10A"
}
