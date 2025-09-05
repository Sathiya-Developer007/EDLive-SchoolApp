class StudentLibraryBook {
  final int id;
  final String title;
  final String author;
  final String isbn;
  final String publisher;
  final int publicationYear;
  final String genre;
  final int quantity;
  final int availableQuantity;
  final String location;

  StudentLibraryBook({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.publisher,
    required this.publicationYear,
    required this.genre,
    required this.quantity,
    required this.availableQuantity,
    required this.location,
  });

  factory StudentLibraryBook.fromJson(Map<String, dynamic> json) {
    return StudentLibraryBook(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      isbn: json['isbn'],
      publisher: json['publisher'],
      publicationYear: json['publication_year'],
      genre: json['genre'],
      quantity: json['quantity'],
      availableQuantity: json['available_quantity'],
      location: json['location'],
    );
  }
}
