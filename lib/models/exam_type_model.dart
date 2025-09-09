class ExamType {
  final int id;
  final String examType;
  final String description;
  final bool isActive;

  ExamType({
    required this.id,
    required this.examType,
    required this.description,
    required this.isActive,
  });

  factory ExamType.fromJson(Map<String, dynamic> json) {
    return ExamType(
      id: json['id'],
      examType: json['exam_type'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }
}
