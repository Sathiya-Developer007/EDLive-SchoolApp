import 'package:flutter/material.dart';
import '../models/library_member.dart';
import '../services/library_member_service.dart';

class LibraryMemberProvider with ChangeNotifier {
  final LibraryMemberService _service = LibraryMemberService();

  bool isLoading = false;
  String? error;

  Future<bool> addMember(LibraryMember member) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _service.addMember(member);
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
