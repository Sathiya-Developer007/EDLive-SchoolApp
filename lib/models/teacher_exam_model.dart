class TeacherExam {
  final int id;
  final String title;
  final String subject;
  final String examDate;
  final String description;
  final String examType;

  TeacherExam({
    required this.id,
    required this.title,
    required this.subject,
    required this.examDate,
    required this.description,
    required this.examType,
  });

  factory TeacherExam.fromJson(Map<String, dynamic> json) {
    return TeacherExam(
      id: json['id'],
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      examDate: json['exam_date'] ?? '',
      description: json['description'] ?? '',
      examType: json['exam_type'] ?? '',
    );
  }
}
