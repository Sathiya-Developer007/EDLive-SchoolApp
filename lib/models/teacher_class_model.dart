class TeacherClassModel {
  final int classId;
  final String className;

  TeacherClassModel({required this.classId, required this.className});

  factory TeacherClassModel.fromJson(Map<String, dynamic> json) {
    return TeacherClassModel(
      classId: json['class_id'],
      className: json['class_name'],
    );
  }
}
