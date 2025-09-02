class StudentTimetableEntry {
  final String className;
  final String subject;
  final Map<String, String?> timesByDay;

  StudentTimetableEntry({
    required this.className,
    required this.subject,
    required this.timesByDay,
  });

  factory StudentTimetableEntry.fromJson(Map<String, dynamic> json) {
    return StudentTimetableEntry(
      className: json['class'] ?? '',
      subject: json['subject'] ?? '',
      timesByDay: {
        'monday': json['monday'],
        'tuesday': json['tuesday'],
        'wednesday': json['wednesday'],
        'thursday': json['thursday'],
        'friday': json['friday'],
        'saturday': json['saturday'],
      },
    );
  }
}
