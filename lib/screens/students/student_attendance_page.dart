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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
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
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF2E3192)),
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
                                  AttendanceDailyTab(studentId: widget.studentId),
                                  AttendanceCalendarTab(studentId: widget.studentId),
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
      String endDate = DateFormat('yyyy-MM-dd').format(
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0),
      );

      final data = await StudentAttendanceService().fetchMonthlyAttendance(
        studentId: widget.studentId,
        startDate: startDate,
        endDate: endDate,
      );

      // Generate attendance list for the month
      final formatter = DateFormat('yyyy-MM-dd');
      final daysInMonth = DateUtils.getDaysInMonth(_selectedMonth.year, _selectedMonth.month);
      List<StudentAttendance> generatedList = [];

      for (int i = 1; i <= daysInMonth; i++) {
        final date = DateTime(_selectedMonth.year, _selectedMonth.month, i);
        final dateKey = formatter.format(date);
        final day = DateFormat('EEE').format(date);

        final attendance = data.dailyAttendance[dateKey];
        final bool? morning = attendance?.morningPresent;
        final bool? afternoon = attendance?.afternoonPresent;

        generatedList.add(StudentAttendance(
          date: i.toString(),
          day: day,
          morningPresent: morning,
          afternoonPresent: afternoon,
        ));
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

  String get formattedMonth => "${_monthNames[_selectedMonth.month - 1]} ${_selectedMonth.year}";
  final List<String> _monthNames = const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _goToPreviousMonth, 
                    child: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black)
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formattedMonth, 
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF2E3192))
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: _goToNextMonth, 
                    child: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFE6E6E6))
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _attendanceSummary == null
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Text(
                          'Total Days: ${_attendanceSummary!.totalDays}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Morning: ${_attendanceSummary!.presentMorning}P / ${_attendanceSummary!.absentMorning}A',
                              style: const TextStyle(color: Colors.black87, fontSize: 13),
                            ),
                            Text(
                              'Afternoon: ${_attendanceSummary!.presentAfternoon}P / ${_attendanceSummary!.absentAfternoon}A',
                              style: const TextStyle(color: Colors.black87, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Present: ${_attendanceSummary!.totalPresent} days',
                              style: const TextStyle(color: Color(0xFF39B54A), fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Total Absent: ${_attendanceSummary!.totalAbsent} days',
                              style: const TextStyle(color: Color(0xFFC1272D), fontWeight: FontWeight.w500),
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
                      child: Text('Day', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E3192))),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Morning', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E3192))),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('Afternoon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E3192))),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${att.date} ,${att.day}.",
                                  style: const TextStyle(fontSize: 14),
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
  final ScrollController _scrollController = ScrollController();
  int _highlightedMonthIndex = 0;
  int selectedYear = DateTime.now().year;
  StudentAttendanceMonth? _yearlyData;
  bool _isLoading = true;

  DateTime _currentDate = DateTime.now();
  int _currentMonthIndex = DateTime.now().month - 1;

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchYearlyAttendance();

    WidgetsBinding.instance.addPostFrameCallback((_) {
    _scrollController.animateTo(
      _currentMonthIndex * 210.0, // Approximate height of each month
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  });
  }

  Future<void> _fetchYearlyAttendance() async {
    setState(() => _isLoading = true);
    try {
      final startDate = DateFormat('yyyy-MM-dd').format(DateTime(selectedYear, 1, 1));
      final endDate = DateFormat('yyyy-MM-dd').format(DateTime(selectedYear, 12, 31));

      _yearlyData = await StudentAttendanceService().fetchMonthlyAttendance(
        studentId: widget.studentId,
        startDate: startDate,
        endDate: endDate,
      );

      setState(() => _isLoading = false);
    } catch (e) {
      print("Error fetching yearly attendance: $e");
      setState(() => _isLoading = false);
    }
  }

  void _goToPreviousYear() {
    setState(() {
      selectedYear--;
      _fetchYearlyAttendance();
    });
  }

  void _goToNextYear() {
    setState(() {
      selectedYear++;
      _fetchYearlyAttendance();
    });
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

  Map<String, int> _calculateYearlySummary() {
    if (_yearlyData == null) {
      return {
        'totalPresent': 0,
        'totalAbsent': 0,
        'totalDays': 0,
        'percentage': 0,
      };
    }

    return {
      'totalPresent': int.parse(_yearlyData!.totalPresent),
      'totalAbsent': int.parse(_yearlyData!.totalAbsent),
      'totalDays': int.parse(_yearlyData!.totalDays),
      'percentage': int.parse(_yearlyData!.totalDays) > 0 
          ? ((int.parse(_yearlyData!.totalPresent) / int.parse(_yearlyData!.totalDays)) * 100).round() 
          : 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final summary = _calculateYearlySummary();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _goToPreviousYear,
                        child: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
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
                        child: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFE6E6E6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${summary['percentage']}% Attendance',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Present : ${summary['totalPresent']} days',
                        style: const TextStyle(
                          color: Color(0xFF39B54A),
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                      ),
                      Text(
                        'Absent : ${summary['totalAbsent']} days',
                        style: const TextStyle(
                          color: Color(0xFFC1272D),
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _yearlyData == null
                      ? const Center(child: Text("No attendance data available"))
                      : RawScrollbar(
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
                              final isHighlighted = index == _highlightedMonthIndex;
                              
                              return _buildMonthCalendar(
                                monthName: monthName,
                                isHighlighted: isHighlighted,
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthCalendar({
    required String monthName,
    required bool isHighlighted,
  }) {
    int monthIndex = _months.indexOf(monthName) + 1;
     bool isCurrentMonth = monthIndex - 1 == _currentMonthIndex && selectedYear == _currentDate.year;
    int totalDays = DateTime(selectedYear, monthIndex + 1, 0).day;
    int startWeekday = DateTime(selectedYear, monthIndex, 1).weekday % 7;
    int totalBoxes = totalDays + startWeekday;
    final formatter = DateFormat('yyyy-MM-dd');

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
                color: isHighlighted ? Color(0xFF2E3192) : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 4),
          GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
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
              int weekDay = (index % 7);
              bool isSunday = weekDay == 0;
              
              final date = DateTime(selectedYear, monthIndex, day);
              final dateKey = formatter.format(date);
              final attendance = _yearlyData?.dailyAttendance[dateKey];
              final bool? morningPresent = attendance?.morningPresent;
              final bool? afternoonPresent = attendance?.afternoonPresent;
              bool isAbsent = (morningPresent == false || afternoonPresent == false);

              bool isCurrentDate = date.year == _currentDate.year && 
                                date.month == _currentDate.month && 
                                date.day == _currentDate.day;

              return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: isCurrentDate ? Color(0xFF29ABE2) : const Color(0xFFCCCCCC),
                  width: isCurrentDate ? 1.5 : 0.8,
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
                                color: Color(0xFFCCCCCC)),
                            ),
                          )
                        : Stack(
                            children: [
                              // Day number - centered
                              Center(
                                child: Text(
                                  day.toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              // Morning attendance - left middle
                              Positioned(
                                left: 8,
                                top: 0,
                                bottom: 0,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: morningPresent != null
                                      ? Icon(
                                          morningPresent ? Icons.check : Icons.close,
                                          size: 12,
                                          color: morningPresent
                                            ? Colors.green
                                            : Colors.red,
                                        )
                                      : const SizedBox(width: 12),
                                ),
                              ),
                              // Afternoon attendance - right middle
                              Positioned(
                                right: 8,
                                top: 0,
                                bottom: 0,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: afternoonPresent != null
                                      ? Icon(
                                          afternoonPresent ? Icons.check : Icons.close,
                                          size: 12,
                                          color: afternoonPresent
                                            ? Colors.green
                                            : Colors.red,
                                        )
                                      : const SizedBox(width: 12),
                                ),
                              ),
                            ],
                          ),
                  ),
                  if (isAbsent && !isSunday)
                    Container(
                      height: 2,
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