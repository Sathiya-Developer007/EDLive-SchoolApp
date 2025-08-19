class Subject {
  final int id;
  final String name;
  final String code;

  Subject({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['subject_id'],
      name: json['subject_name'],
      code: json['subject_code'],
    );
  }
}
