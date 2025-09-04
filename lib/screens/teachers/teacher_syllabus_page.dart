import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


import 'teacher_menu_drawer.dart';
import 'teacher_syllabus_detail_page.dart';

import 'package:school_app/models/class_section.dart';
import 'package:school_app/services/class_section_service.dart';
import 'package:school_app/services/teacher_class_section_service.dart';
import 'package:school_app/services/teacher_syllabus_subject_service.dart';
import 'package:school_app/models/teacher_syllabus_subject_model.dart';
import '../../models/teacher_syllabus_model.dart';
import '../../services/teacher_syllabus_service.dart';

class TeacherSyllabusPage extends StatefulWidget {
  const TeacherSyllabusPage({super.key});

  @override
  State<TeacherSyllabusPage> createState() => _TeacherSyllabusPageState();
}

class _TeacherSyllabusPageState extends State<TeacherSyllabusPage> {
  List<ClassSection> _classSections = [];
  ClassSection? _selectedClass;

  List<Subject> _subjects = [];
  bool _loadingClasses = true;
  bool _loadingSubjects = false;

  List<TeacherClass> _teacherClasses = [];
  TeacherClass? _selectedTeacherClass;
  bool _loadingTeacherClasses = true;

  @override
  void initState() {
    super.initState();
    _loadClasses();
    _loadTeacherClasses();
  }


Future<bool> _addSyllabus({
  required int classId,
  required int subjectId,
  required String term,
  required String academicYear,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token') ?? '';

  final url = Uri.parse('http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/syllabus');
  final body = jsonEncode({
    "class_id": classId,
    "subject_id": subjectId,
    "term": term,
    "academic_year": academicYear,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // <-- add the token here
      },
      body: body,
    );

    if (response.statusCode == 201) {
      return true; // Successfully created
    } else {
      print('Failed to add syllabus: ${response.statusCode} ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error adding syllabus: $e');
    return false;
  }
}


  Future<void> _loadTeacherClasses() async {
    try {
      final classes = await TeacherClassService().fetchTeacherClasses();
      setState(() {
        _teacherClasses = classes;
        if (classes.isNotEmpty) _selectedTeacherClass = classes.first;
        _loadingTeacherClasses = false;
      });
    } catch (e) {
      setState(() => _loadingTeacherClasses = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load teacher classes: $e")),
      );
    }
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await ClassService().fetchClassSections();
      setState(() {
        _classSections = classes;
        if (classes.isNotEmpty) _selectedClass = classes.first;
        _loadingClasses = false;
      });
      if (_selectedClass != null) _loadSubjects(_selectedClass!.id);
    } catch (e) {
      setState(() => _loadingClasses = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load classes: $e")),
      );
    }
  }

  Future<void> _loadSubjects(int classId) async {
    setState(() => _loadingSubjects = true);
    try {
      final subjects = await SyllabusService().fetchSubjects(classId);
      setState(() {
        _subjects = subjects;
        _loadingSubjects = false;
      });
    } catch (e) {
      setState(() => _loadingSubjects = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load subjects: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7D7A7),
      drawer: MenuDrawer(),
      appBar: TeacherAppBar(),
      body: _loadingClasses
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              child:
                                  Text("< Back", style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ),
                      ),

                      // Title Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E3192),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/syllabus.svg',
                                height: 26,
                                width: 26,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Syllabus',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E3192),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Class Dropdown
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Class',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 120,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF4D4D4D)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<ClassSection>(
                                    isExpanded: true,
                                    isDense: true,
                                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF808080)),
                                    value: _selectedClass,
                                    items: _classSections.map((cls) {
                                      return DropdownMenuItem(
                                        value: cls,
                                        child: Text(cls.fullName,
                                            style: const TextStyle(color: Color(0xFF666666))),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val == null) return;
                                      setState(() => _selectedClass = val);
                                      _loadSubjects(val.id);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subject List
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _loadingSubjects
                                ? const Center(child: CircularProgressIndicator())
                                : ListView.builder(
                                    itemCount: _subjects.length,
                                    itemBuilder: (context, index) {
                                      final subject = _subjects[index];
                                      return InkWell(
                                        onTap: () {
                                          if (_selectedClass == null) return;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SyllabusDetailPage(
                                                classId: _selectedClass!.id,
                                                subjectId: subject.id,
                                                selectedClass: _selectedClass!.fullName,
                                                subject: subject.name,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(color: Color(0xFF999999), width: 0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(subject.name,
                                                  style: const TextStyle(
                                                      color: Color(0xFF2E3192),
                                                      fontWeight: FontWeight.w500)),
                                              SvgPicture.asset(
                                                'assets/icons/arrow_right.svg',
                                                height: 18,
                                                width: 18,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Add Button
                Positioned(
                  top: 50,
                  right: 16,
                  child: ElevatedButton.icon(
                    onPressed: _showAddSyllabusDialog,
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text("Add a subject"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF29ABE2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

void _showAddSyllabusDialog() {
  final currentYear = DateTime.now().year;
  final academicYear = '${currentYear}-${currentYear + 1}';
  TeacherClass? selectedClass = _selectedTeacherClass;
  SubjectModel? selectedSubject;
  final termController = TextEditingController(text: 'Term 1');
  List<SubjectModel> subjects = [];
  bool loadingSubjects = true;

  showDialog(
    context: context,
    builder: (context) {
      Future<void> loadSubjects() async {
        try {
          final fetchedSubjects = await SubjectService().fetchSubjects();
          subjects = fetchedSubjects;
          if (subjects.isNotEmpty) selectedSubject = subjects.first;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to load subjects: $e")),
          );
        }
        loadingSubjects = false;
      }

      if (subjects.isEmpty) loadSubjects();

      return StatefulBuilder(builder: (context, setStateDialog) {
        return AlertDialog(
          title: const Text('Add Syllabus'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Class Dropdown
              DropdownButton<TeacherClass>(
                isExpanded: true,
                value: selectedClass,
                items: _teacherClasses.map((cls) {
                  return DropdownMenuItem(
                    value: cls,
                    child: Text(cls.fullName),
                  );
                }).toList(),
                onChanged: (val) {
                  setStateDialog(() => selectedClass = val);
                },
              ),
              const SizedBox(height: 10),

              // Subject Dropdown
              loadingSubjects
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButton<SubjectModel>(
                      isExpanded: true,
                      hint: const Text("Select Subject"),
                      value: selectedSubject,
                      items: subjects.map((sub) {
                        return DropdownMenuItem(
                          value: sub,
                          child: Text(sub.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() => selectedSubject = val);
                      },
                    ),
              const SizedBox(height: 10),

              // Term as editable text
              TextField(
                controller: termController,
                decoration: const InputDecoration(
                  labelText: 'Term',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              // Academic Year
              Text('Academic Year: $academicYear'),
            ],
          ),
          actions: [
            ElevatedButton(
           onPressed: () async {
  if (selectedClass != null && selectedSubject != null) {
    final enteredTerm = termController.text.trim();

    final success = await _addSyllabus(
      classId: selectedClass!.id,
      subjectId: selectedSubject!.id,
      term: enteredTerm,
      academicYear: academicYear,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Syllabus added successfully')),
      );
      Navigator.pop(context);
      // Optionally reload subjects if needed
      if (_selectedClass != null) _loadSubjects(_selectedClass!.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add syllabus')),
      );
    }
  }
},

              child: const Text('Save'),
            ),
          ],
        );
      });
    },
  );
}
}
