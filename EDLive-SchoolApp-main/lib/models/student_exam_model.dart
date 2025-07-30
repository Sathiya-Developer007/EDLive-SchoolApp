// models/student_exam_model.dart
class StudentExam {
  final String title;
  final String subject;
  final DateTime examDate;

  StudentExam({
    required this.title,
    required this.subject,
    required this.examDate,
  });

  factory StudentExam.fromJson(Map<String, dynamic> json) {
    return StudentExam(
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      examDate: DateTime.parse(json['exam_date']),
    );
  }
}
