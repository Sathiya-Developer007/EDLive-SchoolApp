import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_page.dart';

import 'screens/teachers/teacher_dashboard.dart';
import 'screens/teachers/todo_list_screen.dart';
import 'screens/teachers/class_time_pageview.dart';
import 'screens/teachers/teacher_profile_page.dart';
import 'screens/teachers/settings.dart';
import 'screens/teachers/class_teacher_student_details_page.dart';
import 'screens/teachers/teacher_attendance_page.dart';
import 'screens/teachers/teacher_exam_page.dart';
import 'screens/teachers/teacher_syllabus_page.dart';
import 'screens/teachers/teacher_events_holidays_page.dart';

import 'screens/students/student_dashboard.dart';
import 'screens/students/select_child_page.dart';
import 'screens/students/student_todo_list_screen.dart';
import 'package:school_app/screens/students/student_profile_page.dart';
import 'screens/students/student_timetable.dart';
import 'screens/students/student_settings_page.dart';

import 'providers/student_settings_provider.dart';

import 'providers/teacher_task_provider.dart'; // For teacher
import 'providers/student_task_provider.dart'; // For student
import 'providers/teacher_settings_provider.dart';
import 'providers/teacher_timetable_provider.dart';
import 'providers/student_timetable_provider.dart';
import 'providers/teacher_attendance_provider.dart';
import 'providers/teacher_achievement_provider.dart';

import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final userType = prefs.getString('user_type');
  final userDataString = prefs.getString('user_data');

  Map<String, dynamic>? parsedUserData;
  if (userDataString != null) {
    parsedUserData = jsonDecode(userDataString);
  }

  final selectedChildString = prefs.getString('selected_child');
  Map<String, dynamic>? selectedChild;
  if (selectedChildString != null) {
    selectedChild = jsonDecode(selectedChildString);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TeacherTaskProvider()),
        ChangeNotifierProvider(create: (_) => StudentTaskProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => TimetableProvider()),
        ChangeNotifierProvider(create: (_) => StudentTimetableProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => StudentSettingsProvider()),
         ChangeNotifierProvider(create: (_) => AchievementProvider()),
      ],
      child: MyApp(
        token: token,
        userType: userType,
        userData: parsedUserData,
        selectedChild: selectedChild,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? userType;
  final Map<String, dynamic>? userData;
  final Map<String, dynamic>? selectedChild;

  const MyApp({
    super.key,
    required this.token,
    required this.userType,
    required this.userData,
    required this.selectedChild,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDLive School App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Handle the initial '/' route with token & userType logic first
        if (settings.name == '/') {
          if (token != null) {
            if (userType == 'teacher') {
              return MaterialPageRoute(
                builder: (_) => const TeacherDashboardPage(),
              );
            } else if (userType == 'student' || userType == 'parent') {
              if (selectedChild != null) {
                return MaterialPageRoute(
                  builder: (_) => StudentDashboardPage(childData: selectedChild!),
                );
              } else {
                return MaterialPageRoute(
                  builder: (_) => const SelectChildPage(),
                );
              }
            }
          }
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }

        // Other routes
        switch (settings.name) {
          case '/dashboard':
            return MaterialPageRoute(
              builder: (_) => const TeacherDashboardPage(),
            );
          case '/todo':
            return MaterialPageRoute(builder: (_) => const ToDoListPage());
          case '/classtime':
            return MaterialPageRoute(builder: (_) => const ClassTimePageView());
          case '/profile':
            return MaterialPageRoute(
              builder: (_) => const TeacherProfilePage(),
            );
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsPage());

          // Student routes
          case '/student-todo':
            return MaterialPageRoute(
              builder: (_) => const StudentToDoListPage(),
            );
          case '/student-dashboard':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => StudentDashboardPage(childData: args),
            );
          case '/select-child':
            return MaterialPageRoute(builder: (_) => const SelectChildPage());
          case '/student-details':
            final studentId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => StudentDetailPage(studentId: studentId),
            );
          case '/student-profile':
            final id = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => StudentProfilePage(studentId: id),
            );
          case '/timetable':
            final year = '2024-2025'; // Or dynamically fetch this
            return MaterialPageRoute(
              builder: (_) => StudentTimeTablePage(academicYear: year),
            );
          case '/student-settings':
            return MaterialPageRoute(builder: (_) => const StudentSettingsPage());

          // Teacher menu routes
          case '/attendance':
            return MaterialPageRoute(
              builder: (_) => const TeacherAttendancePage(),
            );
          case '/syllabus':
            return MaterialPageRoute(
              builder: (_) => const TeacherSyllabusPage(),
            );
          case '/exams':
            return MaterialPageRoute(builder: (_) => const TeacherExamPage());
          case '/events':
            return MaterialPageRoute(
              builder: (_) => const TeacherEventsHolidaysPage(),
            );

          default:
            return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      },
    );
  }
}


