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
  final String? userId;
  final String? createdAt;
  final String? updatedAt;

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
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['task_id']?.toString() ?? 
          json['id']?.toString() ?? 
          json['todo_id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['due_date'] ?? json['date'] ?? '',
      completed: json['completed'] ?? false,
      classId: json['class_id'] != null ? int.tryParse(json['class_id'].toString()) : null,
      subjectId: json['subject_id'] != null ? int.tryParse(json['subject_id'].toString()) : null,
      className: json['class_name'] ?? json['className'] ?? json['class'] ?? null,
      fileUrl: json['todo_file'] ?? json['file_url'] ?? json['attachment_url'],
      userId: json['user_id']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'date': date,
      'completed': completed,
      if (classId != null) 'class_id': classId,
      if (subjectId != null) 'subject_id': subjectId,
      if (className != null) 'class_name': className,
      if (fileUrl != null) 'file_url': fileUrl,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}