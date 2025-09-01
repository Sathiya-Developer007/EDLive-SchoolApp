import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:school_app/models/quicknote_class_model.dart';
import 'package:school_app/models/quicknote_student_model.dart';
import 'package:school_app/services/quicknote_class_service.dart';
import 'package:school_app/services/quicknote_student_service.dart';

class AddQuickNotePage extends StatefulWidget {
  const AddQuickNotePage({super.key});

  @override
  State<AddQuickNotePage> createState() => _AddQuickNotePageState();
}

class _AddQuickNotePageState extends State<AddQuickNotePage> {
  QuickNoteClass? selectedClass;
  QuickNoteStudent? selectedStudent;

  List<QuickNoteStudent> students = [];
  bool isLoadingStudents = false;

  final TextEditingController noteController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  late Future<List<QuickNoteClass>> futureClasses;

  @override
  void initState() {
    super.initState();
    futureClasses = QuickNoteClassService().fetchClasses();
  }

  Future<void> _loadStudents(int classId) async {
    setState(() {
      isLoadingStudents = true;
      students = [];
      selectedStudent = null;
    });

    try {
      students = await QuickNoteStudentService().fetchStudents(classId);
      setState(() {
        selectedStudent = students.isNotEmpty ? students.first : null;
      });
    } catch (e) {
      debugPrint("Error loading students: $e");
    } finally {
      setState(() {
        isLoadingStudents = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3C4D6),
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text("< Back",
                    style: TextStyle(fontSize: 14, color: Colors.black)),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFF2E3192)),
                    child: SvgPicture.asset(
                      'assets/icons/quick_notes.svg',
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Quick Notes",
                    style: TextStyle(
                      color: Color(0xFF2D3E9A),
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // 🔽 Dynamic Class Dropdown
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Class",
                                      style: TextStyle(fontSize: 14)),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 200,
                                    child: FutureBuilder<List<QuickNoteClass>>(
  future: futureClasses,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Text("No classes found");
    } else {
      final classes = snapshot.data!;

      // ✅ Don't call setState inside build
      if (selectedClass == null) {
        // Instead of setState, just assign directly
        selectedClass = classes.first;

        // Trigger async load AFTER build is done
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadStudents(selectedClass!.classId);
        });
      }

      return DropdownButton<QuickNoteClass>(
        value: selectedClass,
        isExpanded: true,
        underline: const SizedBox(),
        items: classes.map((cls) {
          return DropdownMenuItem(
            value: cls,
            child: Text(cls.className),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            setState(() {
              selectedClass = val;
            });
            _loadStudents(val.classId);
          }
        },
      );
    }
  },
),
  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // 🔽 Dynamic Student Dropdown
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Student Name",
                                      style: TextStyle(fontSize: 14)),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 200,
                                    child: isLoadingStudents
                                        ? const Center(
                                            child:
                                                CircularProgressIndicator())
                                        : DropdownButton<QuickNoteStudent>(
                                            value: selectedStudent,
                                            isExpanded: true,
                                            underline: const SizedBox(),
                                            hint: const Text("Select Student"),
                                            items: [
                                              if (students.isNotEmpty)
                                                ...students.map((stu) {
                                                  return DropdownMenuItem(
                                                    value: stu,
                                                    child: Text(stu.fullName),
                                                  );
                                                }),
                                              const DropdownMenuItem(
                                                value: null,
                                                child: Text("All Students"),
                                              )
                                            ],
                                            onChanged: (val) {
                                              setState(() {
                                                selectedStudent = val;
                                              });
                                            },
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Notes, Desc, Links
                              TextField(
                                controller: noteController,
                                decoration: _inputDecoration("Quick Notes"),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: descController,
                                maxLines: 3,
                                decoration: _inputDecoration("Description"),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: linkController,
                                decoration: _inputDecoration("Web Links"),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Add / Remove buttons
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Center(
                                child: Text("Remove",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                debugPrint(
                                    "Added Quick Note for class: ${selectedClass?.className}, student: ${selectedStudent?.fullName ?? "All"}, note: ${noteController.text}, desc: ${descController.text}, link: ${linkController.text}");
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF29ABE2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Center(
                                  child: Text("Add",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
    );
  }
}
