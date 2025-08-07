// models/payment_assignment_model.dart

class PaymentAssignment {
  final int id;
  final int feeTypeId;
  final int classId;
  final String academicYear;
  final String dueDate;
  final String feeName;
  final String baseAmount;
  final String className;
  final String section;
  final String? upiLink;
  final String transactionId;
  final int totalStudents;
  final int pendingCount;
  final List<PendingStudent> pendingStudents;

  PaymentAssignment({
    required this.id,
    required this.feeTypeId,
    required this.classId,
    required this.academicYear,
    required this.dueDate,
    required this.feeName,
    required this.baseAmount,
    required this.className,
    required this.section,
    required this.upiLink,
    required this.transactionId,
    required this.totalStudents,
    required this.pendingCount,
    required this.pendingStudents,
  });

  factory PaymentAssignment.fromJson(Map<String, dynamic> json) {
    return PaymentAssignment(
      id: json['id'],
      feeTypeId: json['fee_type_id'],
      classId: json['class_id'],
      academicYear: json['academic_year'],
      dueDate: json['due_date'],
      feeName: json['fee_name'],
      baseAmount: json['base_amount'],
      className: json['class'],
      section: json['section'],
      upiLink: json['upi_link'],
      transactionId: json['transaction_id'],
      totalStudents: int.parse(json['total_students'] ?? '0'),
      pendingCount: int.parse(json['pending_count'] ?? '0'),
      pendingStudents: (json['pending_students'] as List)
          .map((e) => PendingStudent.fromJson(e))
          .toList(),
    );
  }
}

class PendingStudent {
  final int studentId;
  final String fullName;
  final String admissionNo;

  PendingStudent({
    required this.studentId,
    required this.fullName,
    required this.admissionNo,
  });

  factory PendingStudent.fromJson(Map<String, dynamic> json) {
    return PendingStudent(
      studentId: json['student_id'],
      fullName: json['full_name'],
      admissionNo: json['admission_no'],
    );
  }
}
