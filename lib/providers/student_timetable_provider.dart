import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/student_timetable_model.dart';

class StudentTimetableProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<StudentTimetableEntry> _entries = [];

  List<StudentTimetableEntry> get entries => _entries;

  /// ✅ Fetch timetable for a given student & academic year
  Future<void> load(String studentId, String academicYear) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        error = "Authentication token not found.";
        isLoading = false;
        notifyListeners();
        return;
      }

      final url =
          "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/student/students/timetable/$studentId/$academicYear";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = response.body.trim();
        if (body.isEmpty) {
          _entries = [];
        } else {
          final List<dynamic> data = jsonDecode(body);
          _entries = data
              .map((e) => StudentTimetableEntry.fromJson(e))
              .toList();
        }
      } else {
        error = "Failed to load timetable (code: ${response.statusCode})";
      }
    } catch (e) {
      error = "Error loading timetable: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Filter timetable entries by weekday
List<StudentTimetableEntry> entriesForDay(String day) {
  final key = day.toLowerCase(); // e.g. "tuesday"
  return _entries.where((e) {
    final normalized = e.timesByDay.map((k, v) => MapEntry(k.toLowerCase(), v));
    return (normalized[key] != null && (normalized[key]?.isNotEmpty ?? false));
  }).toList();
}



  /// ✅ Refresh timetable (clear & reload)
  Future<void> refresh(String studentId, String academicYear) async {
    _entries.clear();
    notifyListeners();
    await load(studentId, academicYear);
  }

  /// ✅ Clear timetable data (logout or switch user)
  void clear() {
    _entries.clear();
    error = null;
    isLoading = false;
    notifyListeners();
  }
}
