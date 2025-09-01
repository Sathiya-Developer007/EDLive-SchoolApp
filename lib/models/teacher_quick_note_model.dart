class QuickNote {
  final int id;
  final String title;
  final String description;
  final List<String> webLinks;
  final int classId;
  final List<int> studentIds;
  final String className;
  final String createdByName;
  final List<String> studentNames;

  QuickNote({
    required this.id,
    required this.title,
    required this.description,
    required this.webLinks,
    required this.classId,
    required this.studentIds,
    required this.className,
    required this.createdByName,
    required this.studentNames,
  });

  factory QuickNote.fromJson(Map<String, dynamic> json) {
    return QuickNote(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      webLinks: List<String>.from(json['web_links']),
      classId: json['class_id'],
      studentIds: List<int>.from(json['student_ids']),
      className: json['class_name'],
      createdByName: json['created_by_name'],
      studentNames: List<String>.from(json['student_names']),
    );
  }
}
