class Student {
  final int id;
  final String studentName;

  Student({required this.id, required this.studentName});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      studentName: json['student_name'] ?? '',
    );
  }
}
