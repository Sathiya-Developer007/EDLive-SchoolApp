class StudentTodo {
  final String? id;
  final String title;
  final String description;
  final String date;
  final int? classId;
  final String? className;

  StudentTodo({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.classId,
    this.className,
  });

  factory StudentTodo.fromJson(Map<String, dynamic> json) {
    return StudentTodo(
      id: json['task_id']?.toString() ?? json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['due_date'] ?? json['date'] ?? '',
      classId: json['class_id'],
      className: json['class_name'] ?? json['class'],
    );
  }
}
