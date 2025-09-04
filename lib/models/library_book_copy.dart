class LibraryBookCopy {
  final int? id;
  final int bookId;
  final String barcode;
  final String condition;
  final String? status;

  LibraryBookCopy({
    this.id,
    required this.bookId,
    required this.barcode,
    required this.condition,
    this.status,
  });

  factory LibraryBookCopy.fromJson(Map<String, dynamic> json) {
    return LibraryBookCopy(
      id: json['id'],
      bookId: json['book_id'],
      barcode: json['barcode'],
      condition: json['condition'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "book_id": bookId,
      "barcode": barcode,
      "condition": condition,
    };
  }
}
