// models/subject_model.dart
class SubjectModel {
  final int id;
  final String name;
  final String code;

  SubjectModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['subject_id'],
      name: json['subject_name'] ?? '',
      code: json['subject_code'] ?? '',
    );
  }
}