class QuickNoteStudent {
  final int id;
  final String fullName;

  QuickNoteStudent({
    required this.id,
    required this.fullName,
  });

  factory QuickNoteStudent.fromJson(Map<String, dynamic> json) {
    return QuickNoteStudent(
      id: json['id'],
      fullName: json['full_name'],
    );
  }
}
