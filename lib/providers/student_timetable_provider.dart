import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student_timetable_day.dart';
import '../models/StudentTimetableEntry.dart';

class StudentTimetableProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<StudentTimetableEntry> _entries = [];

  List<StudentTimetableEntry> get entries => _entries;

  Future<void> load(String academicYear) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      print('Student timetable token: $token');

      final response = await http.get(
        Uri.parse('http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/student/students/timetable/$academicYear'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _entries = data.map((e) => StudentTimetableEntry.fromJson(e)).toList();
      } else {
        error = 'Failed to load timetable';
      }
    } catch (e) {
      error = 'Error: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  List<StudentTimetableEntry> entriesForDay(String weekday) {
    return _entries.where((entry) => entry.timesByDay[weekday.toLowerCase()] != null).toList();
  }
}
