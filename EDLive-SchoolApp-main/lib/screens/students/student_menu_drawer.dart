import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'student_timetable.dart';
import 'student_attendance_page.dart';
import 'student_exams_screen.dart';


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
    {'icon': 'achievements.svg', 'label': 'Achievements', 'route': '/achievements'},
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
                      color: isSelected ? const Color(0xFF29ABE2) : Colors.transparent,
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
    final year = prefs.getString('academic_year') ?? '2024-2025';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentTimeTablePage(academicYear: year),
      ),
    );
  } else if (item['label'] == 'Attendance') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentAttendancePage(studentId: 18),
      ),
    );
  } else if (item['label'] == 'My to do list') {
    Navigator.pushNamed(context, '/student-todo');
  } else if (item['label'] == 'Exams') {
   onTap: () async {
  final prefs = await SharedPreferences.getInstance();
  final classId = prefs.getString('classId') ?? '1'; // Read saved classId

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => StudentExamsScreen(classId: classId), // Pass it here
    ),
  );
};
  }
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
