// lib/screens/teacher_dashboard.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:school_app/screens/teachers/todo_list_screen.dart';
import 'package:school_app/providers/teacher_settings_provider.dart';
import 'package:school_app/providers/teacher_dashboard_provider.dart';

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
import 'teacher_specialcare_page.dart';
import 'teacher_co_curricular_page.dart';
import 'teacher_notifiction_page.dart';
import 'teacher_achivement_page.dart';
import 'teacher_add_library_book_page.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<DashboardProvider>(context, listen: false).fetchCounts());
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final counts = dashboardProvider.counts;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      drawer: const MenuDrawer(),
      appBar: TeacherAppBar(),
      body: dashboardProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                /// First group: Notifications, Achievements, To-do, Reports
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                   DashboardTile(
  title: 'Notifications',
  subtitle: 'PTA meeting on 12, Feb. 2019',
  iconPath: 'assets/icons/notification.svg',
  color: const Color(0xFFF9F7A5),
  badgeCount: counts?.notifications,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TeacherNotificationPage()),
    );
  },
),

                    if (settings.showAchievements)
                      DashboardTile(
                        title: 'Achievements',
                        subtitle: 'Congratulate your teacher',
                        iconPath: 'assets/icons/achievements.svg',
                        color: const Color(0xFFFCEE21),
                        badgeCount: counts?.achievements,
                        onClose: () =>
                            settings.updateVisibility('Achievements', false),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const TeacherAchievementPage()),
                          );
                        },
                      ),
                    if (settings.showTodo)
                      DashboardTile(
                        title: 'Home Work',
                        subtitle: 'Make your own list, set reminder.',
                        iconPath: 'assets/icons/todo.svg',
                        color: const Color(0xFF8FD8E5),
                        badgeCount: counts?.todo,
                        onClose: () =>
                            settings.updateVisibility('My to-do list', false),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ToDoListPage()),
                          );
                        },
                      ),
                    DashboardTile(
                      title: 'Reports',
                      subtitle: 'Progress report updated',
                      iconPath: 'assets/icons/reports.svg',
                      color: const Color(0xFFFFCCCC),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TeacherReportPage()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// Second group: Attendance, Class & Time
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
                                builder: (_) => const TeacherAttendancePage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DashboardTile(
                        title: 'Class & Time',
                        iconPath: 'assets/icons/class_time.svg',
                        color: const Color(0xFFFCDBB1),
                        centerContent: true,
                        onTap: () =>
                            Navigator.pushNamed(context, '/classtime'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// Third group: Payments, Exams
                Row(
                  children: [
                    Expanded(
                      child: DashboardTile(
                        title: 'Payments',
                        iconPath: 'assets/icons/payments.svg',
                        color: const Color(0xFFC0DD94),
                        badgeCount: counts?.payments,
                        centerContent: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TeacherPaymentsPage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DashboardTile(
                        title: 'Exams',
                        iconPath: 'assets/icons/exams.svg',
                        color: const Color(0xFFAAE5C8),
                        // badgeCount: 2, // placeholder
                        centerContent: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TeacherExamPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// Fourth group: Transport, Message
                Row(
                  children: [
               Expanded(
  child: DashboardTile(
    title: 'Transport',
    iconPath: 'assets/icons/transport.svg',
    color: const Color(0xFFCCCCFF),
    centerContent: true,
onTap: () async {
  final prefs = await SharedPreferences.getInstance();
  final userDataString = prefs.getString('user_data');
  int staffId = 0;

  if (userDataString != null) {
    final userData = json.decode(userDataString);
    if (userData['staffid'] != null && userData['staffid'].isNotEmpty) {
      staffId = userData['staffid'][0]; // first staffId
    }
  }

  final now = DateTime.now();
  final academicYear = '${now.year}-${now.year + 1}';

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => TransportPage(
        staffId: staffId,
        academicYear: academicYear,
      ),
    ),
  );
},
  ),
),


                    const SizedBox(width: 12),
                    Expanded(
                      child: DashboardTile(
                        title: 'Message',
                        iconPath: 'assets/icons/message.svg',
                        color: const Color(0xFFE8B3DE),
                        // badgeCount: counts?.messages,
                        centerContent: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TeacherMessagePage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// Fifth group: Events & Holidays, PTA, Library, Syllabus, Special Care, Co-Curricular, Quick Notes, Resources
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    DashboardTile(
                      title: 'Events & Holidays',
                      subtitle: '16 Jan 2019, Pongal',
                      iconPath: 'assets/icons/events.svg',
                      color: const Color(0xFFF9AFD2),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TeacherEventsHolidaysPage(
                                  startInMonthView: true)),
                        );
                      },
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
                                builder: (_) => const TeacherPTAPage()),
                          );
                        },
                      ),
                    if (settings.showLibrary)
                      DashboardTile(
                        title: 'Library',
                        subtitle: 'Manage books and records',
                        iconPath: 'assets/icons/library.svg',
                        color: const Color(0xFFACCFE2),
                        badgeCount: counts?.library,
                        onClose: () =>
                            settings.updateVisibility('Library', false),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AddLibraryBookPage()),
                          );
                        },
                      ),
                    if (settings.showSyllabus)
                      DashboardTile(
                        title: 'Syllabus',
                        subtitle: 'Lessons to be completed',
                        iconPath: 'assets/icons/syllabus.svg',
                        color: const Color(0xFFA3D3A7),
                        onClose: () =>
                            settings.updateVisibility('Syllabus', false),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TeacherSyllabusPage()),
                          );
                        },
                      ),
                    if (settings.showSpecialCare)
                      DashboardTile(
                        title: 'Special care',
                        subtitle: 'Students need your support',
                        iconPath: 'assets/icons/special_care.svg',
                        color: const Color(0xFFFFD399),
                        onClose: () =>
                            settings.updateVisibility('Special care', false),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SpecialCarePage()),
                          );
                        },
                      ),
                    if (settings.showCoCurricular)
                      DashboardTile(
                        title: 'Co curricular activities',
                        subtitle: 'NCC Camp on 23, Jan.2019',
                        iconPath: 'assets/icons/co_curricular.svg',
                        color: const Color(0xFFDBD88A),
                        onClose: () => settings.updateVisibility(
                            'Co curricular activities', false),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const CoCurricularActivitiesPage()),
                          );
                        },
                      ),
                    if (settings.showQuickNotes)
                      DashboardTile(
                        title: 'Sticky notes',
                        subtitle: 'Note anything worth noting',
                        iconPath: 'assets/icons/quick_notes.svg',
                        color: const Color(0xFFE6E6E6),
                        onClose: () =>
                            settings.updateVisibility('Quick Notes', false),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TeacherQuickNotesPage()),
                          );
                        },
                      ),
                    DashboardTile(
                      title: 'Resources',
                      subtitle: 'Useful links and study materials',
                      iconPath: 'assets/icons/resources.svg',
                      color: const Color(0xFFD8CAD8),
                      onClose: () =>
                          settings.updateVisibility('Resources', false),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TeacherResourcePage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

/// DashboardTile widget (no changes)
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
          color: const Color(0xFF0D47A1), // Dark blue
        ),
        if (badgeCount != null && badgeCount! > 0)
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
                            fontSize: 13,
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
                                fontSize: 13,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            if (subtitle != null)
                              Text(
                                subtitle!,
                                style: const TextStyle(
                                  fontSize: 11,
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
  }
}
