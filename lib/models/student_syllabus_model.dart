class SyllabusSubject {
  final int subjectId;
  final String subjectName;
  final String subjectCode;

  SyllabusSubject({
    required this.subjectId,
    required this.subjectName,
    required this.subjectCode,
  });

  factory SyllabusSubject.fromJson(Map<String, dynamic> json) {
    return SyllabusSubject(
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      subjectCode: json['subject_code'],
    );
  }
}
