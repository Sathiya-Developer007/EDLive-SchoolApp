import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import '../../models/teacher_resource_class_model.dart';
import '../../models/teacher_resource_subject_model.dart';
import '../../services/teacher_resource_classsection_service.dart';
import '../../services/teacher_resource_subject_service.dart';

import '../../models/teacher_resource_model.dart';
import '../../services/teacher_resource_service.dart';

import 'teacher_resource_addpage.dart';

class TeacherResourcePage extends StatefulWidget {
  const TeacherResourcePage({super.key});

  @override
  State<TeacherResourcePage> createState() => _TeacherResourcePageState();
}

class _TeacherResourcePageState extends State<TeacherResourcePage> {
  String? selectedClass;
  TeacherSubjectModel? selectedSubject;

  List<TeacherClassModel> classList = [];
  List<TeacherSubjectModel> subjectList = [];

  List<TeacherResourceModel> resources = [];
  bool isResourceLoading = true;

  bool isClassLoading = true;
  bool isSubjectLoading = true;

  @override
  void initState() {
    super.initState();
    loadClasses();
    loadSubjects(); // 👈 fetch subjects from API
  }

  Future<void> loadClasses() async {
    try {
      final classes = await TeacherResourceService.fetchTeacherClasses();
      setState(() {
        classList = classes;
        if (classes.isNotEmpty) {
          selectedClass = classes.first.className;
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
          selectedSubject = subjects.first; // default subject
        }
        isSubjectLoading = false;
      });
    } catch (e) {
      setState(() => isSubjectLoading = false);
      debugPrint("Error fetching subjects: $e");
    }
  }

  Future<void> loadResources() async {
    try {
      final classObj = classList.firstWhere(
        (c) => c.className == selectedClass,
        orElse: () => classList.first,
      );
      final classId = classObj.classId;

      final subjectId = selectedSubject?.subjectId;

      final res = await TeacherResourceMainService.fetchResources(
        classId: classId,
        subjectId: subjectId,
      );

      setState(() {
        resources = res;
        isResourceLoading = false;
      });
    } catch (e) {
      setState(() => isResourceLoading = false);
      debugPrint("Error fetching resources: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFD3C4D6);
    const Color headerTextColor = Color(0xFF2D3E9A);

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
              // --- Header ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          '< Back',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeacherResourceAddPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFF29ABE2),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Add",
                              style: TextStyle(
                                color: Color(0xFF29ABE2),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E3192),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/resources.svg',
                          height: 20,
                          width: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Resources',
                        style: TextStyle(
                          color: headerTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- White Container ---
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Dropdown Row ---
                      Row(
                        children: [
                          // 🔹 Class Dropdown
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Class',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Container(
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
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      : DropdownButton<String>(
                                          value: selectedClass,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          items: classList.map((cls) {
                                            return DropdownMenuItem(
                                              value: cls.className,
                                              child: Text(
                                                cls.className,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() {
                                                selectedClass = val;
                                                isResourceLoading = true;
                                              });
                                              loadResources();
                                            }
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),

                          // 🔹 Subject Dropdown (UPDATED)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Subject',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Container(
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
                                            child: CircularProgressIndicator(
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
                                                subj.subjectName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() {
                                                selectedSubject = val;
                                                isResourceLoading = true;
                                              });
                                              loadResources();
                                            }
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Add button row (kept as you wrote)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeacherResourceAddPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Scrollable resource list inside Expanded
                      Expanded(
                        child: SingleChildScrollView(
                          child: Expanded(
  child: isResourceLoading
      ? const Center(child: CircularProgressIndicator())
      : resources.isEmpty
          ? const Center(child: Text("No resources available"))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: resources.map((res) {
                  return _buildResourceItem(
                    title: res.title,
                    description: res.description,
                    linkText: res.webLinks.isNotEmpty ? res.webLinks.first : "",
                    onTap: () {
                      // 👇 open link
                      debugPrint("Opening: ${res.webLinks}");
                    },
                  );
                }).toList(),
              ),
            ),
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
      ),
    );
  }

  Widget _buildResourceItem({
    required String title,
    required String description,
    required String linkText,
    required VoidCallback onTap,
  }) {
    const Color linkColor = Color(0xFF1E3CA7);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    linkText,
                    style: const TextStyle(
                      color: linkColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.pink),
          ],
        ),
      ),
    );
  }
}
