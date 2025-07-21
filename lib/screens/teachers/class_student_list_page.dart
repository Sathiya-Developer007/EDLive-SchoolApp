import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/teacher_class_student.dart';
import '../../services/student_todo_service.dart';
import '../../services/class_service.dart'; // <-- Import new service
import 'teacher_student_details_page.dart';
import 'package:school_app/screens/teachers/teacher_student_details_page.dart';

class ClassStudentListPage extends StatefulWidget {
  const ClassStudentListPage({super.key});

  @override
  State<ClassStudentListPage> createState() => _ClassStudentListPageState();
}

class _ClassStudentListPageState extends State<ClassStudentListPage> {
  List<Student> students = [];
  List<ClassItem> classList = [];
  int? selectedClassId;
  String? selectedClassName;
  String selectedClass = '10A';
  bool isLoading = true;

  // Simulated class-student mapping
  Map<String, List<int>> classToStudentIds = {
    '10A': [18],
    '10B': [19],
    '10C': [],
  };

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await fetchClassList();
    await fetchStudentList();
  }

  Future<void> fetchClassList() async {
    try {
      final fetchedClasses = await ClassService.fetchClasses();
      setState(() {
        classList = fetchedClasses;
        if (classList.isNotEmpty) {
          selectedClassId = classList.first.id;
          selectedClassName = classList.first.name;
        }
      });
    } catch (e) {
      debugPrint("Error fetching class list: $e");
    }
  }

  Future<void> fetchStudentList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token =
          prefs.getString('auth_token') ?? ''; // ✅ Must match login_page.dart

      print("📌 Token used: $token"); // <-- ADD THIS LINE

      final fetchedStudents = await StudentService.fetchStudents(token);
      setState(() {
        students = fetchedStudents;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching students: $e");
    }
  }

  List<Student> get filteredStudents {
    final ids = classToStudentIds[selectedClass] ?? [];
    return students.where((s) => ids.contains(s.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Student List')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown + student count
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select your class",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 125,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCCCCCC),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: selectedClassId,
                          underline: const SizedBox(),
                          icon: const Icon(Icons.arrow_drop_down),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF29ABE2),
                            fontWeight: FontWeight.bold,
                          ),
                          items: classList.map((classItem) {
                            return DropdownMenuItem<int>(
                              value: classItem.id,
                              child: Text(
                                classItem.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF29ABE2),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedClassId = value;
                              selectedClassName = classList
                                  .firstWhere((item) => item.id == value)
                                  .name;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${filteredStudents.length} students",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "You are class teacher",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Your subject: ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  TextSpan(
                    text: 'English1',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Students list
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (filteredStudents.isEmpty)
              const Center(child: Text('No students in this class.'))
            else
              Column(
                children: filteredStudents.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final student = entry.value;
                  // inside the map loop where you build each _StudentRow
                  return _StudentRow(
                    name: "$index. ${student.studentName}",
                    studentId: student.id,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              StudentDetailPage(studentId: student.id),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final String name;
  final int studentId;
  final VoidCallback onTap;
  final bool alert;
  final String? imageUrl;

  const _StudentRow({
    required this.name,
    required this.studentId,
    required this.onTap,
    this.alert = false,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : null,
                child: imageUrl == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(name)),
              if (alert) const Icon(Icons.error_outline, color: Colors.red),
            ],
          ),
          const Divider(color: Colors.grey, thickness: 0.5, height: 16),
        ],
      ),
    );
  }
}
