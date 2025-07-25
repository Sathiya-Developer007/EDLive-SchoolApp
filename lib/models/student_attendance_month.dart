class StudentAttendanceMonth {
  final String totalDays;
  final String presentMorning;
  final String absentMorning;
  final String presentAfternoon;
  final String absentAfternoon;
  final String totalPresent;
  final String totalAbsent;
  final String percentage; // 🔹 Add this line
  final Map<String, DailyAttendance> dailyAttendance;

  StudentAttendanceMonth({
    required this.totalDays,
    required this.presentMorning,
    required this.absentMorning,
    required this.presentAfternoon,
    required this.absentAfternoon,
    required this.totalPresent,
    required this.totalAbsent,
    required this.percentage, // 🔹 Add this line
    required this.dailyAttendance,
  });

  factory StudentAttendanceMonth.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> attendanceJson = json['daily_attendance'] ?? {};
    final Map<String, DailyAttendance> attendanceMap = attendanceJson.map(
      (key, value) => MapEntry(key, DailyAttendance.fromJson(value)),
    );

    return StudentAttendanceMonth(
      totalDays: json['total_days'] ?? "0",
      presentMorning: json['present_morning'] ?? "0",
      absentMorning: json['absent_morning'] ?? "0",
      presentAfternoon: json['present_afternoon'] ?? "0",
      absentAfternoon: json['absent_afternoon'] ?? "0",
      totalPresent: json['total_present'] ?? "0",
      totalAbsent: json['total_absent'] ?? "0",
      percentage: json['percentage'] ?? "0", // 🔹 Add this line
      dailyAttendance: attendanceMap,
    );
  }
}

class DailyAttendance {
  final bool morningPresent;
  final bool afternoonPresent;

  DailyAttendance({
    required this.morningPresent,
    required this.afternoonPresent,
  });

  factory DailyAttendance.fromJson(Map<String, dynamic> json) {
    return DailyAttendance(
      morningPresent: json['morning_present'] ?? false,
      afternoonPresent: json['afternoon_present'] ?? false,
    );
  }
}
