class ExamResultDetailResponse {
  final bool success;
  final ExamResultData? data;

  ExamResultDetailResponse({required this.success, this.data});

  factory ExamResultDetailResponse.fromJson(Map<String, dynamic> json) {
    return ExamResultDetailResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? ExamResultData.fromJson(json['data']) : null,
    );
  }
}

class ExamResultData {
  final List<ExamResultItem> examResults;
  final List<TermResult> termResults;

  ExamResultData({
    required this.examResults,
    required this.termResults,
  });

  factory ExamResultData.fromJson(Map<String, dynamic> json) {
    return ExamResultData(
      examResults: (json['examResults'] as List<dynamic>?)
              ?.map((e) => ExamResultItem.fromJson(e))
              .toList() ??
          [],
      termResults: (json['termResults'] as List<dynamic>?)
              ?.map((e) => TermResult.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ExamResultItem {
  final int id;
  final int examId;
  final int studentId;
  final String? marks;
  final String? percentage;
  final String? grade;
  final String? term;
  final bool isFinal;
  final int? classRank;
  final String? subject;
  final String? examTitle;
  final String? examType;
  final String? examDate;

  ExamResultItem({
    required this.id,
    required this.examId,
    required this.studentId,
    this.marks,
    this.percentage,
    this.grade,
    this.term,
    required this.isFinal,
    this.classRank,
    this.subject,
    this.examTitle,
    this.examType,
    this.examDate,
  });

  factory ExamResultItem.fromJson(Map<String, dynamic> json) {
    return ExamResultItem(
      id: json['id'] ?? 0,
      examId: json['exam_id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      marks: json['marks']?.toString(),
      percentage: json['percentage']?.toString(),
      grade: json['grade']?.toString(),
      term: json['term']?.toString(),
      isFinal: json['is_final'] ?? false,
      classRank: json['class_rank'],
      subject: json['subject'],
      examTitle: json['exam_title'],
      examType: json['exam_type'],
      examDate: json['exam_date'],
    );
  }
}

class TermResult {
  final String? term;
  final String? totalMarks;
  final String? averagePercentage;
  final String? overallGrade;
  final int? classRank;
  final String? subject;

  TermResult({
    this.term,
    this.totalMarks,
    this.averagePercentage,
    this.overallGrade,
    this.classRank,
    this.subject,
  });

  factory TermResult.fromJson(Map<String, dynamic> json) {
    return TermResult(
      term: json['term']?.toString(),
      totalMarks: json['total_marks']?.toString(),
      averagePercentage: json['average_percentage']?.toString(),
      overallGrade: json['overall_grade']?.toString(),
      classRank: json['class_rank'],
      subject: json['subject'],
    );
  }
}
