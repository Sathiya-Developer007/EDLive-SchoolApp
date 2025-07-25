class StudentAttendance {
  final int studentId;
  final String name;
  final int absent;

  StudentAttendance({
    required this.studentId,
    required this.name,
    required this.absent,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      studentId: json['student_id'],
      name: json['student_name'],
      absent: json['absent_days'] ?? 0,
    );
  }
}
