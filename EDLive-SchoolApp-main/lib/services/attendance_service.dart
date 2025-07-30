// services/attendance_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_app/models/teacher_attendance_year.dart';


class AttendanceService {
  Future<List<TeacherDailyAttendance>> fetchTeacherDailyAttendance({
    required int classId,
    required String date, // format: yyyy-MM-dd
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.get(
      Uri.parse(
        'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/attendance/teacher?classId=$classId&date=$date',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((e) => TeacherDailyAttendance.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch teacher daily attendance: ${response.statusCode}");
    }
  }
}
