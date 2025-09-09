import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:school_app/providers/student_settings_provider.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'student_menu_drawer.dart';
import 'student_timetable.dart';
import 'student_attendance_page.dart';
import 'student_exams_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:school_app/providers/student_task_provider.dart';
import 'package:school_app/providers/student_notification_dashboard_provider.dart';

import 'student_syllabus_page.dart';
import 'select_child_page.dart';
import 'student_events_holidays_page.dart';
import 'student_school_bus_page.dart';
import 'teacher_list_page.dart';
import 'student_payments_page.dart';
import 'student_report_page.dart';
import 'student_food_page.dart';
import 'student_achievement_page.dart';
import 'student_messages_page.dart';
import 'student_notifiction_page.dart';
import 'student_cocurricular_page.dart';
import 'student_library_page.dart';





class StudentDashboardPage extends StatefulWidget {
  final Map<String, dynamic> childData;
  const StudentDashboardPage({super.key, required this.childData});

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {


  
@override
void initState() {
  super.initState();
  _loadCounts();
}

Future<void> _loadCounts() async {
  final prefs = await SharedPreferences.getInstance();
  final studentId = prefs.getInt("student_id");
  if (studentId != null) {
    Provider.of<DashboardCountsProvider>(context, listen: false)
        .fetchDashboardCounts(studentId);
  }
}


  // Future<void> _loadStudentTodos() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('auth_token');

  //   if (token != null) {
  //     final provider = Provider.of<StudentTaskProvider>(context, listen: false);
  //     provider.setAuthToken(token);
  //     await provider.fetchStudentTodos(); // ✅ Fetch ToDos from backend
  //   }
  // }

  Future<int?> _getStudentId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('student_id');  // 👈 same key you saved in login
}


  String getCurrentAcademicYear() {
    final now = DateTime.now();
    final startYear = now.month >= 6 ? now.year : now.year - 1;
    return '$startYear-${startYear + 1}';
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.childData;
    final settings = Provider.of<StudentSettingsProvider>(context);
    final counts = Provider.of<DashboardCountsProvider>(context);

    return Column(
      children: [
        Expanded(
          child: Scaffold(
            backgroundColor: const Color(0xFFF4F4F4),
            appBar: const StudentAppBar(),
            drawer: const StudentMenuDrawer(),
            body: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelectChildPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      // Icon(Icons.arrow_back, size: 20, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(
                        '< Back',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                  DashboardTile(
  title: 'Notification',
  subtitle: 'A note from teacher',
  iconPath: 'assets/icons/notification.svg',
  color: const Color(0xFFF9F7A5),
  badgeCount: counts.notifications, // ✅ dynamic
  onTap: () {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => StudentNotifictionPage()));
  },
),
                    if (settings.showAchievements)
                 DashboardTile(
  title: 'Achievements',
  subtitle: 'Will appear only if there is any achievement',
  iconPath: 'assets/icons/achievements.svg',
  color: const Color(0xFFF7EB7C),
  badgeCount: counts.achievements, // ✅ dynamic
  onTap: () async {
    final prefs = await SharedPreferences.getInstance();
    final classId = prefs.getInt('class_id') ?? 0;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentAchievementPage(classId: classId)),
    );
  },
),
                  DashboardTile(
  title: 'My To-Do List',
  subtitle: 'Check your tasks',
  iconPath: 'assets/icons/todo.svg',
  color: const Color(0xFF8FD8E5),
  badgeCount: counts.todo, // ✅ dynamic
  onTap: () {
    Navigator.pushNamed(context, '/student-todo', arguments: {
      'studentId': child['studentId'],
      'child': child,
    });
  },
),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DashboardTile(
                        title: 'Attendance',
                        iconPath: 'assets/icons/attendance.svg',
                        color: const Color(0xFFFFCCCC),
                        centerContent: true,
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final studentId = prefs.getInt(
                            'student_id',
                          ); // Make sure you saved it during login

                          if (studentId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StudentAttendancePage(studentId: studentId),
                              ),
                            );
                          } else {
                            // Optional: handle error if ID is not found
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Student ID not found. Please login again.",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                     onTap: () async {
  final prefs = await SharedPreferences.getInstance();
  final studentId = prefs.getInt('student_id');

  if (studentId != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentPaymentsPage(studentId: studentId.toString()), // 👈 convert to String
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student ID not found. Please login again.'),
      ),
    );
  }
},
   child:DashboardTile(
  title: 'Payments',
  subtitle: 'Fee Rs. 2500\nDue on Mar. 2018',
  iconPath: 'assets/icons/payments.svg',
  color: const Color(0xFFC0DD94),
  badgeCount: counts.payments, // ✅ dynamic
  centerContent: true,
),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DashboardTile(
                        title: 'Time table',
                        iconPath: 'assets/icons/class_time.svg',
                        color: const Color(0xFFE8B3DE),
                        centerContent: true,
                        onTap: () {
                          // Wherever you navigate to the timetable page ⬇
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentTimeTablePage(
                                academicYear: '2024-2025',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();

                          // ✅ Safely retrieve the stored student ID
                          final studentIdInt = prefs.getInt('student_id');

                          if (studentIdInt == null) {
                            // ✅ Show error if student_id not found
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Student ID not found'),
                              ),
                            );
                            return;
                          }

                          final studentId = studentIdInt
                              .toString(); // ✅ Convert to String

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentExamsScreen(
                                studentId: studentId,
                              ), // ✅ Pass studentId
                            ),
                          );
                        },
                        child: DashboardTile(
                          title: 'Exams',
                          iconPath: 'assets/icons/exams.svg',
                          color: const Color(0xFFAAE5C8),
                          badgeCount: 2,
                          centerContent: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12), // ✅ Moved here OUTSIDE the Row
                DashboardTile(
                  title: 'Events & Holidays',
                  subtitle: '16, Jan 2019, Pongal (Govt. Holiday)',
                  iconPath: 'assets/icons/events.svg',
                  color: const Color(0xFFF9AFD2),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const EventsHolidaysPage(startInMonthView: true),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),
             // Library

// Reports
DashboardTile(
  title: 'Reports',
  subtitle: 'Progress report updated',
  iconPath: 'assets/icons/reports.svg',
  color: const Color(0xFFFFCCCC),
  badgeCount: 1,
  onTap: () async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getInt('student_id') ?? 0; // Replace with actual key
    if (studentId != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentReportPage(studentId: studentId),
        ),
      );
    }
  },
),

const SizedBox(height: 12),

// Library
DashboardTile(
  title: 'Library',
  subtitle: 'View overdue books',
  iconPath: 'assets/icons/library.svg',
  color: const Color(0xFFA5D6F9),
  badgeCount: counts.library, // ✅ dynamic
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentLibraryPage()),
    );
  },
),const SizedBox(height: 12),


// New Food Section
DashboardTile(
  title: 'Food',
  subtitle: 'Menu updated today',
  iconPath: 'assets/icons/food.svg',
  color: const Color(0xFFFFE0B2),
  centerContent: false, // 👈 use row layout
  height: 65, // 👈 reduced height (140 - 40px)
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StudentFoodPage(),
      ),
    );
  },
),


                const SizedBox(height: 12),
        Row(
  children: [
    if (settings.showSchoolBus)
      Expanded(
        child: DashboardTile(
          title: 'School bus',
          subtitle: '7:45 AM',
          iconPath: 'assets/icons/transport.svg',
          color: const Color(0xFFCCCCFF),
          centerContent: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StudentSchoolBusPage(),
              ),
            );
          },
          onClose: () => settings.updateVisibility('School bus', false),
        ),
      ),
    if (settings.showSchoolBus && settings.showMessage)
      const SizedBox(width: 12),
    if (settings.showMessage)
  Expanded(
  child: // Messages
DashboardTile(
  title: 'Message',
  iconPath: 'assets/icons/message.svg',
  color: const Color(0xFFA3D3A7),
  badgeCount: counts.messages, // ✅ dynamic
  centerContent: true,
),)

  ],
),

const SizedBox(height: 12),

/// Syllabus
if (settings.showSyllabus) // 👈 Step 3 — Added this check
  DashboardTile(
    title: 'Syllabus',
    subtitle: 'Updated on 1 Jan 2019',
    iconPath: 'assets/icons/syllabus.svg',
    color: const Color(0xFF91C1BC),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const StudentSyllabusPage(),
        ),
      );
    },
    onClose: () => settings.updateVisibility('Syllabus', false), // Optional close button
  ),
                const SizedBox(height: 12),
                if (settings.showResources) ...[
                  DashboardTile(
                    title: 'Teachers',
                    subtitle: 'You can interact with teachers',
                    icon: Icons.person,
                    color: const Color(0xFFFFD399),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudentTeacherPage(),
                        ),
                      );
                    },
                    onClose: () => settings.updateVisibility('Teachers', false),
                  ),

                  const SizedBox(height: 12),
                ],
                if (settings.showCoCurricular) ...[
               DashboardTile(
  title: 'Co curricular activities',
  subtitle: 'View your enrolled activities',
  iconPath: 'assets/icons/co_curricular.svg',
  color: const Color(0xFFDBD88A),
  onTap: () async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getInt("student_id") ?? 0;
    final academicYear = "2025-2026";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentActivitiesPage(
          studentId: studentId,
          academicYear: academicYear,
        ),
      ),
    );
  },
  onClose: () => settings.updateVisibility(
    'Co curricular activities',
    false,
  ),
),

                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// DashboardTile widget remains the same, no change needed here.

class DashboardTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? iconPath;
  final IconData? icon;
  final Color color;
  final int? badgeCount;
  final bool centerContent;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  // 👇 NEW: optional height override
  final double? height;

  const DashboardTile({
    super.key,
    required this.title,
    this.iconPath,
    this.icon,
    required this.color,
    this.subtitle,
    this.badgeCount,
    this.centerContent = false,
    this.onTap,
    this.onClose,
    this.height, // 👈 add to constructor
  });

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        iconPath != null
            ? SvgPicture.asset(
                iconPath!,
                height: 36,
                width: 36,
                color: const Color(0xFF0D47A1),
              )
            : Icon(
                icon ?? Icons.help_outline,
                size: 36,
                color: const Color(0xFF0D47A1),
              ),
        if (badgeCount != null)
          Positioned(
            top: -6,
            right: -6,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: const Color(0xFF9E005D),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // 👇 Use the provided height if given; otherwise fall back to default
        height: height ?? (centerContent ? 140 : null),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            if (onClose != null)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onClose,
                  child: const Icon(Icons.close, size: 16, color: Colors.black),
                ),
              ),
            centerContent
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        iconWidget,
                        const SizedBox(height: 8),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        if (subtitle != null) const SizedBox(height: 4),
                        if (subtitle != null)
                          title == 'Payments'
                              ? RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Fee Rs. 2500\n',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF2E3192),
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Due on Mar. 2018',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  subtitle!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: title == 'Attendance'
                                        ? const Color(0xFFED1C24)
                                        : Colors.grey,
                                  ),
                                ),
                      ],
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      iconWidget,
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            if (subtitle != null)
                              Text(
                                subtitle!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}


