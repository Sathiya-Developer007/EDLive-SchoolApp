// services/attendance_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_app/models/teacher_attendance_year.dart';

class AttendanceService {
 Future<List<StudentAttendance>> fetchMonthlyStudentAttendance({
  required int classId,
  required String startDate,
  required String endDate,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token') ?? '';

  // First fetch student list
  final studentListRes = await http.get(
    Uri.parse(
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/staff/staff/students/list?classId=$classId',
    ),
    headers: {
      'Authorization': 'Bearer $token',
      'accept': '*/*',
    },
  );

  if (studentListRes.statusCode != 200) {
    throw Exception("Failed to fetch students");
  }

  final List studentList = jsonDecode(studentListRes.body);

  List<StudentAttendance> result = [];

  for (var student in studentList) {
    final studentId = student['id'];
    final fullName = student['full_name'] ?? 'Unknown';

    final attRes = await http.get(
      Uri.parse(
        'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/attendance/studentMonthly?studentId=$studentId&startDate=$startDate&endDate=$endDate',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      },
    );

    if (attRes.statusCode == 200) {
      final attData = jsonDecode(attRes.body);
      final absent = attData['absent_days'] ?? 0;

      result.add(StudentAttendance(
        studentId: studentId,
        name: fullName,
        absent: absent,
      ));
    }
  }

  return result;
}
}