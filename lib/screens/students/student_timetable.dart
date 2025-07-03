import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/providers/student_timetable_provider.dart';
import 'package:school_app/models/student_timetable_day.dart';
import '/widgets/student_app_bar.dart';
import 'student_menu_drawer.dart';

/// Student timetable page that fetches data from the backend and
/// displays periods for the selected weekday.
class StudentTimeTablePage extends StatefulWidget {
  /// Academic year to fetch (e.g. 2025)
  final int academicYear;

  const StudentTimeTablePage({super.key, required this.academicYear});

  @override
  State<StudentTimeTablePage> createState() => _StudentTimeTablePageState();
}

class _StudentTimeTablePageState extends State<StudentTimeTablePage> {
  // Selected weekday index (0 = Monday)
  int selectedIndex = 0;

  // Current month shown in the month navigator
  DateTime currentDate = DateTime(2019, 8);

  @override
  void initState() {
    super.initState();
    // Trigger API load once the widget is inserted in the tree
    Future.microtask(() {
      context.read<StudentTimetableProvider>().load(widget.academicYear);
    });
  }

  /* ------------------------------ UI helpers ------------------------------ */
  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  String get formattedMonthYear => "${_monthName(currentDate.month)}. ${currentDate.year}";

  static const _times = [
    '9 : 45 am',
    '10 : 30 am',
    '11 : 25 am',
    '1 : 00 pm',
    '1 : 45 pm',
    '2 : 30 pm',
    '3 : 15 pm',
    '4 : 00 pm',
  ];

  static const _shortDays = ['Mon.', 'Tue.', 'Wed.', 'Thu.', 'Fri.', 'Sat.', 'Sun.'];
  static const _longDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
   final timetable = context.watch<StudentTimetableProvider>();


    return Scaffold(
      backgroundColor: const Color(0xFFE8B3DE),
      drawer: const StudentMenuDrawer(),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildWhiteCard(timetable),
          ],
        ),
      ),
    );
  }

  /* ------------------------------- Widgets ------------------------------- */
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/back_arrow.svg',
                  height: 11,
                  width: 11,
                  color: Colors.black,
                ),
                const SizedBox(width: 4),
                const Text('Back', style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3192),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  'assets/icons/class_time.svg',
                  height: 32,
                  width: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Time table',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3192),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteCard(StudentTimetableProvider timetable) {
    return SizedBox(
      height: 500,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildMonthRow(),
            const SizedBox(height: 12),
            _buildDaySelector(),
            const SizedBox(height: 16),
            _buildDayTitle(),
            const SizedBox(height: 12),
            Expanded(child: _buildPeriodList(timetable)),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthRow() {
  return Row(
    children: [
      IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 22),
        onPressed: () => setState(() {
          currentDate = DateTime(currentDate.year, currentDate.month - 1);
        }),
      ),
      Expanded(                      // 👈 makes the text take remaining width
        child: Center(
          child: Text(
            formattedMonthYear,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: Color(0xFF2E3192),
            ),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.arrow_forward_ios, size: 22),
        onPressed: () => setState(() {
          currentDate = DateTime(currentDate.year, currentDate.month + 1);
        }),
      ),
    ],
  );
}

  Widget _buildDaySelector() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final bool isSelected = selectedIndex == index;
          final double fadeFactor = (1.0 - index * 0.1).clamp(0.4, 1.0);

          final boxColor = isSelected
              ? const Color(0xFF00AEEF)
              : Colors.white.withOpacity(fadeFactor);
          final textColor = isSelected
              ? Colors.white
              : Colors.black.withOpacity(fadeFactor);

          return GestureDetector(
            onTap: () => setState(() => selectedIndex = index),
            child: Container(
              width: 37,
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _shortDays[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    (15 + index).toString(), // demo date numbers
                    style: TextStyle(fontSize: 12, color: textColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _longDays[selectedIndex],
          style: const TextStyle(
            fontSize: 20,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        SvgPicture.asset(
          'assets/icons/pencil.svg',
          height: 16,
          width: 20,
          color: Colors.black,
        ),
      ],
    );
  }

 Widget _buildPeriodList(StudentTimetableProvider timetable) {
  if (timetable.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  if (timetable.error != null) {
    return Center(child: Text(timetable.error!));
  }

  final TimetableDay? day = timetable.dayByIndex(selectedIndex);
  if (day == null) return const SizedBox();

  return ListView.builder(
    itemCount: day.periods.length,
    itemBuilder: (_, i) => PeriodRow(
      time: _times[i],
      subject: day.periods[i] ?? '-',
    ),
  );
}
}

class PeriodRow extends StatelessWidget {
  final String time;
  final String subject;
  final bool highlight;

  const PeriodRow({
    super.key,
    required this.time,
    required this.subject,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFCCCCCC), width: 0.7),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF808080),
              ),
            ),
          ),
          Expanded(
            child: Text(
              subject,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
