import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

import 'teacher_menu_drawer.dart';
import 'teacher_syllabus_detail_page.dart';

import 'package:school_app/models/class_section.dart';
import 'package:school_app/services/class_section_service.dart';
// import '../models/class_section.dart';
// import '../services/class_service.dart';


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

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await ClassService().fetchClassSections();
      setState(() {
        _classSections = classes;
        if (classes.isNotEmpty) {
          _selectedClass = classes.first;
        }
        _loadingClasses = false;
      });
      if (_selectedClass != null) {
        _loadSubjects(_selectedClass!.id);
      }
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
          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 10.0), // leave space for button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 Back
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: Text("< Back", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ),

                // 🔹 Title
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
const SizedBox(height: 10,)
                // 🔹 Class Dropdown
            ,    Padding(
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

                // 🔹 Subject List
               // 🔹 Subject List
Expanded(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      margin: const EdgeInsets.only(bottom: 20), // 👈 add 20px bottom space
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Color(0xFF999999), width: 0.3),
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

          // 🔹 Add button at top-right aligned with title
        Positioned(
  top: 50, // adjust to align with title row
  right: 16,
  child: ElevatedButton.icon(
    onPressed: () {
      // Add action
    },
    icon: const Icon(Icons.add, size: 20),
    label: const Text("Add a subject"),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF29ABE2),
      foregroundColor: Colors.white, // 👈 text and icon color
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
}
