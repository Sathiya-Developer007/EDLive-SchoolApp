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

  TeacherResourceModel? selectedResource;

@override
void initState() {
  super.initState();
  loadClassesAndResources();
  loadSubjects(); // keep fetching subjects
}

Future<void> loadClassesAndResources() async {
  try {
    final classes = await TeacherResourceService.fetchTeacherClasses();
    setState(() {
      classList = classes;
      if (classes.isNotEmpty) selectedClass = classes.first.className;
      isClassLoading = false;
    });

    // ✅ after setting default class & subject, load resources
    if (selectedClass != null && selectedSubject != null) {
      loadResources();
    }
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
      if (subjects.isNotEmpty) selectedSubject = subjects.first;
      isSubjectLoading = false;
    });

    // ✅ after setting default subject & class, load resources
    if (selectedClass != null && selectedSubject != null) {
      loadResources();
    }
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFF29ABE2), // ✅ white background
          borderRadius: BorderRadius.circular(10), // optional rounding
        ),
        child: Row(
          children: const [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            SizedBox(width: 4),
            Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
                  padding: selectedResource == null
                      ? const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ) // list view
                      : const EdgeInsets.only(
                          left: 13,
                          right: 13,
                          top: 16,
                          bottom: 16,
                        ), // detail view → reduce right
                  child: selectedResource == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Dropdown Row (only in list view) ---
                            Row(
                              children: [
                                // 🔹 Class Dropdown
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
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

                                // 🔹 Subject Dropdown
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
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
                                            : DropdownButton<
                                                TeacherSubjectModel
                                              >(
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

                            const SizedBox(height: 16),

                            // --- Resource List ---
                            Expanded(child: _buildResourceListView()),
                          ],
                        )
                      : _buildResourceDetailView(
                          selectedResource!,
                        ), // detail view
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceListView() {
    return isResourceLoading
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
                    debugPrint("Opening: ${res.webLinks}");
                  },
                  onDetailsTap: () {
                    setState(() {
                      selectedResource = res; // ✅ switch to details
                    });
                  },
                );
              }).toList(),
            ),
          );
  }

  Widget _buildResourceDetailView(TeacherResourceModel res) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 2,
          right: 0,
        ), // ✅ right side space removed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3192)),
                  onPressed: () {
                    setState(() {
                      selectedResource = null; // ✅ back to list
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    res.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3192),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14), // 👈 space between header & desc

            Text(
              res.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.8, // 👈 more line spacing
              ),
            ),

            const SizedBox(height: 20), // 👈 bigger space before links

            if (res.webLinks.isNotEmpty) ...[
              const Text(
                "Links:",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: res.webLinks.map((link) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ), // 👈 space between links
                    child: GestureDetector(
                      onTap: () {
                        debugPrint("Open link: $link");
                        // 👉 use url_launcher.launchUrl(Uri.parse(link));
                      },
                      child: Text(
                        link,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration:
                              TextDecoration.none, // 👈 underline removed
                          height: 1.6, // 👈 better readability
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem({
    required String title,
    required String description,
    required String linkText,
    required VoidCallback onTap,
    required VoidCallback onDetailsTap,
  }) {
    const Color linkColor = Color(0xFF1E3CA7);

    return Container(
      padding: const EdgeInsets.only(bottom: 12, top: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5), // bottom line
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Left side (title, description, link)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1, // ✅ only 2 lines show
                  overflow:
                      TextOverflow.ellipsis, // ✅ remaining text cut with ...
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),

                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    linkText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue, // keep blue if you want link color
                      decoration: TextDecoration.none, // ✅ removes underline
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Right side arrow (opens details)
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            onPressed: onDetailsTap,
          ),
        ],
      ),
    );
  }
}
