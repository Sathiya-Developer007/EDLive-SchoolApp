class ExamResult {
  final int examId;
  final int studentId;
  final int marks;
  final double percentage;
  final String grade;
  final String term;
  final bool isFinal;
  final int classRank;

  ExamResult({
    required this.examId,
    required this.studentId,
    required this.marks,
    required this.percentage,
    required this.grade,
    required this.term,
    required this.isFinal,
    required this.classRank,
  });

  Map<String, dynamic> toJson() {
    return {
      "exam_id": examId,
      "student_id": studentId,
      "marks": marks,
      "percentage": percentage,
      "grade": grade,
      "term": term,
      "is_final": isFinal,
      "class_rank": classRank,
    };
  }

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      examId: json['exam_id'],
      studentId: json['student_id'],
      marks: json['marks'],
      percentage: double.tryParse(json['percentage'].toString()) ?? 0,
      grade: json['grade'],
      term: json['term'],
      isFinal: json['is_final'],
      classRank: json['class_rank'],
    );
  }
}
