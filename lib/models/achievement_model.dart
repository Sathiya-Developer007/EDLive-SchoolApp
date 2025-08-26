class Achievement {
  final int? id;
  final int studentId;
  final String title;
  final String description;
  final int categoryId;
  final String achievementDate;
  final String awardedBy;
  final String imageUrl;
  final String isVisible;
  final int classId;
  final int academicYearId;

  Achievement({
    this.id,
    required this.studentId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.achievementDate,
    required this.awardedBy,
    required this.imageUrl,
    required this.isVisible,
    required this.classId,
    required this.academicYearId,
  });

  Map<String, dynamic> toJson() {
    return {
      "studentId": studentId,
      "title": title,
      "description": description,
      "categoryId": categoryId,
      "achievementDate": achievementDate,
      "awardedBy": awardedBy,
      "imageUrl": imageUrl,
      "isVisible": isVisible,
      "classId": classId,
      "academicYearId": academicYearId,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      studentId: json['student_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['category'] ?? 0,
      achievementDate: json['achievement_date'] ?? '',
      awardedBy: json['awarded_by'] ?? '',
      imageUrl: json['evidence_url'] ?? '',
      isVisible: json['visibility'] ?? 'school',
      classId: json['class_id'] ?? 0,
      academicYearId: json['academic_year'] ?? 0,
    );
  }
}
