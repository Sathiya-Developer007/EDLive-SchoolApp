import 'package:flutter/material.dart';
import '../models/library_book_copy.dart';
import '../services/library_copy_service.dart';

class LibraryCopyProvider with ChangeNotifier {
  final LibraryCopyService _service = LibraryCopyService();

  bool isLoading = false;
  String? error;

  Future<bool> addCopy(LibraryBookCopy copy) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _service.addCopy(copy);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
