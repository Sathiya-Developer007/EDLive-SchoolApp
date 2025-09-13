// models/teacher_student_classsection.dart

class StudentClassSection {
  final int id;
  final String name;
  final String admissionNo;

  StudentClassSection({
    required this.id,
    required this.name,
    required this.admissionNo,
  });

  factory StudentClassSection.fromJson(Map<String, dynamic> json) {
    return StudentClassSection(
      id: json['id'],
      name: json['student_name'] ?? '',
      admissionNo: json['admission_no'] ?? '',
    );
  }
}


