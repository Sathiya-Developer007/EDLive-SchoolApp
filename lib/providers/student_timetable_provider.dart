import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/student_timetable_day.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentTimetableProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<TimetableDay> _days = [];

  List<TimetableDay> get days => _days;

Future<void> load(int academicYear) async {
  isLoading = true;
  error = null;
  notifyListeners();

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token'); // ✅ use correct key

    if (token == null || token.isEmpty) {
      error = 'No token found';
      isLoading = false;
      notifyListeners();
      return;
    }

    final url = Uri.parse(
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/student/students/timetable/$academicYear',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // ✅ add Bearer prefix
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);

      _days = list
          .map((e) => TimetableDay.fromJson(e))
          .toList()
        ..sort((a, b) => _dayIndex(a.dayOfWeek).compareTo(_dayIndex(b.dayOfWeek)));
    } else {
      error = 'HTTP ${response.statusCode}\n${response.body}';
    }
  } catch (e) {
    error = 'Error: $e';
  }

  isLoading = false;
  notifyListeners();
}

// helper
int _dayIndex(String day) {
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  return days.indexOf(day);
}

  TimetableDay? dayByIndex(int index) {
    if (index >= 0 && index < _days.length) {
      return _days[index];
    }
    return null;
  }
}
