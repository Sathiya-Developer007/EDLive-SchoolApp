import 'package:flutter/material.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

class TeacherResourcePage extends StatefulWidget {
  const TeacherResourcePage({super.key});

  @override
  State<TeacherResourcePage> createState() => _TeacherResourcePageState();
}

class _TeacherResourcePageState extends State<TeacherResourcePage> {
  String selectedClass = 'Class 10';
  String selectedSubject = 'All';

  final List<String> classes = [
    'Class 10',
    'Class 9',
    'Class 8',
    'Class 7',
    // add more classes as needed
  ];

  final List<String> subjects = [
    'All',
    'Math',
    'Science',
    'English',
    // add more subjects as needed
  ];

@override
Widget build(BuildContext context) {
  // Colors from screenshot
  const Color backgroundColor = Color(0xFFD3C4D6); // light purple background
  const Color headerTextColor = Color(0xFF2D3E9A); // dark blue text
  const Color linkColor = Color(0xFF1E3CA7); // blue links

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
            // Custom header row
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                    '<Back',
                    style: TextStyle(
                      color: Color(0xFF2D3E9A),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.folder_outlined,
                  color: Color(0xFF2D3E9A),
                  size: 28,
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

            const SizedBox(height: 24),

            // Single white container wrapping everything
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown selectors row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select Class', style: TextStyle(fontSize: 14)),
                              DropdownButton<String>(
                                value: selectedClass,
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: classes.map((cls) {
                                  return DropdownMenuItem(value: cls, child: Text(cls));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      selectedClass = val;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select Subject', style: TextStyle(fontSize: 14)),
                              DropdownButton<String>(
                                value: selectedSubject,
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: subjects.map((subj) {
                                  return DropdownMenuItem(value: subj, child: Text(subj));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      selectedSubject = val;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Add button row
                    Row(
                      children: [
                        Icon(Icons.add_circle_outline, color: linkColor, size: 20),
                        const SizedBox(width: 4),
                        Text('Add', style: TextStyle(fontSize: 14, color: linkColor)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Scrollable resource list inside Expanded
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Official Learning Links',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: headerTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),

                            _buildResourceItem(
                              title: 'CBSE Academic Portal',
                              description: 'Sample Papers, Marking Schemes',
                              linkText: 'www.cbse.gov.in',
                              onTap: () {},
                            ),
                            _buildResourceItem(
                              title: 'DIKSHA App',
                              description: 'NCERT books, Practice, Videos',
                              linkText: 'diksha.gov.in',
                              onTap: () {},
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'NCERT & Government Portals',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: headerTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),

                            _buildResourceItem(
                              title: 'NCERT Official',
                              description: 'Textbooks, Solutions, Exemplars',
                              linkText: 'ncert.nic.in',
                              onTap: () {},
                            ),
                            _buildResourceItem(
                              title: 'NDLI (National Digital Library)',
                              description: 'Millions of Educational Resources',
                              linkText: 'ndl.iitkgp.ac.in',
                              onTap: () {},
                            ),
                            _buildResourceItem(
                              title: 'ePathshala',
                              description: 'Free NCERT E-Books & Multimedia',
                              linkText: 'epathshala.nic.in',
                              onTap: () {},
                            ),
                          ],
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: linkColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    linkText,
                    style: const TextStyle(
                      fontSize: 13,
                      color: linkColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF1E3CA7),
            ),
          ],
        ),
      ),
    );
  }
}