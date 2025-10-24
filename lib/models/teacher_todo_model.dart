class Todo {
  final String? id;
  final String title;
  final String description;
  final String date;
  final bool completed;
  final int? classId;
  final String? className;
  final String? fileUrl;
  final int? subjectId;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.completed,
    this.classId,
    this.className,
    this.fileUrl,
    this.subjectId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['task_id']?.toString() ?? json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['due_date'] ?? json['date'] ?? '',
      completed: json['completed'] ?? false,
      classId: json['class_id'],
      subjectId: json['subject_id'],
      className: json['class_name'] ?? json['className'] ?? json['class'] ?? null,
      fileUrl: json['file_url'],
    );
  }
}
