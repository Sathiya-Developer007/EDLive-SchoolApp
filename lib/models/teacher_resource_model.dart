class TeacherResourceModel {
  final int id;
  final String title;
  final String description;
  final List<String> webLinks;
  final int classId;
  final int subjectId;
  final String className;
  final String subjectName;
  final String createdByName;

  TeacherResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.webLinks,
    required this.classId,
    required this.subjectId,
    required this.className,
    required this.subjectName,
    required this.createdByName,
  });

  factory TeacherResourceModel.fromJson(Map<String, dynamic> json) {
    return TeacherResourceModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      webLinks: List<String>.from(json['web_links'] ?? []),
      classId: json['class_id'],
      subjectId: json['subject_id'],
      className: json['class_name'] ?? '',
      subjectName: json['subject_name'] ?? '',
      createdByName: json['created_by_name'] ?? '',
    );
  }
}
