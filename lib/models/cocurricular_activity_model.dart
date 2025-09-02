class CoCurricularActivity {
  final String activityName;
  final String categoryName;
  final int enrollmentCount;
  final String className;

  CoCurricularActivity({
    required this.activityName,
    required this.categoryName,
    required this.enrollmentCount,
    required this.className,
  });

  factory CoCurricularActivity.fromJson(Map<String, dynamic> json) {
    return CoCurricularActivity(
      activityName: json['activity_name'],
      categoryName: json['category_name'],
      enrollmentCount: int.tryParse(json['enrollment_count'] ?? '0') ?? 0,
      className: json['class_name'] ?? '',
    );
  }
}
