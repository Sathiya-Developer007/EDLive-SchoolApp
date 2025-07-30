class StudentAttendanceYearly {
  final String totalDays;
  final String presentMorning;
  final String absentMorning;
  final String presentAfternoon;
  final String absentAfternoon;
  final String totalPresent;
  final String totalAbsent;
  final String percentage;
  final Map<String, AttendanceStatus> dailyAttendance;

  StudentAttendanceYearly({
    required this.totalDays,
    required this.presentMorning,
    required this.absentMorning,
    required this.presentAfternoon,
    required this.absentAfternoon,
    required this.totalPresent,
    required this.totalAbsent,
    required this.percentage,
    required this.dailyAttendance,
  });

  factory StudentAttendanceYearly.fromJson(Map<String, dynamic> json) {
    final Map<String, AttendanceStatus> daily = {};

    json['daily_attendance'].forEach((date, value) {
      daily[date] = AttendanceStatus.fromJson(value);
    });

    return StudentAttendanceYearly(
      totalDays: json['total_days'],
      presentMorning: json['present_morning'],
      absentMorning: json['absent_morning'],
      presentAfternoon: json['present_afternoon'],
      absentAfternoon: json['absent_afternoon'],
      totalPresent: json['total_present'],
      totalAbsent: json['total_absent'],
      percentage: json['percentage'],
      dailyAttendance: daily,
    );
  }
}

class AttendanceStatus {
  final bool morningPresent;
  final bool afternoonPresent;

  AttendanceStatus({
    required this.morningPresent,
    required this.afternoonPresent,
  });

  factory AttendanceStatus.fromJson(Map<String, dynamic> json) {
    return AttendanceStatus(
      morningPresent: json['morning_present'],
      afternoonPresent: json['afternoon_present'],
    );
  }
}
