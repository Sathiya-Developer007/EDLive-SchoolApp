import 'package:flutter/foundation.dart';
import '../services/library_book_detail_service.dart';

class LibraryBookDetailProvider extends ChangeNotifier {
  final LibraryBookDetailService _service = LibraryBookDetailService();

  bool isLoading = false;
  String? error;
  Map<String, dynamic>? bookDetail;

  Future<void> fetchBook(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      bookDetail = await _service.getBookById(id);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
