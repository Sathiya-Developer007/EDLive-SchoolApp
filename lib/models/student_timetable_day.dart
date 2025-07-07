class TimetableDay {
  final String day;
  final List<String?> periods;

  TimetableDay({
    required this.day,
    required this.periods,
  });

 factory TimetableDay.fromJson(Map<String, dynamic> json) {
  return TimetableDay(
    day: json['day_of_week'] as String,
    periods: List.generate(8, (i) {
      final raw = json['period_${i + 1}'];
      return raw?.toString(); // ✅ converts int, null, etc. safely to String
    }),
  );
}

  factory TimetableDay.empty(String day) =>
      TimetableDay(day: day, periods: List.filled(8, null));
}
