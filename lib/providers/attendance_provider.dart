// providers/attendance_provider.dart

import 'package:flutter/material.dart';
import '../models/monthly_attendance.dart';
import '../services/attendance_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceProvider with ChangeNotifier {
  List<StudentAttendance> _attendanceList = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<StudentAttendance> get attendanceList => _attendanceList;

  Future<void> fetchMonthlyAttendance({
    required int studentId,
    required String startDate,
    required String endDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
     final token = prefs.getString('auth_token');

if (token == null || token.isEmpty) {
  debugPrint('Token missing or invalid');
  _isLoading = false;
  notifyListeners();
  return;
}


     final rawList = await AttendanceService().fetchStudentMonthlyAttendance(
  token: token,
  studentId: studentId,
  startDate: startDate,
  endDate: endDate,
);

print('Attendance API response: $rawList'); // 👈 add this


      _attendanceList = rawList
          .map((item) => StudentAttendance.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint('Error fetching attendance: $e');
      _attendanceList = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
