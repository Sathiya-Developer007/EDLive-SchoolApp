import 'package:flutter/material.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'teacher_menu_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'teacher_exam_announce_class_test_page.dart';

import 'package:school_app/models/class_section.dart';
import 'package:school_app/models/teacher_exam_model.dart';
import 'package:school_app/services/teacher_exam_service.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TeacherExamPage extends StatefulWidget {
  const TeacherExamPage({super.key});

  @override
  State<TeacherExamPage> createState() => _TeacherExamPageState();
}

class _TeacherExamPageState extends State<TeacherExamPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<ClassSection> classList = [];
  ClassSection? selectedClass;
  bool isLoading = true;

  List<TeacherExam> exams = [];
  bool isExamLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchClasses();
  }

  Future<void> fetchExamsForClass(String classId) async {
    setState(() => isExamLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final url = Uri.parse(
        'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/exams/teacher/$classId',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List data = body['data'];
        exams = data.map((e) => TeacherExam.fromJson(e)).toList();
      } else {
        exams = [];
      }
    } catch (e) {
      exams = [];
    }

    setState(() => isExamLoading = false);
  }

  Future<void> fetchClasses() async {
    final url = Uri.parse(
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/master/classes',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          classList = data.map((json) => ClassSection.fromJson(json)).toList();
          selectedClass = classList.isNotEmpty ? classList[0] : null;
          if (selectedClass != null) {
            fetchExamsForClass(selectedClass!.id.toString());
          }

          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        // Handle error
      }
    } catch (e) {
      setState(() => isLoading = false);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAAE5C8),
      drawer: const MenuDrawer(),
      appBar: TeacherAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button + Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    '< Back',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E3192),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/exams.svg',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Exams',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3192),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // White Content Box
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Class Dropdown Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            const Text(
                              'Select your class',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 100,
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCCCCCC),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : DropdownButton<ClassSection>(
                                      value: selectedClass,
                                      isExpanded: false,
                                      underline: const SizedBox(),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      dropdownColor: Colors.white,
                                      onChanged: (value) async {
                                        if (value != null) {
                                          setState(() => selectedClass = value);
                                          fetchExamsForClass(
                                            value.id.toString(),
                                          );

                                          // ✅ Store selected classId in SharedPreferences
                                          final prefs =
                                              await SharedPreferences.getInstance();
                                          await prefs.setString(
                                            'classId',
                                            value.id.toString(),
                                          );
                                        }
                                      },

                                      items: classList.map((cls) {
                                        return DropdownMenuItem(
                                          value: cls,
                                          child: Text(
                                            cls.fullName,
                                            style: const TextStyle(
                                              color: Color(0xFF29ABE2),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Tabs
                      TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.blue,
                        labelColor: Colors.black,
                        tabs: const [
                          Tab(text: 'Class tests'),
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Other Exams'),
                                SizedBox(width: 4),
                                CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.purple,
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // TabBarView
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildClassTestsTab(),
                            const Center(
                              child: Text('Other Exams Coming Soon'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassTestsTab() {
    if (isExamLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          Center(
            child: SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnnounceClassTestPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Announce a class test',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...exams.map((exam) {
            return Column(
              children: [
                _buildTestSection(
                  title: exam.examType,
                  dateTime: exam.examDate.split('T').first,
                  subject: exam.subject,
                  description: exam.description,
                ),
                const Divider(color: Color(0xFFB3B3B3), thickness: 1),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTestSection({
    required String title,
    String? dateTime,
    required String subject,
    required String description,
    bool showTitle = true, // ✅ optional flag, default is true
  }) {
    {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 12,
              right: 12,
              bottom: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showTitle)
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF29ABE2),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                if (dateTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      dateTime,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  subject,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    description,
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),

          // ✅ Pencil Icon top right
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/pencil.svg',
                height: 20,
                width: 20,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnnounceClassTestPage(),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}
