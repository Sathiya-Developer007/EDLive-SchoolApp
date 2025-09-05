class StudentOverdueBook {
  final int id;
  final String title;
  final String author;
  final String barcode;
  final String membershipNumber;
  final String checkoutDate;
  final String dueDate;
  final String status;
  final String fineAmount;

  StudentOverdueBook({
    required this.id,
    required this.title,
    required this.author,
    required this.barcode,
    required this.membershipNumber,
    required this.checkoutDate,
    required this.dueDate,
    required this.status,
    required this.fineAmount,
  });

  factory StudentOverdueBook.fromJson(Map<String, dynamic> json) {
    return StudentOverdueBook(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      author: json['author'] ?? 'Unknown',
      barcode: json['barcode'] ?? '',
      membershipNumber: json['membership_number'] ?? '',
      checkoutDate: json['checkout_date'] ?? '',
      dueDate: json['due_date'] ?? '',
      status: json['status'] ?? '',
      fineAmount: json['fine_amount'] ?? '0.00',
    );
  }
}
