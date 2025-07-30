class StudentTimetableEntry {
  final String className;
  final String subject;
  final Map<String, String?> timesByDay; // e.g. {"monday": "9:45 AM - 10:45 AM"}
  final Map<String, int?> periodIdsByDay; // optional

  StudentTimetableEntry({
    required this.className,
    required this.subject,
    required this.timesByDay,
    required this.periodIdsByDay,
  });

  factory StudentTimetableEntry.fromJson(Map<String, dynamic> json) {
    final days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    final times = {for (var d in days) d: json[d]?.toString()};
    final periodIds = {
      for (var d in days) '${d}_period_id': json['${d}_period_id'] as int?
    };

    return StudentTimetableEntry(
      className: json['class'] ?? '',
      subject: json['subject'] ?? '',
      timesByDay: times,
      periodIdsByDay: periodIds,
    );
  }
}
