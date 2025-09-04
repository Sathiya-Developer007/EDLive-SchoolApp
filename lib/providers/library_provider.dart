import 'package:flutter/material.dart';
import '../models/library_book.dart';
import '../services/library_service.dart';

class LibraryProvider with ChangeNotifier {
  final LibraryService _service = LibraryService();
  List<LibraryBook> _books = [];
  bool _isLoading = false;
  String? _error;

  List<LibraryBook> get books => _books;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBooks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _books = await _service.fetchBooks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addBook(LibraryBook book) async {
    try {
      final newBook = await _service.addBook(book);
      if (newBook != null) {
        _books.add(newBook);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
    return false;
  }
}
