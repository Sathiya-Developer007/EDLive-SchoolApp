class TeacherDailyAttendance {
  final int studentId;
  final String fullName;
  final int classId;
  final String date;
  final bool isPresentMorning;
  final bool isPresentAfternoon;

  TeacherDailyAttendance({
    required this.studentId,
    required this.fullName,
    required this.classId,
    required this.date,
    required this.isPresentMorning,
    required this.isPresentAfternoon,
  });

  factory TeacherDailyAttendance.fromJson(Map<String, dynamic> json) {
    return TeacherDailyAttendance(
      studentId: json['student_id'] ?? 0,
      fullName: json['full_name'] ?? '',
      classId: json['class_id'] ?? 0,
      date: json['date'] ?? '',
      isPresentMorning: json['is_present_morning'] ?? false,
      isPresentAfternoon: json['is_present_afternoon'] ?? false,
    );
  }
}
