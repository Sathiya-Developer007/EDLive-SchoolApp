class Achievement {
  final int? id;
  final int studentId;
  final String title;
  final String description;
  final String categoryId;
  final String achievementDate;
  final String awardedBy;
  final String? evidenceUrl; // ✅ change from imageUrl
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
    this.evidenceUrl, // optional
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
      "evidence_url": evidenceUrl, // ✅ backend expects this
      "isVisible": isVisible,
      "classId": classId,
      "academicYearId": academicYearId,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      studentId: json['student_id'] ?? json['studentId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['category'] ?? json['categoryId'] ?? '',
      achievementDate: (json['achievement_date'] ?? json['achievementDate'] ?? '').toString().split("T").first,
      awardedBy: json['awarded_by'] ?? json['awardedBy'] ?? '',
      evidenceUrl: json['evidence_url'], // ✅ use backend field
      isVisible: json['visibility'] ?? json['isVisible'] ?? 'school',
      classId: json['class_id'] ?? json['classId'] ?? 0,
      academicYearId: int.tryParse((json['academic_year'] ?? json['academicYearId'] ?? '2024').toString()) ?? 2024,
    );
  }
}
