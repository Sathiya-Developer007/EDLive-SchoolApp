class StudentAttendanceMonth {
  final String totalDays;
  final String presentMorning;
  final String absentMorning;
  final String presentAfternoon;
  final String absentAfternoon;
  final String totalPresent;
  final String totalAbsent;

  StudentAttendanceMonth({
    required this.totalDays,
    required this.presentMorning,
    required this.absentMorning,
    required this.presentAfternoon,
    required this.absentAfternoon,
    required this.totalPresent,
    required this.totalAbsent,
  });

  factory StudentAttendanceMonth.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceMonth(
      totalDays: json['total_days'],
      presentMorning: json['present_morning'],
      absentMorning: json['absent_morning'],
      presentAfternoon: json['present_afternoon'],
      absentAfternoon: json['absent_afternoon'],
      totalPresent: json['total_present'],
      totalAbsent: json['total_absent'],
    );
  }
}
