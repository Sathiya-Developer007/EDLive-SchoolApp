class StudentExam {
  final int id;
  final String title;
  final String subject;
  final DateTime examDate;
  final String classId;
  final String description;
  final String examType;

  StudentExam({
    required this.id,
    required this.title,
    required this.subject,
    required this.examDate,
    required this.classId,
    required this.description,
    required this.examType,
  });

  factory StudentExam.fromJson(Map<String, dynamic> json) {
    return StudentExam(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      examDate: DateTime.parse(json['exam_date']),
     classId: json['class_id'].toString(),

      description: json['description'] ?? '',
      examType: json['exam_type'] ?? '',
    );
  }
}
