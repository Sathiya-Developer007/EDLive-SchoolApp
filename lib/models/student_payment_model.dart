class StudentPayment {
  final String feeName;
  final String amount;
  final DateTime? dueDate;
  final String? paymentDate;
  final String? upiLink;
  final String paymentStatus;

  StudentPayment({
    required this.feeName,
    required this.amount,
    required this.dueDate,
    required this.paymentStatus,
    this.paymentDate,
    this.upiLink,
  });

  factory StudentPayment.fromJson(Map<String, dynamic> json) {
    return StudentPayment(
      feeName: json['fee_name'],
      amount: json['amount'],
      dueDate: json['due_date'] != null ? DateTime.tryParse(json['due_date']) : null,
      paymentStatus: json['payment_status'] ?? 'pending',
      paymentDate: json['payment_date'],
      upiLink: json['upi_link'],
    );
  }
}