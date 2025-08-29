import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'teacher_menu_drawer.dart';

import '../../models/teacher_resource_class_model.dart';
import '../../models/teacher_resource_subject_model.dart';
import '../../services/teacher_resource_classsection_service.dart';
import '../../services/teacher_resource_subject_service.dart';
import 'package:school_app/services/teacher_resource_add_service.dart';

class TeacherResourceAddPage extends StatefulWidget {
  const TeacherResourceAddPage({super.key});

  @override
  State<TeacherResourceAddPage> createState() => _TeacherResourceAddPageState();
}

class _TeacherResourceAddPageState extends State<TeacherResourceAddPage> {
  TeacherClassModel? selectedClass;
  TeacherSubjectModel? selectedSubject;

  List<TeacherClassModel> classList = [];
  List<TeacherSubjectModel> subjectList = [];

  bool isClassLoading = true;
  bool isSubjectLoading = true;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController linkController = TextEditingController();




  @override
  void initState() {
    super.initState();
    loadClasses();
    loadSubjects();
  }

  Future<void> loadClasses() async {
    try {
      final classes = await TeacherResourceService.fetchTeacherClasses();
      setState(() {
        classList = classes;
        if (classes.isNotEmpty) {
          selectedClass = classes.first;
        }
        isClassLoading = false;
      });
    } catch (e) {
      setState(() => isClassLoading = false);
      debugPrint("Error fetching classes: $e");
    }
  }

  Future<void> loadSubjects() async {
    try {
      final subjects = await SubjectResourceService.fetchTeacherSubjects();
      setState(() {
        subjectList = subjects;
        if (subjects.isNotEmpty) {
          selectedSubject = subjects.first;
        }
        isSubjectLoading = false;
      });
    } catch (e) {
      setState(() => isSubjectLoading = false);
      debugPrint("Error fetching subjects: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFD3C4D6); // purple bg
    const Color headerTextColor = Color(0xFF2D3E9A); // dark blue

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + Title Row
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  "< Back",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFF2E3192)),
                    child: SvgPicture.asset(
                      'assets/icons/resources.svg',
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Resources",
                    style: TextStyle(
                      color: headerTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // White container form
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Scrollable form fields
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Class Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Class",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 200,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: isClassLoading
                                          ? const Center(
                                              child: SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            )
                                          : DropdownButton<TeacherClassModel>(
                                              value: selectedClass,
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              items: classList.map((cls) {
                                                return DropdownMenuItem(
                                                  value: cls,
                                                  child: Text(
                                                    cls.className ?? "",
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (val) {
                                                if (val != null) {
                                                  setState(
                                                    () => selectedClass = val,
                                                  );
                                                }
                                              },
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Subject Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Subject",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 200,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: isSubjectLoading
                                          ? const Center(
                                              child: SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            )
                                          : DropdownButton<TeacherSubjectModel>(
                                              value: selectedSubject,
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              items: subjectList.map((subj) {
                                                return DropdownMenuItem(
                                                  value: subj,
                                                  child: Text(
                                                    subj.subjectName ?? "",
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (val) {
                                                if (val != null) {
                                                  setState(
                                                    () => selectedSubject = val,
                                                  );
                                                }
                                              },
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Title
                              const Text(
                                "Resource Title:",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: titleController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Description
                              const Text(
                                "Description:",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: descController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Links
                              const Text(
                                "Web Links:",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: linkController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔹 Buttons always at bottom
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
                                child: Text(
                                  "Remove",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                         Expanded(
  child: GestureDetector(
    onTap: () async {
      if (titleController.text.isEmpty ||
          descController.text.isEmpty ||
          selectedClass == null ||
          selectedSubject == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields")),
        );
        return;
      }

      try {
        final success = await TeacherResourceAddService.addResource(
          title: titleController.text.trim(),
          description: descController.text.trim(),
          webLinks: linkController.text.trim().isNotEmpty
              ? [linkController.text.trim()]
              : [],
          // ✅ use model fields that actually exist
          classId: selectedClass!.classId,       // <— not 'id'
          subjectId: selectedSubject!.subjectId, // <— not 'id'
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Resource added successfully ✅")),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add resource: $e")),
        );
      }
    },
    child: Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF29ABE2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          "Add",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  ),
),
  ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
