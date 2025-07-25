import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/teacher_attendance_year.dart';
// import '../models/teacher_student_classsection.dart';
import 'package:school_app/models/teacher_student_classsection.dart';

class AttendanceProvider with ChangeNotifier {
  List<StudentAttendance> _attendanceList = [];
  bool _isLoading = false;

  List<StudentAttendance> get attendanceList => _attendanceList;
  bool get isLoading => _isLoading;

  Future<void> fetchMonthlyStudentAttendance({
    required int classId,
    required List<StudentClassSection> students, 
    required String startDate,
    required String endDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
     final token = prefs.getString('auth_token');

if (token == null || token.isEmpty) {
  print("Auth token missing");
  return;
}


      final response = await http.get(
        Uri.parse('http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/attendance/monthly?classId=$classId&startDate=$startDate&endDate=$endDate'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        _attendanceList = jsonData.map((data) => StudentAttendance.fromJson(data)).toList();
      } else {
        print('Failed to fetch attendance: ${response.statusCode}');
        _attendanceList = [];
      }
    } catch (e) {
      print('Error fetching monthly attendance: $e');
      _attendanceList = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
