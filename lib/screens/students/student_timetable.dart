// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/providers/student_timetable_provider.dart';
import '/widgets/student_app_bar.dart';
import 'student_menu_drawer.dart';
import '/models/student_timetable_day.dart';

class StudentTimeTablePage extends StatefulWidget {
  final String academicYear;
  const StudentTimeTablePage({
    super.key,
    required this.academicYear,
  }) : assert(academicYear != '');

  @override
  State<StudentTimeTablePage> createState() => _StudentTimeTablePageState();
}

class _StudentTimeTablePageState extends State<StudentTimeTablePage> {
  // ── DATE & SCROLL STATE ────────────────────────────────────────────
  late DateTime _centerDate;
  late DateTime _startDate;
  final _scroll = ScrollController();

  // ── OTHER STATE ────────────────────────────────────────────────────
  late final String academicYear;
  static const _TIMES = [
    '9 : 45 am',
    '10 : 30 am',
    '11 : 25 am',
    '1 : 00 pm',
    '1 : 45 pm',
    '2 : 30 pm',
    '3 : 15 pm',
    '4 : 00 pm',
  ];
  static const _MONTHS = [
    '',
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // ── INIT ───────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    academicYear = widget.academicYear; // <- use constructor value
    _centerDate = DateTime.now();
    _startDate = _centerDate.subtract(Duration(days: _centerDate.weekday - 1));

    // kick off API fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentTimetableProvider>().load(academicYear);
      _centerCurrentDate();
    });
  }

  // ── DATE HELPERS ───────────────────────────────────────────────────
  List<DateTime> get _visibleDates =>
      List.generate(30, (i) => _startDate.add(Duration(days: i)));

  String get _monthLabel => "${_MONTHS[_centerDate.month]}. ${_centerDate.year}";

void _centerCurrentDate() {
  final itemWidth = MediaQuery.of(context).size.width / 8.5;
  final index = _centerDate.difference(_startDate).inDays;

  // To make selected day appear in the 4th box (index 3)
  const targetBoxPosition = 3;
  final offset = (index - targetBoxPosition) * itemWidth;

  _scroll.animateTo(
    offset.clamp(0.0, _scroll.position.maxScrollExtent),
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}

  void _onDateTap(DateTime date, int index) {
    setState(() => _centerDate = date);
    _centerCurrentDate();
  }

  // ── BUILD ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final timetable = context.watch<StudentTimetableProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFE8B3DE),
      drawer: const StudentMenuDrawer(),
      appBar: const StudentAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 8),
            _whiteCard(timetable),
          ],
        ),
      ),
    );
  }

  // ── UI PARTS ───────────────────────────────────────────────────────
  Widget _header() {
    // … (unchanged – omitted for brevity)
    // keep exactly what you already have here
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/arrow_back.svg',
                    height: 11, width: 11, color: Colors.black),
                const SizedBox(width: 4),
                const Text('Back',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
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
                child: SvgPicture.asset('assets/icons/class_time.svg',
                    height: 32, width: 32, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text(
                'Time table',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _whiteCard(StudentTimetableProvider timetable) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _monthRow(),
            const SizedBox(height: 12),
            _dateScroller(),
            const SizedBox(height: 16),
            _dayTitle(),
            const SizedBox(height: 12),
            Expanded(child: _periodList(timetable)),
          ],
        ),
      ),
    );
  }

  Widget _monthRow() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 22),
          onPressed: () => setState(() {
            _centerDate =
                DateTime(_centerDate.year, _centerDate.month - 1, _centerDate.day);
            _startDate =
                _centerDate.subtract(Duration(days: _centerDate.weekday - 1));
            _centerCurrentDate();
          }),
        ),
        Expanded(
          child: Center(
            child: Text(
              _monthLabel,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 19, color: Color(0xFF2E3192)),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 22),
          onPressed: () => setState(() {
            _centerDate =
                DateTime(_centerDate.year, _centerDate.month + 1, _centerDate.day);
            _startDate =
                _centerDate.subtract(Duration(days: _centerDate.weekday - 1));
            _centerCurrentDate();
          }),
        ),
      ],
    );
  }

  Widget _dateScroller() {
    final itemWidth = MediaQuery.of(context).size.width / 8.5;
    return SizedBox(
      height: 58,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ListView.builder(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _visibleDates.length,
              itemBuilder: (context, index) {
                final date = _visibleDates[index];
                final selected = date.day == _centerDate.day &&
                    date.month == _centerDate.month &&
                    date.year == _centerDate.year;

                return GestureDetector(
                  onTap: () => _onDateTap(date, index),
                  child: SizedBox(
                    width: itemWidth,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: selected ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : Colors.black87,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected ? Colors.white : Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ← / →
          Positioned(
            left: -12,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 16),
              onPressed: () {
                setState(() => _startDate = _startDate.subtract(const Duration(days: 7)));
                _centerCurrentDate();
              },
            ),
          ),
          Positioned(
            right: -12,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () {
                setState(() => _startDate = _startDate.add(const Duration(days: 7)));
                _centerCurrentDate();
              },
            ),
          ),
        ],
      ),
    );
  }

Widget _dayTitle() {
  final dayName = DateFormat('EEEE').format(_centerDate);
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        dayName,
        style: const TextStyle(
          fontSize: 20,
          color: Color(0xFF2E3192), // dark blue
          fontWeight: FontWeight.bold,
        ),
      ),
      // SvgPicture.asset(
      //   'assets/icons/pencil.svg',
      //   height: 16,
      //   width: 16,
      //   color: Colors.black,
      // ),
    ],
  );
}

  Widget _periodList(StudentTimetableProvider timetable) {
    if (timetable.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (timetable.error != null) {
      return Center(child: Text(timetable.error!));
    }
final dayName = DateFormat('EEEE').format(_centerDate).toLowerCase();
final entries = timetable.entriesForDay(dayName);

if (entries.isEmpty) return const Center(child: Text('No classes today'));

return ListView.builder(
  itemCount: entries.length,
  itemBuilder: (_, i) {
    final item = entries[i];
    final time = item.timesByDay[dayName];
    return _PeriodRow(
      time: time ?? '-',
      subject: item.subject,
    );
  },
);
 }}

// ── SMALL PERIOD ROW WIDGET ──────────────────────────────────────────
class _PeriodRow extends StatelessWidget {
  final String time;
  final String subject;

  const _PeriodRow({required this.time, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                  color: Color(0xFF808080), 
              ),
            ),
          ),
          Expanded(
            child: Text(
              subject,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
