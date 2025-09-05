class StudentLibraryCopy {
  final int id;
  final String barcode;
  final String status;
  final String condition;

  StudentLibraryCopy({
    required this.id,
    required this.barcode,
    required this.status,
    required this.condition,
  });

  factory StudentLibraryCopy.fromJson(Map<String, dynamic> json) {
    return StudentLibraryCopy(
      id: json['id'],
      barcode: json['barcode'],
      status: json['status'],
      condition: json['condition'],
    );
  }
}
