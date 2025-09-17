import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student_timetable_model.dart';

class StudentTimetableProvider with ChangeNotifier {
  List<StudentTimetableEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  List<StudentTimetableEntry> get allEntries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load(String studentId, String academicYear) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final url = Uri.parse(
        "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/student/students/timetable/$studentId/$academicYear",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _entries = data.map((e) => StudentTimetableEntry.fromJson(e)).toList();
      } else {
        _error = "Failed to load timetable: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  List<StudentTimetableEntry> entriesForDay(String day) {
    return _entries
        .where((entry) => entry.timesByDay[day] != null)
        .toList();
  }
}
