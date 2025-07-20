// services/attendance_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendanceService {
  Future<List<dynamic>> fetchStudentMonthlyAttendance({
    required String token,
    required int studentId,
    required String startDate,
    required String endDate,
  }) async {
    final url = Uri.parse(
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/attendance/studentMonthly?studentId=$studentId&startDate=$startDate&endDate=$endDate',
    );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded; // should be a List<dynamic>
    } else {
      throw Exception('Failed to fetch student monthly attendance');
    }
  }
}
