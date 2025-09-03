class CoCurricularStat {
  final String activityName;
  final String categoryName;
  final String enrollmentCount;
  final String className;

  CoCurricularStat({
    required this.activityName,
    required this.categoryName,
    required this.enrollmentCount,
    required this.className,
  });

  factory CoCurricularStat.fromJson(Map<String, dynamic> json) {
    return CoCurricularStat(
      activityName: json['activity_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      enrollmentCount: json['enrollment_count'] ?? '0',
      className: json['class_name'] ?? '',
    );
  }
}
