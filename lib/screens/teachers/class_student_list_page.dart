import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/teacher_class_student.dart';
import '../../services/teacher_class_student_list.dart';
import '/services/teacher_class_section_service.dart'; // new import
import 'class_teacher_student_details_page.dart';

class ClassStudentListPage extends StatefulWidget {
  const ClassStudentListPage({super.key});

  @override
  State<ClassStudentListPage> createState() => _ClassStudentListPageState();
}

class _ClassStudentListPageState extends State<ClassStudentListPage> {
  List<Student> students = [];
  List<TeacherClass> teacherClasses = [];

  bool isLoading = true;
  String? selectedClassId; // use ID instead of string
  String? selectedClassName;

  @override
  void initState() {
    super.initState();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    try {
      final service = TeacherClassService();
      final fetchedClasses = await service.fetchTeacherClasses();

      setState(() {
        teacherClasses = fetchedClasses;
        if (teacherClasses.isNotEmpty) {
          selectedClassId = teacherClasses.first.id.toString();
          selectedClassName = teacherClasses.first.fullName;
        }
      });

      if (selectedClassId != null) {
        await fetchStudentsForClass(selectedClassId!);
      }
    } catch (e) {
      debugPrint("❌ Error fetching classes: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchStudentsForClass(String classId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final fetchedStudents = await StudentService.fetchStudents(token, );

      setState(() {
        students = fetchedStudents;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error fetching students: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                              width: 120,
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCCCCCC),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedClassId,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.arrow_drop_down),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF29ABE2),
                                  fontWeight: FontWeight.bold,
                                ),
                                items: teacherClasses.map((cls) {
                                  return DropdownMenuItem(
                                    value: cls.id.toString(),
                                    child: Text(cls.fullName),
                                  );
                                }).toList(),
                                onChanged: (value) async {
                                  setState(() {
                                    selectedClassId = value;
                                    selectedClassName = teacherClasses
                                        .firstWhere((c) =>
                                            c.id.toString() == value)
                                        .fullName;
                                    isLoading = true;
                                  });
                                  await fetchStudentsForClass(value!);
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
                            "${students.length} students",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
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
                  const SizedBox(height: 16),

                  // Students list
                  students.isEmpty
                      ? const Center(child: Text('No students in this class.'))
                      : Column(
                          children:
                              students.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final student = entry.value;
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
                backgroundImage:
                    imageUrl != null ? NetworkImage(imageUrl!) : null,
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
