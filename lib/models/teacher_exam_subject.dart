class TeacherExam {
  final int id;
  final String title;
  final String subject;
  final int classId;
  final String examType;

  TeacherExam({
    required this.id,
    required this.title,
    required this.subject,
    required this.classId,
    required this.examType,
  });

  factory TeacherExam.fromJson(Map<String, dynamic> json) {
    return TeacherExam(
      id: json['id'],
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      classId: int.tryParse(json['class_id']?.toString() ?? '') ?? 0,
      examType: json['exam_type'] ?? '',
    );
  }
}
