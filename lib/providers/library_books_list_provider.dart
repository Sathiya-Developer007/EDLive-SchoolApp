import 'package:flutter/foundation.dart';
import '../services/library_book_service.dart';

class LibraryBooksListProvider extends ChangeNotifier {
  final LibraryBookService _service = LibraryBookService();

  bool isLoading = false;
  String? error;
  List<dynamic> books = [];

  Future<void> fetchBooks() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      books = await _service.getAllBooks();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
