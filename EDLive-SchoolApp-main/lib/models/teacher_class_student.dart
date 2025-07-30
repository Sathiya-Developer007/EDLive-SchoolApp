class Student {
  final int id;
  final String studentName;
  final String className; // <-- ADD THIS

  Student({
    required this.id,
    required this.studentName,
    required this.className,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      studentName: json['student_name'],
      className: json['class_name'] ?? '', // <-- ADD THIS
    );
  }
}
// 