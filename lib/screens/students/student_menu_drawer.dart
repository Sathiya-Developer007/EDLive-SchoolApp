import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'student_timetable.dart';
import 'student_attendance_page.dart';
import 'student_exams_screen.dart';
import 'student_syllabus_page.dart'; // ✅ Adjust the path if needed
import 'student_events_holidays_page.dart'; // Adjust the path as needed
import 'student_school_bus_page.dart';

class StudentMenuDrawer extends StatefulWidget {
  const StudentMenuDrawer({super.key});

  @override
  State<StudentMenuDrawer> createState() => _StudentMenuDrawerState();
}

class _StudentMenuDrawerState extends State<StudentMenuDrawer> {
  int? selectedIndex;

  final List<Map<String, String>> _menuItems = const [
    {'icon': 'todo.svg', 'label': 'My to do list', 'route': '/student-todo'},
    {'icon': 'timetable.svg', 'label': 'Timetable', 'route': '/timetable'},
    {'icon': 'attendance.svg', 'label': 'Attendance', 'route': '/attendance'},
    {'icon': 'exams.svg', 'label': 'Exams', 'route': '/exams'},
    {'icon': 'payments.svg', 'label': 'Fees', 'route': '/fees'},
    {'icon': 'school_bus.svg', 'label': 'School bus', 'route': '/transport'},
    {'icon': 'syllabus.svg', 'label': 'Syllabus', 'route': '/syllabus'},
    {'icon': 'events.svg', 'label': 'Events & Holidays', 'route': '/events'},
    {'icon': 'reports.svg', 'label': 'Reports', 'route': '/reports'},
    {
      'icon': 'achievements.svg',
      'label': 'Achievements',
      'route': '/achievements',
    },
    {'icon': 'school.svg', 'label': 'My School', 'route': '/school'},
    {'icon': 'calendar.svg', 'label': 'Calendar', 'route': '/calendar'},
    {'icon': 'settings.svg', 'label': 'Settings', 'route': '/settings'},
    {'icon': 'logout.svg', 'label': 'Logout', 'route': '/'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _menuItems.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  final isSelected = index == selectedIndex;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF29ABE2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: SvgPicture.asset(
                        'assets/icons/${item['icon']}',
                        height: 24,
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      title: Text(
                        item['label'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        setState(() {
                          selectedIndex = index;
                        });

                        if (item['label'] == 'Logout') {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('auth_token');
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          );
                        } else if (item['label'] == 'Timetable') {
                          final prefs = await SharedPreferences.getInstance();
                          final year =
                              prefs.getString('academic_year') ?? '2024-2025';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudentTimeTablePage(academicYear: year),
                            ),
                          );
                        } else if (item['label'] == 'Attendance') {
                          final prefs = await SharedPreferences.getInstance();
                          final studentId = prefs.getInt('student_id');

                          if (studentId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StudentAttendancePage(studentId: studentId),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Student ID not found. Please login again.",
                                ),
                              ),
                            );
                          }
                        } else if (item['label'] == 'My to do list') {
                          Navigator.pushNamed(context, '/student-todo');
                      } else if (item['label'] == 'Exams') {
  final prefs = await SharedPreferences.getInstance();

  // ✅ Safely retrieve the stored student ID
  final studentIdInt = prefs.getInt('student_id');

  if (studentIdInt == null) {
    // ✅ Show error if student_id not found
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student ID not found')),
    );
    return;
  }

  final studentId = studentIdInt.toString(); // ✅ Convert to String

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => StudentExamsScreen(studentId: studentId), // ✅ Pass studentId
    ),
  );
}
 else if (item['label'] == 'Syllabus') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StudentSyllabusPage(),
                            ),
                          );
                        } else if (item['label'] == 'Events & Holidays') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EventsHolidaysPage(
                                startInMonthView: true,
                              ),
                            ),
                          );
                        }
                        else if (item['label'] == 'School bus') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const StudentSchoolBusPage(),
    ),
  );
}


                        ;
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
