class Todo {
  final String? id;
  final String title;
  final String description;
  final String date;
  final bool completed;
  final int? classId;
  final String? className;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.completed,
    this.classId,
    this.className,
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
    );
  }

  // static int? _parseClassId(Map<String, dynamic> json) {
  //   if (json['class_id'] != null) return json['class_id'].toString();
  //   return null;
  // }

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
    };
  }

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, description: $description, '
        'date: $date, completed: $completed, classId: $classId, '
        'className: $className)';
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    bool? completed,
    int? classId,
    String? className,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      classId: classId ?? this.classId,
      className: className ?? this.className,
    );
  }
}