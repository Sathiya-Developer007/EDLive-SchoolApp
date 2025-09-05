import 'package:flutter/foundation.dart';
import '../services/library_status_service.dart';

class LibraryStatusProvider extends ChangeNotifier {
  final LibraryStatusService _service = LibraryStatusService();

  bool isLoading = false;
  String? error;
  Map<String, dynamic>? statusData;

  Future<void> fetchStatus() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await _service.getMemberStatus();
      statusData = data?['data'];
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
