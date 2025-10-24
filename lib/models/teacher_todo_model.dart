import 'dart:convert';

class Todo {
  final String? id;
  final String title;
  final String description;
  final String date;
  final bool completed;
  final int? classId;
  final String? className;
  final String? fileUrl; // New: uploaded file URL

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.completed,
    this.classId,
    this.className,
    this.fileUrl,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['task_id']?.toString() ?? json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['due_date'] ?? json['date'] ?? '',
      completed: json['completed'] ?? false,
      classId: json['class_id'],
      className: _parseClassName(json),
      fileUrl: json['file_url'], // new
    );
  }

  static String? _parseClassName(Map<String, dynamic> json) {
    if (json['class_name'] != null) return json['class_name'];
    if (json['className'] != null) return json['className'];
    if (json['class'] != null) return json['class'];
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'date': date,
      'completed': completed,
      if (classId != null) 'class_id': classId,
      if (className != null) 'class_name': className,
      if (fileUrl != null) 'file_url': fileUrl,
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    bool? completed,
    int? classId,
    String? className,
    String? fileUrl,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, description: $description, '
        'date: $date, completed: $completed, classId: $classId, '
        'className: $className, fileUrl: $fileUrl)';
  }
}
