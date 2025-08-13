// lib/screens/teacher_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:school_app/screens/teachers/todo_list_screen.dart';
import 'package:school_app/providers/teacher_settings_provider.dart'; // Updated import


import 'teacher_menu_drawer.dart';
import 'teacher_attendance_page.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'teacher_exam_page.dart';
import 'teacher_transport.dart';
import 'teacher_syllabus_page.dart';
import 'teacher_events_holidays_page.dart';
import 'teacher_payments_page.dart';
import 'teacher_pta_page.dart';
import 'teacher_message_page.dart';
import 'teacher_resource_page.dart';
import 'teacher_report_page.dart';
import 'teacher_quick_notes.dart';



class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Column(
      children: [
        Expanded(
          child: Scaffold(
            backgroundColor: const Color(0xFFF4F4F4),
            drawer: const MenuDrawer(),
            appBar: TeacherAppBar(),
              body: ListView(
              padding: const EdgeInsets.all(1),
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    DashboardTile(
                      title: 'Notifications',
                      subtitle: 'PTA meeting on 12, Feb. 2019',
                      iconPath: 'assets/icons/notification.svg',
                      color: const Color(0xFFF9F7A5),
                      badgeCount: 1,
                    ),
                    if (settings.showAchievements)
                      DashboardTile(
                        title: 'Achievements',
                        subtitle: 'Congratulate your student',
                        iconPath: 'assets/icons/achievements.svg',
                        color: const Color(0xFFFCEE21),
                        badgeCount: 1,
                        onClose: () => settings.updateVisibility('Achievements', false),
                      ),
                    if (settings.showTodo)
                      DashboardTile(
                        title: 'My to-do list',
                        subtitle: 'Make your own list, set reminder.',
                        iconPath: 'assets/icons/todo.svg',
                        color: const Color(0xFF8FD8E5),
                        badgeCount: 4,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ToDoListPage()),
                          );
                        },
                        onClose: () => settings.updateVisibility('My to-do list', false),
                      ),
                   DashboardTile(
  title: 'Reports',
  subtitle: 'Progress report updated',
  iconPath: 'assets/icons/reports.svg',
  color: const Color(0xFFFFCCCC),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TeacherReportPage()),
    );
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
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TeacherAttendancePage(), // Replace with your page
        ),
      );
    },
  ),
),
    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/classtime'),
                        child: DashboardTile(
                          title: 'Class & Time',
                          iconPath: 'assets/icons/class_time.svg',
                          color: const Color(0xFFFCDBB1),
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
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const TeacherPaymentsPage(),
        ),
      );
    },
    child: DashboardTile(
      title: 'Payments',
      iconPath: 'assets/icons/payments.svg',
      color: const Color(0xFFC0DD94),
      badgeCount: 3,
      centerContent: true,
    ),
  ),
),

                    const SizedBox(width: 12),
                   Expanded(
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TeacherExamPage()),
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
                const SizedBox(height: 12),
                Row(
                  children: [
                   Expanded(
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TransportPage()),
      );
    },
    child: DashboardTile(
      title: 'Transport',
      iconPath: 'assets/icons/transport.svg',
      color: const Color(0xFFCCCCFF),
      centerContent: true,
    ),
  ),
),

                    const SizedBox(width: 12),
                    Expanded(
  child: DashboardTile(
    title: 'Message',
    iconPath: 'assets/icons/message.svg',
    color: const Color(0xFFE8B3DE),
    centerContent: true,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TeacherMessagePage()),
      );
    },
  ),
),

                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                   GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TeacherEventsHolidaysPage(startInMonthView: true),
      ),
    );
  },
  child: DashboardTile(
    title: 'Events & Holidays',
    subtitle: '16 Jan 2019, Pongal',
    iconPath: 'assets/icons/events.svg',
    color: const Color(0xFFF9AFD2),
  ),
),

                    if (settings.showPTA)
                     DashboardTile(
  title: 'PTA',
  subtitle: 'Next meeting: 22 Sep. 2019',
  iconPath: 'assets/icons/pta.svg',
  color: const Color(0xFFDBC0B6),
  onClose: () => settings.updateVisibility('PTA', false),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TeacherPTAPage(), // PTA page widget
      ),
    );
  },
)
,
                    if (settings.showLibrary)
                      DashboardTile(
                        title: 'Library',
                        subtitle: '16 Jan 2019, Pongal',
                        iconPath: 'assets/icons/library.svg',
                        color: const Color(0xFFACCFE2),
                        badgeCount: 1,
                        onClose: () => settings.updateVisibility('Library', false),
                      ),
                    if (settings.showSyllabus)
                     GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TeacherSyllabusPage()),
    );
  },
  child: DashboardTile(
    title: 'Syllabus',
    subtitle: 'Lessons to be completed',
    iconPath: 'assets/icons/syllabus.svg',
    color: const Color(0xFFA3D3A7),
    onClose: () => settings.updateVisibility('Syllabus', false),
  ),
),

                    if (settings.showSpecialCare)
                      DashboardTile(
                        title: 'Special care',
                        subtitle: 'Students need your support',
                        iconPath: 'assets/icons/special_care.svg',
                        color: const Color(0xFFFFD399),
                        onClose: () => settings.updateVisibility('Special care', false),
                      ),
                    if (settings.showCoCurricular)
                      DashboardTile(
                        title: 'Co curricular activities',
                        subtitle: 'NCC Camp on 23, Jan.2019',
                        iconPath: 'assets/icons/co_curricular.svg',
                        color: const Color(0xFFDBD88A),
                        onClose: () => settings.updateVisibility('Co curricular activities', false),
                      ),
                    if (settings.showQuickNotes)
                     DashboardTile(
  title: 'Quick notes',
  subtitle: 'Note anything worth noting',
  iconPath: 'assets/icons/quick_notes.svg',
  color: const Color(0xFFE6E6E6),
  onClose: () => settings.updateVisibility('Quick notes', false),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TeacherQuickNotesPage()),
    );
  },
),

                    DashboardTile(
  title: 'Resources',
  subtitle: 'Useful links and study materials',
  iconPath: 'assets/icons/resources.svg',
  color: const Color(0xFFD8CAD8),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TeacherResourcePage()),
    );
  },
  onClose: () => settings.updateVisibility('Resources', false),
)

                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconPath;
  final Color color;
  final int? badgeCount;
  final bool centerContent;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  const DashboardTile({
    super.key,
    required this.title,
    required this.iconPath,
    required this.color,
    this.subtitle,
    this.badgeCount,
    this.centerContent = false,
    this.onTap,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final svgIcon = Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          iconPath,
          height: 36,
          width: 36,
          color: const Color(0xFF0D47A1),
        ),
        if (badgeCount != null)
          Positioned(
            top: -6,
            right: iconPath.contains('payments') ? -8 : -6,
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
        height: centerContent ? 100 : null,
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
                        svgIcon,
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
                      ],
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      svgIcon,
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
                                  color: Colors.grey,
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
  }}