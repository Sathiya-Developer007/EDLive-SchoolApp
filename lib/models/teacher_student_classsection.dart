

// models/student.dart

class Student {
  final int id;
  final String name;
  final int classId;

  Student({
    required this.id,
    required this.name,
    required this.classId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['student_name'] ?? 'Unknown',
      classId: json['class_id'] ?? 0,
    );
  }
}





class StudentClassSection {
  final int id;
  final String name;
  final int classId;

  StudentClassSection({
    required this.id,
    required this.name,
    required this.classId,
  });

  factory StudentClassSection.fromJson(Map<String, dynamic> json) {
    return StudentClassSection(
      id: json['id'],
      name: json['student_name'] ?? '',
      classId: json['class_id'] ?? 0,
    );
  }
}





// teacher_student_attendance_day

class AttendanceStudent {
  final int id;
  final String name;
  bool isPresentMorning;
  bool isPresentAfternoon;

  AttendanceStudent({
    required this.id,
    required this.name,
    this.isPresentMorning = false,
    this.isPresentAfternoon = false,
  });

  factory AttendanceStudent.fromJson(Map<String, dynamic> json) {
    return AttendanceStudent(
      id: json['id'],
      name: json['name'],
    );
  }
}
