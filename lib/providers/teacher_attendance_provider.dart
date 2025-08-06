import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/teacher_attendance_year.dart';


class AttendanceProvider with ChangeNotifier {
  List<TeacherDailyAttendance> _attendanceList = [];
  bool _isLoading = false;

  List<TeacherDailyAttendance> get attendanceList => _attendanceList;
  bool get isLoading => _isLoading;

  Future<void> fetchTeacherDailyAttendance({
    required int classId,
    required String date,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/attendance/teacher?classId=$classId&date=$date'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        _attendanceList = jsonData
            .map((json) => TeacherDailyAttendance.fromJson(json))
            .toList();
      } else {
        print('Failed to fetch attendance: \${response.statusCode}');
        _attendanceList = [];
      }
    } catch (e) {
      print('Error fetching attendance: \$e');
      _attendanceList = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}