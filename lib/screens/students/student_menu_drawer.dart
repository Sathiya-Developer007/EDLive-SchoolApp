import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentMenuDrawer extends StatelessWidget {
  const StudentMenuDrawer({super.key});

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
            // 🔲 Close icon
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // 🔳 Menu items
            Expanded(
              child: ListView.builder(
                itemCount: _menuItems.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
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
                        if (item['label'] == 'Logout') {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('auth_token');
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          );
                        } else {
                          Navigator.pushNamed(context, item['route']!);
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
