class TimetableEntry {
  final String className;
  final String subject;
  final Map<String, String?> times;
  final Map<String, int?> periodIds;

  TimetableEntry({
    required this.className,
    required this.subject,
    required this.times,
    required this.periodIds,
  });
factory TimetableEntry.fromJson(Map<String, dynamic> json) {
  return TimetableEntry(
    className: json['class'],
    subject: json['subject'],
    times: {
      'monday': json['monday'],
      'tuesday': json['tuesday'],
      'wednesday': json['wednesday'],
      'thursday': json['thursday'],
      'friday': json['friday'],
      'saturday': json['saturday'],
    },
    periodIds: {
      'monday': json['monday_period_id'] != null ? int.tryParse(json['monday_period_id'].toString()) : null,
      'tuesday': json['tuesday_period_id'] != null ? int.tryParse(json['tuesday_period_id'].toString()) : null,
      'wednesday': json['wednesday_period_id'] != null ? int.tryParse(json['wednesday_period_id'].toString()) : null,
      'thursday': json['thursday_period_id'] != null ? int.tryParse(json['thursday_period_id'].toString()) : null,
      'friday': json['friday_period_id'] != null ? int.tryParse(json['friday_period_id'].toString()) : null,
      'saturday': json['saturday_period_id'] != null ? int.tryParse(json['saturday_period_id'].toString()) : null,
    },
  );
}
}