// // providers/student_attendance_month_provider.dart
// import 'package:flutter/material.dart';
// import 'package:school_app/models/student_attendance_month.dart';
// import 'package:school_app/services/student_attendance_month.dart';

// class StudentAttendanceMonthProvider extends ChangeNotifier {
//   List<StudentAttendanceMonth> _attendanceList = [];
//   bool _isLoading = false;

//   List<StudentAttendanceMonth> get attendanceList => _attendanceList;
//   bool get isLoading => _isLoading;

//   Future<void> fetchAttendance(int studentId, String startDate, String endDate) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       _attendanceList = await StudentAttendanceMonthService.fetchMonthlyAttendance(
//         studentId: studentId,
//         startDate: startDate,
//         endDate: endDate,
//       );
//     } catch (e) {
//       _attendanceList = [];
//       print('Error fetching attendance: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
