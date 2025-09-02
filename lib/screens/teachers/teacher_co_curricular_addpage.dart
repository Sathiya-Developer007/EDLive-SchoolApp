import 'package:flutter/material.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/class_section.dart';
import '/services/class_section_service.dart';
import '/models/teacher_class_student.dart';
import 'package:school_app/services/teacher_class_student_list.dart';
import 'package:school_app/services/cocurricular_activity_service.dart';
import 'package:school_app/models/cocurricular_activity_model.dart';

import 'package:school_app/services/co_curricular_enroll_service.dart';

class AddCoCurricularActivityPage extends StatefulWidget {
  const AddCoCurricularActivityPage({super.key});
  @override
  State<AddCoCurricularActivityPage> createState() =>
      _AddCoCurricularActivityPageState();
}

class _AddCoCurricularActivityPageState
    extends State<AddCoCurricularActivityPage> {
      
  List<ClassSection> classSections = [];
  ClassSection? selectedClass;
  List<Student> students = [];
  Student? selectedStudent;
  List<String> categoryNames = [];
  String? selectedCategory;
  List<String> activityNames = [];
  String? selectedActivity;
  List<CoCurricularActivity> allActivities = [];
  // String selectedActivityName = 'Sports & Physical Activities';
  // String selectedActivityType = 'Football';
  TextEditingController remarksController = TextEditingController();
  bool isLoadingClasses = true;
  bool isLoadingStudents = false;

  List<CoCurricularCategory> categories = [];
CoCurricularCategory? selectedCategoryObj;
@override
void initState() {
  super.initState();
  loadClassSections();
}


Future<void> loadClassSections() async {
  try {
    final service = ClassService();
    final sections = await service.fetchClassSections();
    setState(() {
      classSections = sections;
      selectedClass = sections.isNotEmpty ? sections.first : null;
      isLoadingClasses = false;
    });
    await loadStudents();
    if (selectedClass != null) {
      await loadActivitiesForClass(selectedClass!);
      await loadCategories();
    }
  } catch (e) {
    setState(() => isLoadingClasses = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load classes')),
    );
  }
}
  
  Future<void> loadStudents() async {
    setState(() => isLoadingStudents = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final data = await StudentService.fetchStudents(token);
      setState(() {
        students = data; // No filtering
        selectedStudent = students.isNotEmpty ? students.first : null;
        isLoadingStudents = false;
      });
    } catch (e) {
      setState(() => isLoadingStudents = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load students')));
    }
  }


Future<void> loadActivitiesForClass(ClassSection selected) async {
  try {
    final activities =
        await CoCurricularService.fetchActivities(selected.id, '2025-2026');
    setState(() {
      allActivities = activities;
      // Filter activities by selected category if any
      activityNames = activities
          .where((e) => e.categoryName == selectedCategoryObj?.name)
          .map((e) => e.activityName)
          .toList();
      selectedActivity = activityNames.isNotEmpty ? activityNames.first : null;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load activities')),
    );
  }
}

Future<void> loadCategories() async {
  try {
    final cats = await CoCurricularCategoryService.fetchCategories();
    setState(() {
      categories = cats;
      selectedCategoryObj = categories.isNotEmpty ? categories.first : null;

      // Update activity names for the selected category
      activityNames = allActivities
          .where((e) => e.categoryName == selectedCategoryObj?.name)
          .map((e) => e.activityName)
          .toList();
      selectedActivity = activityNames.isNotEmpty ? activityNames.first : null;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load categories')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFDBD88A),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: isLoadingClasses
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                '< Back',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Text(
                              'Add Activity',
                              style: TextStyle(
                                color: Color(0xFF2E3192),
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(width: 50),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Class Dropdown
                        const Text(
                          'Class',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<ClassSection>(
                          value: selectedClass,
                          items: classSections
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c.fullName),
                                ),
                              )
                              .toList(),
                          onChanged: (val) async {
                            setState(() {
                              selectedClass = val;
                              categoryNames = [];
                              selectedCategory = null;
                              activityNames = [];
                              selectedActivity = null;
                            });
                            if (val != null) {
                              await loadActivitiesForClass(val);
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Student Dropdown
                        const Text(
                          'Student Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        isLoadingStudents
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownButtonFormField<Student>(
                                value: selectedStudent,
                                items: students
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s.studentName),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedStudent = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),
                        // Activity Name Dropdown
                        const Text(
                          'Category Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                      DropdownButtonFormField<CoCurricularCategory>(
  value: selectedCategoryObj,
  items: categories
      .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
      .toList(),
  onChanged: (val) {
    setState(() {
      selectedCategoryObj = val;
      // Update activities list based on selected category
      activityNames = allActivities
          .where((e) => e.categoryName == selectedCategoryObj?.name)
          .map((e) => e.activityName)
          .toList();
      selectedActivity = activityNames.isNotEmpty ? activityNames.first : null;
    });
  },
  decoration: InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  ),
),
 const SizedBox(height: 16),
                        // Activity Type Dropdown
                        const Text(
                          'Activity Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value: selectedActivity,
                          items: activityNames
                              .map(
                                (a) =>
                                    DropdownMenuItem(value: a, child: Text(a)),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedActivity = val),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Remarks
                        const Text(
                          'Remarks',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: remarksController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Add/Remove Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text('Add'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                shadowColor: Colors.greenAccent,
                              ),
                              onPressed: () {
                                // TODO: Add logic
                              },
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              label: const Text('Remove'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                shadowColor: Colors.redAccent,
                              ),
                              onPressed: () {
                                // TODO: Remove logic
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
