import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student_timetable_model.dart';

class StudentTimetableProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<StudentTimetableEntry> _entries = [];

  // List<StudentTimetableEntry> get entries => _entries;
  List<StudentTimetableEntry> get allEntries => _entries;


  Future<void> load(String studentId, String academicYear) async {
  isLoading = true;
  error = null;
  notifyListeners();

  try {
    final url = Uri.parse(
        'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/student/students/timetable/$studentId/$academicYear');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      _entries = data.map((e) => StudentTimetableEntry.fromJson(e)).toList();
    } else {
      error = 'Failed to fetch timetable';
    }
  } catch (e) {
    error = e.toString();
  }

  isLoading = false;
  notifyListeners();
}

  List<StudentTimetableEntry> entriesForDay(String dayName) {
    return _entries.where((e) => e.timesByDay[dayName] != null).toList();
  }
}
