class QuickNoteClass {
  final int classId;
  final String className;

  QuickNoteClass({
    required this.classId,
    required this.className,
  });

  factory QuickNoteClass.fromJson(Map<String, dynamic> json) {
    return QuickNoteClass(
      classId: json['class_id'],
      className: json['class_name'],
    );
  }
}
