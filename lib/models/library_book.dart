class LibraryBook {
  final int? id;
  final String title;
  final String author;
  final String isbn;
  final String publisher;
  final int publicationYear;
  final String genre;
  final int quantity;
  final int availableQuantity;
  final String location;

  LibraryBook({
    this.id,
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

  factory LibraryBook.fromJson(Map<String, dynamic> json) {
    return LibraryBook(
      id: json['id'],
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      isbn: json['isbn'] ?? '',
      publisher: json['publisher'] ?? '',
      publicationYear: json['publication_year'] ?? 0,
      genre: json['genre'] ?? '',
      quantity: json['quantity'] ?? 0,
      availableQuantity: json['available_quantity'] ?? 0,
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
      "isbn": isbn,
      "publisher": publisher,
      "publication_year": publicationYear,
      "genre": genre,
      "quantity": quantity,
      "location": location,
    };
  }
}
