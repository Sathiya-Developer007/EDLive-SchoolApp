import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SpecialCarePage(),
    );
  }
}

// ---------------- SpecialCarePage ----------------
class SpecialCarePage extends StatelessWidget {
  const SpecialCarePage({super.key});

  Widget _buildCard(
    String iconPath,
    String title,
    String description, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 28,
              height: 28,
              color: const Color(0xFF2E3192),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF2E3192),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.3,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9CCDB),
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: const [
                  SizedBox(width: 4),
                  Text(
                    "< Back",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Title Row with icon
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3192),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: SvgPicture.asset(
                    'assets/icons/special_care.svg',
                    width: 25,
                    height: 25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Special Care",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Scrollable list of cards, each its own white container
            Expanded(
              child: ListView(
                children: [
                  _buildCard(
                    'assets/icons/book.svg',
                    "Academic Support",
                    "Remedial classes, study tips and homework help",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AcademicSupportPage(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    'assets/icons/head.svg',
                    "Emotional & Mental Wellbeing",
                    "Counselling services, stress management tips, and bullying support",
                  ),
                  _buildCard(
                    'assets/icons/health.svg',
                    "Health & Safety",
                    "Medical support, special dietary plans, and emergency contacts",
                  ),
                  _buildCard(
                    'assets/icons/inclusive.svg',
                    "Inclusive Learning",
                    "Learning disabilities support, assistive technology, and special education resources",
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

// ---------------- AcademicSupportPage ----------------
class AcademicSupportPage extends StatefulWidget {
  const AcademicSupportPage({super.key});

  @override
  State<AcademicSupportPage> createState() => _AcademicSupportPageState();
}

class _AcademicSupportPageState extends State<AcademicSupportPage> {
  String? selectedClass = 'Class 10';
  String? selectedSubject = 'All';
  String? selectedHomeworkSubject = 'Tamil';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9CCDB),
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Class & Subject Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Class',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              value: selectedClass,
                              isExpanded: true,
                              underline: const SizedBox(),
                              icon: const Icon(Icons.arrow_drop_down),
                              items: <String>[
                                'Class 10',
                                'Class 9',
                                'Class 8',
                                'Class 7'
                              ]
                                  .map((value) => DropdownMenuItem(
                                      value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedClass = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Subject',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              value: selectedSubject,
                              isExpanded: true,
                              underline: const SizedBox(),
                              icon: const Icon(Icons.arrow_drop_down),
                              items: <String>[
                                'All',
                                'Math',
                                'Science',
                                'English'
                              ]
                                  .map((value) => DropdownMenuItem(
                                      value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSubject = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Remedial Class Timetable
                const Text(
                  'Remedial Class Timetable',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
                const SizedBox(height: 16),
                Table(
                  border: TableBorder.all(color: Colors.grey, width: 1.0),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  children: const [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Subject',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Day',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Time',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(padding: EdgeInsets.all(10), child: Text('Math')),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Mon/Wed'),
                        ),
                        Padding(padding: EdgeInsets.all(10), child: Text('4-5 PM')),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Science'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Tue/Thu'),
                        ),
                        Padding(padding: EdgeInsets.all(10), child: Text('4-5 PM')),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('English'),
                        ),
                        Padding(padding: EdgeInsets.all(10), child: Text('Fri')),
                        Padding(padding: EdgeInsets.all(10), child: Text('4-5 PM')),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Homework Section (updated)
                const Text(
                  'Home Work',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
                const SizedBox(height: 16),

                // Subject Row for Homework
                Row(
                  children: [
                    const Text(
                      'Subject:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: DropdownButton<String>(
                          value: selectedHomeworkSubject,
                          isExpanded: true,
                          underline: const SizedBox(),
                          icon: const Icon(Icons.arrow_drop_down),
                          items: <String>['Tamil', 'English', 'Math', 'Science']
                              .map((value) => DropdownMenuItem(
                                  value: value, child: Text(value)))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedHomeworkSubject = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // Upload Files
                Row(
                  children: [
                    const Text('Upload Files:', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: handle file upload
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                        elevation: 0,
                      ),
                      child: const Text('Choose File'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Text('Notes:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
