import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

// Attendance Month
import 'package:school_app/models/teacher_attendance_year.dart';
import 'package:school_app/providers/teacher_attendance_provider.dart';
// import 'package:school_app/services/attendance_service.dart';
import 'package:school_app/models/teacher_student_classsection.dart';

// Attendance Day
import 'package:school_app/services/teacher_student_classsection.dart';
// import 'package:school_app/models/teacher_student_classsection.dart';

final DateTime now = DateTime.now();
final String formattedDate = DateFormat(
  'd, MMM. y',
).format(now); // e.g., 23, Jul. 2025
final String dayName = DateFormat('EEEE').format(now); // e.g., Tuesday

class TeacherAttendancePage extends StatelessWidget {
  const TeacherAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFAEAE),
        drawer: const MenuDrawer(),
        appBar: const TeacherAppBar(),
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
                        color: const Color(0xFF2E3192),
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: const [
                      TabBar(
                        indicatorColor: Color(0xFF29ABE2),
                        labelColor: Color(0xFF29ABE2),
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab(text: 'Day'),
                          Tab(text: 'MonthYear'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            TeacherAttendanceDayTab(),
                            TeacherAttendanceMonthTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeacherAttendanceDayTab extends StatefulWidget {
  const TeacherAttendanceDayTab({super.key});

  @override
  State<TeacherAttendanceDayTab> createState() =>
      _TeacherAttendanceDayTabState();
}

class _TeacherAttendanceDayTabState extends State<TeacherAttendanceDayTab> {
  int totalAbsentees = 0;

  String selectedClass = '10A';
  List<StudentClassSection> students = [];
  bool isLoading = true;

  DateTime selectedDate = DateTime.now();

  List<int> morningTaps = []; // ✅ Step 1
  List<int> afternoonTaps = []; // ✅ Step 1

  final Map<String, int> classIdMap = {'10A': 1, '10B': 2, '10C': 3};
  Future<void> refetchSingleStudentAttendance(int index) async {
    final student = students[index];
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    try {
      final response = await http.get(
        Uri.parse(
          'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/attendance/student?studentId=${student.id}&date=${DateFormat('yyyy-MM-dd').format(selectedDate)}',
        ),
        headers: {'Authorization': 'Bearer $token', 'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body);

        if (dataList.isNotEmpty) {
          final Map<String, dynamic> data = dataList[0];

          setState(() {
            morningTaps[index] = data['is_present_morning'] == true ? 1 : 2;
            afternoonTaps[index] = data['is_present_afternoon'] == true ? 1 : 2;
          });
        }
      } else {
        print("No attendance found for ${student.name}");
      }
    } catch (e) {
      print("Error refetching attendance for ${student.name}: $e");
    }
  }

  Future<void> fetchAttendanceStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      // Reset taps and absentee count before loading new ones
      morningTaps = List.filled(students.length, 0);
      afternoonTaps = List.filled(students.length, 0);
      totalAbsentees = 0;

      for (int i = 0; i < students.length; i++) {
        final student = students[i];

        final response = await http.get(
          Uri.parse(
            'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/attendance/student?studentId=${student.id}&date=${DateFormat('yyyy-MM-dd').format(selectedDate)}',
          ),
          headers: {'Authorization': 'Bearer $token', 'accept': '*/*'},
        );

        final List<dynamic> dataList = jsonDecode(response.body);

        if (dataList.isNotEmpty) {
          final Map<String, dynamic> data = dataList[0];

          setState(() {
            morningTaps[i] = data['is_present_morning'] == true ? 1 : 2;
            afternoonTaps[i] = data['is_present_afternoon'] == true ? 1 : 2;

            if (data['is_present_morning'] == false ||
                data['is_present_afternoon'] == false) {
              totalAbsentees++;
            }
          });
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching attendance: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> toggleAttendance({
    required int studentId,
    required int classId,
    required String session, // "morning" or "afternoon"
    required bool isPresent,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.post(
        Uri.parse(
          'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/attendance/toggle',
        ),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "studentId": studentId,
          "classId": classId,
          "date": DateFormat('yyyy-MM-dd').format(selectedDate),
          "session": session,
          "isPresent": isPresent,
        }),
      );

      if (response.statusCode == 200) {
        print("Attendance updated for $studentId - $session: $isPresent");
      } else {
        print("Failed to update attendance: ${response.statusCode}");
      }
    } catch (e) {
      print("API error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Widget getAttendanceIcon(int state) {
    switch (state) {
      case 1:
        return Icon(Icons.check, color: Colors.green, size: 24);
      case 2:
        return Icon(Icons.close, color: Colors.red, size: 24);
      default:
        return Icon(
          Icons.check_box_outline_blank,
          color: Colors.grey.shade400,
          size: 20,
        );
    }
  }

  void fetchStudents() async {
    try {
      final studentList = await StudentService().fetchStudents();
      setState(() {
        students = studentList;
        morningTaps = List.filled(studentList.length, 0);
        afternoonTaps = List.filled(studentList.length, 0);
      });

      // ✅ Call attendance fetch AFTER students are loaded
      await fetchAttendanceStatus(); // Refetch and update UI based on backend

      setState(() => isLoading = false);
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void _goToPreviousDay() async {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
      isLoading = true;
    });

    await fetchAttendanceStatus();

    setState(() {
      isLoading = false;
    });
  }

  void _goToNextDay() async {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
      isLoading = true;
    });

    await fetchAttendanceStatus();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final formattedDate = DateFormat('d, MMM. y').format(selectedDate);
    final dayName = DateFormat('EEEE').format(selectedDate);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _goToPreviousDay,
                    icon: const Icon(
                      Icons.arrow_left,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2E3192),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _goToNextDay,
                    icon: const Icon(
                      Icons.arrow_right,
                      size: 28,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(dayName, style: const TextStyle(fontSize: 14)),
              Text(
                totalAbsentees == 0
                    ? "No absentees"
                    : "$totalAbsentees absentee${totalAbsentees > 1 ? 's' : ''}",
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),

              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 38,
                  width: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(color: Color(0xFFCCCCCC)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedClass,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF2E3192),
                      ),
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                        color: Color(0xFF29ABE2),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      onChanged: (String? newValue) async {
                        setState(() {
                          selectedClass = newValue!;
                          isLoading = true;
                        });

                        await fetchAttendanceStatus();

                        setState(() {
                          isLoading = false;
                        });
                      },

                      items: <String>['10A', '10B', '10C'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(flex: 3, child: SizedBox()),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "M",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "AN",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text("${index + 1}. ${student.name}"),
                    ),

                    // ✅ Step 3: Morning attendance toggle
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            morningTaps[index] = (morningTaps[index] + 1) % 3;
                          });

                          if (morningTaps[index] != 0) {
                            await toggleAttendance(
                              studentId: student.id,
                              classId: classIdMap[selectedClass]!,
                              session: "morning",
                              isPresent: morningTaps[index] == 1,
                            );

                            // 🔁 Refetch just this student's attendance from backend
                            await refetchSingleStudentAttendance(index);
                          }
                        },

                        child: Center(
                          child: getAttendanceIcon(morningTaps[index]),
                        ),
                      ),
                    ),

                    Container(
                      width: 12,
                      height: double.infinity,
                      color: const Color(0xFFE6E6E6),
                    ),

                    // ✅ Step 3: Afternoon attendance toggle
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            afternoonTaps[index] =
                                (afternoonTaps[index] + 1) % 3;
                          });

                          if (afternoonTaps[index] != 0) {
                            await toggleAttendance(
                              studentId: student.id,
                              classId: classIdMap[selectedClass]!,
                              session: "afternoon",
                              isPresent: afternoonTaps[index] == 1,
                            );

                            // 🔁 Refetch updated attendance
                            await refetchSingleStudentAttendance(index);
                          }
                        },

                        child: Center(
                          child: getAttendanceIcon(afternoonTaps[index]),
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

class TeacherAttendanceMonthTab extends StatefulWidget {
  const TeacherAttendanceMonthTab({super.key});

  @override
  State<TeacherAttendanceMonthTab> createState() =>
      _TeacherAttendanceMonthTabState();
}

class _TeacherAttendanceMonthTabState extends State<TeacherAttendanceMonthTab> {
  String selectedClass = "10A";
  bool viewAbsentOnly = false;

  final Map<String, int> classIdMap = {'10A': 1, '10B': 2, '10C': 3};

  List<StudentClassSection> students = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final provider = Provider.of<AttendanceProvider>(context, listen: false);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final classId = classIdMap[selectedClass]!;
      final now = DateTime.now();
      final firstDay = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime(now.year, now.month, 1));
      final lastDay = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime(now.year, now.month + 1, 0));

      final studentsResponse = await http.get(
        Uri.parse(
          'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/staff/staff/students/list',
        ),
        headers: {'Authorization': 'Bearer $token', 'accept': '*/*'},
      );

      if (studentsResponse.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(studentsResponse.body);

        final List<StudentClassSection> allStudents = jsonData
            .map((data) => StudentClassSection.fromJson(data))
            .toList();

        final filteredStudents = allStudents
            .where((s) => s.classId == classId)
            .toList();

        await provider.fetchMonthlyStudentAttendance(
          classId: classId,
          students: filteredStudents,
          startDate: firstDay,
          endDate: lastDay,
        );

        setState(() {
          students = filteredStudents;
        });
      } else {
        print("Failed to fetch students: ${studentsResponse.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);

    final List<StudentClassSection> filteredList = viewAbsentOnly
        ? students
              .where(
                (s) =>
                    provider.attendanceList
                        .firstWhere(
                          (a) => a.studentId == s.id,
                          orElse: () => StudentAttendance(
                            studentId: s.id,
                            name: s.name,
                            absent: 0,
                          ),
                        )
                        .absent >
                    0,
              )
              .toList()
        : students;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                DateFormat('MMMM yyyy').format(DateTime.now()),
                style: const TextStyle(fontSize: 18, color: Color(0xFF2E3192)),
              ),
              const SizedBox(height: 4),
              Text(
                "${provider.attendanceList.fold<int>(0, (sum, s) => sum + s.absent)} total absences",
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    height: 38,
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: const BoxDecoration(color: Color(0xFFCCCCCC)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedClass,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF2E3192),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF29ABE2),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedClass = newValue!;
                          });
                          fetch();
                        },
                        items: classIdMap.keys.map((String val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          value: viewAbsentOnly,
                          onChanged: (value) {
                            setState(() {
                              viewAbsentOnly = value!;
                            });
                          },
                        ),
                      ),
                      const Text(
                        "View absence only",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredList.isEmpty
              ? const Center(
                  child: Text(
                    "No attendance data available.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final student = filteredList[index];

                    final attendance = provider.attendanceList.firstWhere(
                      (a) => a.studentId == student.id,
                      orElse: () => StudentAttendance(
                        studentId: student.id,
                        name: student.name,
                        absent: 0,
                      ),
                    );

                    return ListTile(
                      title: Text(
                        student.name.isNotEmpty ? student.name : 'No Name',
                        style: const TextStyle(color: Colors.black),
                      ),
                      trailing: attendance.absent > 0
                          ? Text(
                              "✘ ${attendance.absent} absences",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            )
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, color: Colors.green),
                                SizedBox(width: 4),
                                Text(
                                  "0 absences",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
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
