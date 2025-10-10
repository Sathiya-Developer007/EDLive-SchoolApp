import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/exam_type_model.dart';
import '../../models/teacher_class_student.dart';
import '../../services/exam_type_service.dart';
import '../../services/teacher_class_student_list.dart';
import 'package:school_app/services/teacher_class_section_service.dart';
import 'package:school_app/services/teacher_exam_subject_service.dart';

import 'package:provider/provider.dart';

import 'package:school_app/providers/exam_result_provider.dart';



// New creations
import 'package:school_app/services/teacher_exam_result_service.dart';
import '/models/exam_result_model.dart';



final ValueNotifier<String> selectedTerm = ValueNotifier<String>("");

class TeacherReportPage extends StatefulWidget {
  const TeacherReportPage({super.key});

  @override
  State<TeacherReportPage> createState() => _TeacherReportPageState();
}

class _TeacherReportPageState extends State<TeacherReportPage> {
  int? selectedStudentId;

  List<ExamType> examTypes = [];
  ExamType? selectedExamType;
  bool isLoadingExamTypes = true;

  List<Student> students = [];
  bool isLoadingStudents = true;

  List<TeacherClass> teacherClasses = [];
  TeacherClass? selectedClass;
  bool isLoadingClasses = true;

  List<String> subjects = [];
  bool isLoadingSubjects = true;

  // studentId -> subject -> mark
  Map<int, Map<String, String>> studentMarks = {};

  final TextEditingController searchController = TextEditingController();

  List<Student> get filteredStudents {
    if (searchController.text.isEmpty) return students;
    return students
        .where((s) => s.studentName
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _initializePage();
  }



  Future<void> _initializePage() async {
    await _loadTeacherClasses();
    await _loadExamTypes();
  }

  Future<void> _loadTeacherClasses() async {
    try {
      final classes = await TeacherClassService().fetchTeacherClasses();
      setState(() {
        teacherClasses = classes;
        isLoadingClasses = false;
        if (classes.isNotEmpty) selectedClass = classes.first;
      });

      if (classes.isNotEmpty) {
        await _loadSubjectsByClass(classes.first.id);
        await _loadStudentsByClass(classes.first.id);
      }
    } catch (e) {
      setState(() => isLoadingClasses = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load teacher classes: $e")),
      );
    }
  }

  Future<void> _loadExamTypes() async {
    try {
      final types = await ExamTypeService().fetchExamTypes();
      setState(() {
        examTypes = types;
        if (types.isNotEmpty) {
          selectedExamType = types.first;
          selectedTerm.value = types.first.examType;
        }
        isLoadingExamTypes = false;
      });
    } catch (e) {
      setState(() => isLoadingExamTypes = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load exam types: $e")),
      );
    }
  }

Future<void> _loadStudentsByClass(int classId) async {
  setState(() => isLoadingStudents = true);

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final studentList = await StudentService.fetchStudents(token);

    setState(() {
      students = studentList; // no classId filtering
      isLoadingStudents = false;

      // Initialize studentMarks for all students
      for (var st in students) {
        studentMarks[st.id] =
            {for (var subj in subjects) subj: studentMarks[st.id]?[subj] ?? ""};
      }
    });
  } catch (e) {
    setState(() => isLoadingStudents = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to load students: $e")),
    );
  }
}

  Future<void> _loadSubjectsByClass(int classId) async {
    setState(() => isLoadingSubjects = true);
    try {
      final allExams = await TeacherExamService().fetchTeacherExams();
      final filteredExams = allExams.where((e) =>
          e.classId == classId &&
          (selectedExamType == null || e.examType == selectedExamType?.examType));
      final subjectList = filteredExams.map((e) => e.subject).toSet().toList();

      setState(() {
        subjects = subjectList;
        isLoadingSubjects = false;

        // Initialize studentMarks if students already loaded
        for (var st in students) {
          studentMarks[st.id] =
              {for (var s in subjects) s: studentMarks[st.id]?[s] ?? ""};
        }
      });
    } catch (e) {
      setState(() => isLoadingSubjects = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load subjects: $e")),
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TeacherAppBar(),
      drawer: const MenuDrawer(),
      body: Container(
        color: const Color(0xFFFDCFD0),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button + Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: const [
                      SizedBox(width: 4),
                      Text(
                        "< Back",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF2E3192),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/reports.svg",
                        height: 36,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Teacher Report",
                      style: TextStyle(
                        color: Color(0xFF2E3192),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Avg + Dropdowns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Class Average
                SizedBox(
                  width: 135,
                  height: 100,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Total Class Avg %",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF666666),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "78%",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3192),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right side → Dropdowns
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Class Dropdown
// Class Dropdown
// Class Dropdown
isLoadingClasses
    ? const SizedBox(
        height: 42,
        width: 42,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
    : Container(
        height: 42,
        width: MediaQuery.of(context).size.width * 0.4, // 📱 40% of screen width
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: DropdownButton<TeacherClass>(
          value: selectedClass,
          isExpanded: true, // 🔑 take full available width
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down,
              size: 28, color: Colors.black),
          hint: const Text("Select Class"),
          items: teacherClasses.map((cls) {
            return DropdownMenuItem(
              value: cls,
              child: Text(cls.fullName),
            );
          }).toList(),
          onChanged: (newClass) async {
            if (newClass != null) {
              setState(() {
                selectedClass = newClass;
                isLoadingStudents = true;
                isLoadingSubjects = true;
              });
              await _loadSubjectsByClass(newClass.id);
              await _loadStudentsByClass(newClass.id);
            }
          },
        ),
      ),

const SizedBox(height: 12),

// Exam Dropdown
ValueListenableBuilder<String>(
  valueListenable: selectedTerm,
  builder: (context, value, _) {
    if (isLoadingExamTypes) {
      return const SizedBox(
        height: 42,
        width: 42,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (examTypes.isEmpty) {
      return const Text("No Exam Types");
    }
    return Container(
      height: 42,
      width: MediaQuery.of(context).size.width * 0.4, // 📱 40% of screen width
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButton<ExamType>(
        value: selectedExamType,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down,
            size: 28, color: Colors.black),
        items: examTypes.map((exam) {
          return DropdownMenuItem(
            value: exam,
            child: Text(exam.examType),
          );
        }).toList(),
        onChanged: (newVal) async {
          if (newVal != null) {
            setState(() {
              selectedExamType = newVal;
              selectedTerm.value = newVal.examType;
              isLoadingSubjects = true;
            });
            if (selectedClass != null) {
              await _loadSubjectsByClass(selectedClass!.id);
            }
          }
        },
      ),
    );
  },
),

  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Student + Marks
            Expanded(
              child: isLoadingStudents
                  ? const Center(child: CircularProgressIndicator())
                  : isWide
                      ? Row(
                          children: [
                            // Student List
                            SizedBox(
                              width: 300,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.search),
                                      hintText: "Search students",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    onChanged: (val) => setState(() {}),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: filteredStudents.length,
                                      itemBuilder: (context, index) {
                                        final student = filteredStudents[index];
                                        final isSelected =
                                            student.id == selectedStudentId;
                                        return Card(
                                          color: isSelected
                                              ? const Color(0xFFEAEAEA)
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: isSelected
                                                  ? const Color(0xFF2E3192)
                                                  : Colors.grey.shade300,
                                              width: isSelected ? 2 : 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          child: ListTile(
                                            title: Text(
                                              "${student.studentName} (${student.className})",
                                              style: TextStyle(
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: isSelected
                                                    ? const Color(0xFF2E3192)
                                                    : Colors.black87,
                                              ),
                                            ),
                                            trailing: isSelected
                                                ? const Icon(Icons.edit,
                                                    color: Color(0xFF2E3192))
                                                : null,
                                            onTap: () {
                                              setState(() {
                                                selectedStudentId = student.id;
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),

                            // Mark Entry
                            Expanded(
                              child: selectedStudentId == null
                                  ? Center(
                                      child: Text(
                                        "Select a student to enter marks",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    )
                                  : MarkEntryCard(
                                      student: students.firstWhere(
                                          (s) => s.id == selectedStudentId),
                                      subjectsMarks:
                                          studentMarks[selectedStudentId!]!,
                                      onSave: (updatedMarks) {
                                        setState(() {
                                          studentMarks[selectedStudentId!] =
                                              updatedMarks;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Marks saved for ${students.firstWhere((s) => s.id == selectedStudentId).studentName}",
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: "Search students",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onChanged: (val) => setState(() {}),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: ListView.builder(
                                itemCount: filteredStudents.length,
                                itemBuilder: (context, index) {
                                  final student = filteredStudents[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 6),
                                    child: ListTile(
                                      title: Text(
                                          "${student.studentName} (${student.className})"),
                                      trailing: const Icon(Icons.edit,
                                          color: Color(0xFF2E3192)),
                                      onTap: () {
                                        setState(() {
                                          selectedStudentId = student.id;
                                        });
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          shape:
                                              const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                          ),
                                          builder: (_) => Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom,
                                              left: 16,
                                              right: 16,
                                              top: 16,
                                            ),
                                            child: MarkEntryCard(
                                              student: student,
                                              subjectsMarks:
                                                  studentMarks[student.id]!,
                                              onSave: (updatedMarks) {
                                                setState(() {
                                                  studentMarks[student.id] =
                                                      updatedMarks;
                                                });
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Marks saved for ${student.studentName}",
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarkEntryCard extends StatefulWidget {
  final Student student;
  final Map<String, String> subjectsMarks;
  final void Function(Map<String, String>) onSave;

  const MarkEntryCard({
    required this.student,
    required this.subjectsMarks,
    required this.onSave,
    super.key,
  });

  @override
  State<MarkEntryCard> createState() => _MarkEntryCardState();
}

class _MarkEntryCardState extends State<MarkEntryCard> {
  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = {
      for (var e in widget.subjectsMarks.entries)
        e.key: TextEditingController(text: e.value),
    };
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

 void _save() async {
  final updatedMarks = {
    for (var entry in controllers.entries) entry.key: entry.value.text.trim(),
  };
  
  widget.onSave(updatedMarks);

  final provider = Provider.of<ExamResultProvider>(context, listen: false);

  // Loop through each subject and send to backend
  for (var entry in updatedMarks.entries) {
    final marks = int.tryParse(entry.value) ?? 0;
    final percentage = marks.toDouble(); // Or calculate if needed
    final grade = _calculateGrade(marks); // simple grade function
    final examResult = ExamResult(
      examId: widget.student.id, // replace with actual examId
      studentId: widget.student.id,
      marks: marks,
      percentage: percentage,
      grade: grade,
      term: selectedTerm.value,
      isFinal: true,
      classRank: 1, // optionally calculate class rank
    );

    try {
      await provider.saveResult(examResult);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Marks saved for ${widget.student.studentName}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save marks: $e")),
      );
    }
  }
}

// Example grade calculation
String _calculateGrade(int marks) {
  if (marks >= 90) return "A+";
  if (marks >= 80) return "A";
  if (marks >= 70) return "B";
  if (marks >= 60) return "C";
  return "D";
}
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 20, top: 10, left: 4, right: 4),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Marks for ${widget.student.studentName} (${widget.student.className})",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xFF2E3192),
                  ),
                ),
                const SizedBox(height: 24),
                ...controllers.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        labelText: entry.key,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  );
                }),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Save Marks",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF2E3192),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
