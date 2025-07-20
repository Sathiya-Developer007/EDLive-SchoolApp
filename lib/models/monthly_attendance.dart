// models/student_attendance.dart

class StudentAttendance {
  final String name;
  final int absent;

  StudentAttendance({required this.name, required this.absent});

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      name: json['name'],
      absent: json['absent'],
    );
  }
}
