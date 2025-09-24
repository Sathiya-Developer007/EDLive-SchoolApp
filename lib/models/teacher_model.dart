class Teacher {
  final int id;
  final String fullName;
  final String staffId;
  final String subjectName;

  Teacher({
    required this.id,
    required this.fullName,
    required this.staffId,
    required this.subjectName,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      fullName: json['full_name'],
      staffId: json['staff_id'],
      subjectName: json['subject_name'],
    );
  }
}
