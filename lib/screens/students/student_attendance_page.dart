import 'package:flutter/material.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'student_menu_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:school_app/models/student_attendance_month.dart';
import 'package:school_app/services/student_attendance_month.dart';

class StudentAttendance {
  final String date;
  final String day;
  final bool? morningPresent;
  final bool? afternoonPresent;

  StudentAttendance({
    required this.date,
    required this.day,
    required this.morningPresent,
    required this.afternoonPresent,
  });
}

class StudentAttendancePage extends StatefulWidget {
  final int studentId;

  const StudentAttendancePage({super.key, required this.studentId});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFAEAE),
        drawer: MenuDrawer(),
        appBar: StudentAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      '< Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xFF2E3192),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/Attendance.svg',
                          height: 20,
                          width: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Attendance',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3192),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            TabBar(
                              indicatorColor: Color(0xFF29ABE2),
                              labelColor: Color(0xFF29ABE2),
                              unselectedLabelColor: Colors.black,
                              tabs: [
                                Tab(text: 'Month'),
                                Tab(text: 'Year'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  AttendanceDailyTab(
                                    studentId: widget.studentId,
                                  ),
                                  AttendanceCalendarTab( studentId: widget.studentId,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFAEAE),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceDailyTab extends StatefulWidget {
  final int studentId;

  const AttendanceDailyTab({super.key, required this.studentId});

  @override
  State<AttendanceDailyTab> createState() => _AttendanceDailyTabState();
}

class _AttendanceDailyTabState extends State<AttendanceDailyTab> {
  DateTime _selectedMonth = DateTime.now();
  StudentAttendanceMonth? _attendanceSummary;
  bool _isLoading = true;
  List<StudentAttendance> _attendanceList = [];

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    setState(() => _isLoading = true);
    try {
      String startDate = DateFormat('yyyy-MM-01').format(_selectedMonth);
      String endDate = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0));

      final data = await StudentAttendanceService().fetchMonthlyAttendance(
        studentId: widget.studentId,
        startDate: startDate,
        endDate: endDate,
      );

      // Generate attendance list for the month
      final formatter = DateFormat('yyyy-MM-dd');
      final daysInMonth = DateUtils.getDaysInMonth(
        _selectedMonth.year,
        _selectedMonth.month,
      );
      List<StudentAttendance> generatedList = [];

      for (int i = 1; i <= daysInMonth; i++) {
        final date = DateTime(_selectedMonth.year, _selectedMonth.month, i);
        final dateKey = formatter.format(date);
        final day = DateFormat('EEE').format(date);

        final attendance = data.dailyAttendance[dateKey];
        final bool? morning = attendance?.morningPresent;
        final bool? afternoon = attendance?.afternoonPresent;

        generatedList.add(
          StudentAttendance(
            date: i.toString(),
            day: day,
            morningPresent: morning,
            afternoonPresent: afternoon,
          ),
        );
      }

      setState(() {
        _attendanceSummary = data;
        _attendanceList = generatedList;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching attendance: $e");
      setState(() => _isLoading = false);
    }
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
    _fetchAttendance();
  }

  void _goToNextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
    _fetchAttendance();
  }

  String get formattedMonth =>
      "${_monthNames[_selectedMonth.month - 1]} ${_selectedMonth.year}";
  final List<String> _monthNames = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
       Column(
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _goToPreviousMonth,
          child: const Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          formattedMonth,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E3192),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _goToNextMonth,
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black,
          ),
        ),
      ],
    ),
    const SizedBox(height: 4),
    if (_attendanceSummary != null)
      Text(
        "${_attendanceSummary!.percentage}% Attendance",
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
  ],
),
 const SizedBox(height: 4),
              _attendanceSummary == null
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        // Text(
                        //   'Total Days: ${_attendanceSummary!.totalDays}',
                        //   style: const TextStyle(fontSize: 13),
                        // ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   'Morning: ${_attendanceSummary!.presentMorning}P / ${_attendanceSummary!.absentMorning}A',
                            //   style: const TextStyle(
                            //     color: Colors.black87,
                            //     fontSize: 13,
                            //   ),
                            // ),
                            // Text(
                            //   'Afternoon: ${_attendanceSummary!.presentAfternoon}P / ${_attendanceSummary!.absentAfternoon}A',
                            //   style: const TextStyle(
                            //     color: Colors.black87,
                            //     fontSize: 13,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Present: ${_attendanceSummary!.totalPresent} days',
                              style: const TextStyle(fontSize: 11,
                                color: Color(0xFF39B54A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Total Absent: ${_attendanceSummary!.totalAbsent} days',
                              style: const TextStyle(fontSize: 11 ,
                                color: Color(0xFFC1272D),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Day',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3192),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Morning',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3192),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Afternoon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3192),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(height: 0.5, color: Color(0xFFFFAEAE)),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _attendanceSummary == null
              ? const Center(child: Text("No attendance data available"))
              : ListView.builder(
                  itemCount: _attendanceList.length,
                  itemBuilder: (context, index) {
                    final att = _attendanceList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${att.date}, ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: att.day,
                                    style: TextStyle(
                                      color: Color(0xFF808080),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Icon(
                                att.morningPresent == null
                                    ? Icons.remove
                                    : att.morningPresent!
                                    ? Icons.check
                                    : Icons.close,
                                color: att.morningPresent == null
                                    ? Colors.grey
                                    : att.morningPresent!
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                att.afternoonPresent == null
                                    ? Icons.remove
                                    : att.afternoonPresent!
                                    ? Icons.check
                                    : Icons.close,
                                color: att.afternoonPresent == null
                                    ? Colors.grey
                                    : att.afternoonPresent!
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class AttendanceCalendarTab extends StatefulWidget {
  final int studentId;
  

  const AttendanceCalendarTab({super.key, required this.studentId});

  @override
  State<AttendanceCalendarTab> createState() => _AttendanceCalendarTabState();
}

class _AttendanceCalendarTabState extends State<AttendanceCalendarTab> {

  Map<String, dynamic> getPresentAbsentSummary() {
  int present = 0;
  int absent = 0;

  yearlyAttendanceData.forEach((_, value) {
    bool morning = value['morning_present'] ?? false;
    bool afternoon = value['afternoon_present'] ?? false;

    if (morning) present++;
    else absent++;

    if (afternoon) present++;
    else absent++;
  });

  int total = present + absent;
  double percentage = total == 0 ? 0 : (present / total) * 100;

  return {
    'present': present ~/ 2,
    'absent': absent ~/ 2,
    'percentage': percentage.toStringAsFixed(2),  // <-- Added
  };
}

  
  final ScrollController _scrollController = ScrollController();
  int _highlightedMonthIndex = 0;

  

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  Map<String, Map<String, dynamic>> yearlyAttendanceData = {};
  int selectedYear = DateTime.now().year;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchYearlyAttendance();
  }

  void _onScroll() {
    double offset = _scrollController.offset;
    int approxIndex = (offset / 210).floor();
    if (_highlightedMonthIndex != approxIndex) {
      setState(() {
        _highlightedMonthIndex = approxIndex.clamp(0, _months.length - 1);
      });
    }
  }

  Future<void> _fetchYearlyAttendance() async {
  setState(() => _isLoading = true);
  try {
    final startDate = "$selectedYear-01-01";
    final endDate = "$selectedYear-12-31";

    final data = await StudentAttendanceService().fetchMonthlyAttendance(
      studentId: widget.studentId,
      startDate: startDate,
      endDate: endDate,
    );

    setState(() {
      yearlyAttendanceData = data.dailyAttendance.map((key, value) {
        return MapEntry(key, {
          'morning_present': value.morningPresent,
          'afternoon_present': value.afternoonPresent,
        });
      });
      _isLoading = false;
    });
  } catch (e) {
    print("Error fetching yearly data: $e");
    setState(() => _isLoading = false);
  }
}

  void _goToPreviousYear() {
    setState(() {
      selectedYear--;
    });
    _fetchYearlyAttendance();
  }

  void _goToNextYear() {
    setState(() {
      selectedYear++;
    });
    _fetchYearlyAttendance();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _goToPreviousYear,
                              child: const Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              selectedYear.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E3192),
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: _goToNextYear,
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Color(0xFFE6E6E6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
  Builder(
  builder: (context) {
    final summary = getPresentAbsentSummary();

    return Column(
      children: [
        const SizedBox(height: 4),
        Center(
          child: Text(
            '${summary['percentage']}% Attendance',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black, // black color
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Present : ${summary['present']} days',
              style: const TextStyle(
                color: Color(0xFF39B54A),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            Text(
              'Absent : ${summary['absent']} days',
              style: const TextStyle(
                color: Color(0xFFC1272D),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  },
),

  ],
                    ),
                  ),
                  Container(
                    color: const Color(0xFFE6E6E6),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Sun.',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF808080),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Mon.',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Tue.',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Wed.',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Thu.',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Fri.',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('Sat.',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF808080),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RawScrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 6,
                      radius: const Radius.circular(5),
                      thumbColor: const Color(0xFF999999),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 300),
                        itemCount: _months.length,
                        itemBuilder: (context, index) {
                          final monthName = _months[index];
                          final isHighlighted =
                              index == _highlightedMonthIndex;
                          return buildMonthGrid(monthName, isHighlighted);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget buildMonthGrid(String monthName, bool isHighlighted) {
    int monthIndex = _months.indexOf(monthName) + 1;
    int totalDays = DateTime(selectedYear, monthIndex + 1, 0).day;
    int startWeekday = DateTime(selectedYear, monthIndex, 1).weekday % 7;
    int totalBoxes = totalDays + startWeekday;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Center(
            child: Text(
              monthName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? Color(0xFF2E3192) : Color(0xFFCCCCCC),
              ),
            ),
          ),
          const SizedBox(height: 4),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalBoxes,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              if (index < startWeekday) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFCCCCCC), width: 0.8),
                  ),
                );
              }

              int day = index - startWeekday + 1;
              final date = DateTime(selectedYear, monthIndex, day);
              final dateKey = DateFormat('yyyy-MM-dd').format(date);

              final attendance = yearlyAttendanceData[dateKey];
              final bool? morningPresent = attendance?['morning_present'];
              final bool? afternoonPresent = attendance?['afternoon_present'];
              final bool isSunday = (index % 7 == 0);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFCCCCCC),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: isSunday
                          ? Center(
                              child: Text(
                                day.toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFCCCCCC),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  morningPresent == null
                                      ? Icons.remove
                                      : morningPresent
                                          ? Icons.check
                                          : Icons.close,
                                  size: 12,
                                  color: morningPresent == null
                                      ? Color(0xFFCCCCCC)
                                      : morningPresent
                                          ? Colors.green
                                          : Colors.red,
                                ),
                                Text(
                                  day.toString(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isHighlighted
                                        ? Colors.black
                                        : Color(0xFFCCCCCC),
                                  ),
                                ),
                                Icon(
                                  afternoonPresent == null
                                      ? Icons.remove
                                      : afternoonPresent
                                          ? Icons.check
                                          : Icons.close,
                                  size: 12,
                                  color: afternoonPresent == null
                                      ? Color(0xFFCCCCCC)
                                      : afternoonPresent
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ],
                            ),
                    ),
                    if ((morningPresent == false || afternoonPresent == false) &&
                        !isSunday)
                      Container(
                        height: 3,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFAEAE),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(1),
                            bottomRight: Radius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
