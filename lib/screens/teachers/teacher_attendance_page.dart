import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:school_app/models/monthly_attendance.dart';
import 'package:school_app/providers/attendance_provider.dart';
import 'package:school_app/services/attendance_service.dart';



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
  String selectedClass = '10A';

  // Step 1: Class-wise student data
  final Map<String, List<Map<String, dynamic>>> classStudentData = {
    "10A": [
      {"name": "Aabith", "M": true, "AN": true},
      {"name": "Abdul Rahman", "M": true, "AN": true},
      {"name": "Abenendranath", "M": true, "AN": false},
    ],
    "10B": [
      {"name": "Barath", "M": true, "AN": false},
      {"name": "Banu", "M": false, "AN": false},
    ],
    "10C": [
      {"name": "Charlie", "M": true, "AN": true},
      {"name": "Chithra", "M": true, "AN": false},
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Step 2: Get student list based on selected class
    List<Map<String, dynamic>> studentList =
        classStudentData[selectedClass] ?? [];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "9, Aug. 2019",
                style: TextStyle(fontSize: 18, color: Color(0xFF2E3192)),
              ),
              const SizedBox(height: 4),
              const Text("Monday", style: TextStyle(fontSize: 14)),
              const Text(
                "1 absentee",
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
              const SizedBox(height: 8),

              // ⬇️ Dropdown container
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 38,
                  width: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCCCCC),
                    // borderRadius: BorderRadius.circular(10),
                  ),
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
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedClass = newValue!;
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
                  Expanded(
                    flex: 3,
                    child: SizedBox(),
                  ), // Empty space above student names
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

        // Step 3: Display dynamic student list
        Expanded(
          child: ListView.builder(
            itemCount: studentList.length,
            itemBuilder: (context, index) {
              final student = studentList[index];
              return Container(
                height: 55, // fixed row height to help alignment
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    // Student name
                    Expanded(
                      flex: 3,
                      child: Text("${index + 1}. ${student['name']}"),
                    ),

                    // M icon
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Icon(
                          student['M'] ? Icons.check : Icons.close,
                          color: student['M'] ? Colors.green : Colors.red,
                          size: 24,
                        ),
                      ),
                    ),

                    // Vertical divider (full height)
                    Container(
                      width: 12,
                      height: double.infinity, // ⬅️ This makes it full height
                      color: Color(0xFFE6E6E6),
                    ),

                    // AN icon
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Icon(
                          student['AN'] ? Icons.check : Icons.close,
                          color: student['AN'] ? Colors.green : Colors.red,
                          size: 24,
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
  State<TeacherAttendanceMonthTab> createState() => _TeacherAttendanceMonthTabState();
}

class _TeacherAttendanceMonthTabState extends State<TeacherAttendanceMonthTab> {
  String selectedClass = "10A";
  bool viewAbsentOnly = false;

  final Map<String, int> classStudentIdMap = {
    '10A': 101,
    '10B': 102,
    '9A': 201,
    '9B': 202,
  };

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() {
    final studentId = classStudentIdMap[selectedClass] ?? 101;
    final provider = Provider.of<AttendanceProvider>(context, listen: false);
    provider.fetchMonthlyAttendance(
      studentId: studentId,
      startDate: "2025-07-01",
      endDate: "2025-07-31",
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);
    final List<StudentAttendance> filteredList = viewAbsentOnly
        ? provider.attendanceList.where((s) => s.absent > 0).toList()
        : provider.attendanceList;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("July 2025", style: TextStyle(fontSize: 18, color: Color(0xFF2E3192))),
              const SizedBox(height: 4),
              Text("${filteredList.length * 10}% Absence", style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    height: 38,
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: const Color(0xFFCCCCCC)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedClass,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2E3192)),
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
                        items: classStudentIdMap.keys.map((String val) {
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
                      const Text("View absence only", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              )
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
                return ListTile(
                  title: Text(student.name),
                  trailing: student.absent > 0
                      ? Text("✘ ${student.absent} absences",
                          style: const TextStyle(color: Colors.red, fontSize: 13))
                      : const Icon(Icons.check, color: Colors.green),
                );
              },
            ),
),
   ],
    );
  }
}