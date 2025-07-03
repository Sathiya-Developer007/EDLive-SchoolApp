class TimetableDay {
  final String dayOfWeek;
  final List<String?> periods;

  TimetableDay({
    required this.dayOfWeek,
    required this.periods,
  });

  factory TimetableDay.fromJson(Map<String, dynamic> json) {
    return TimetableDay(
      dayOfWeek: json['day_of_week'],
      periods: List.generate(8, (index) => json['period_${index + 1}']),
    );
  }
}
