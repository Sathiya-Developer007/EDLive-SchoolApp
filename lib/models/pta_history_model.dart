class PTAHistory {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final List<int> classIds;
  final bool includeAllSections;

  List<String>? classNames; // for UI display

  PTAHistory({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.classIds,
    required this.includeAllSections,
    this.classNames,
  });

  factory PTAHistory.fromJson(Map<String, dynamic> json) {
    return PTAHistory(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      classIds: List<int>.from(json['class_ids']),
      includeAllSections: json['include_all_sections'],
    );
  }
}
