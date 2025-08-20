import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

import 'teacher_resource_addpage.dart';

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Go back
                    },
                    child:// Back + Add Row
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    GestureDetector(
      onTap: () {
        Navigator.pop(context); // Go back
      },
      child: const Text(
        '< Back',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    ),

    // + Add Button
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TeacherResourceAddPage(), // 👈 open Add page
          ),
        );
      },
      child: Row(
        children: const [
          Icon(Icons.add_circle_outline, color: Color(0xFF29ABE2)),
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
 ),
                  const SizedBox(height: 6), // Space between Back and title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(
                          6,
                        ), // spacing inside background
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E3192), // background color
                          // shape: BoxShape.circle, // make it rounded
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/resources.svg', // change to your resource icon path
                          height: 20,
                          width: 20,
                          color: Colors.white, // icon color
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

              // Single white container wrapping everything
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
                      // Dropdown selectors row
                    Row(
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Class',
            style: TextStyle(fontSize: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 40, // 🔹 reduced height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButton<String>(
              value: selectedClass,
              isExpanded: true,
              underline: const SizedBox(),
              items: classes.map((cls) {
                return DropdownMenuItem(
                  value: cls,
                  child: Text(cls, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedClass = val;
                  });
                }
              },
            ),
          ),
        ],
      ),
    ),
    const SizedBox(width: 32),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Subject',
            style: TextStyle(fontSize: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 40, // 🔹 reduced height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButton<String>(
              value: selectedSubject,
              isExpanded: true,
              underline: const SizedBox(),
              items: subjects.map((subj) {
                return DropdownMenuItem(
                  value: subj,
                  child: Text(subj, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedSubject = val;
                  });
                }
              },
            ),
          ),
        ],
      ),
    ),
  ],
)
,
                      const SizedBox(height: 8),

                      // Add button row
               GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TeacherResourceAddPage(), // 👈 open Add page
      ),
    );
  },
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey, width: 0.2), // ✅ Bottom border
      ),
    ),
    // child: Row(
    //   children: const [
    //     Icon(Icons.add_circle_outline, color: Color(0xFF29ABE2)),
    //     SizedBox(width: 8),
    //     Text(
    //       "Add",
    //       style: TextStyle(
    //         color: Color(0xFF29ABE2),
    //         fontSize: 15,
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //   ],
    // ),
  ),
)
,

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
      color: Color(0xFF2E3192),
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

  const Divider(
    color: Color(0xFFCCCCCC), // light grey line
    thickness: 1,
    height: 30, // spacing before and after line
  ),

  const Text(
    'NCERT & Government Portals',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2E3192),
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

  const Divider(
    color: Color(0xFFCCCCCC),
    thickness: 1,
    height: 30,
  ),
]
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
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(
          // bottom: BorderSide(color: Colors.grey, width: 0.5), // bottom line
        ),
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
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    // decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color:Color(0xFF808080)),
                ),
                Text(
                  linkText,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF2E3192),
                  decoration:TextDecoration.underline,decorationColor:Color(0xFF2E3192)),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black,
          ),
        ],
      ),
    ),
  );
}
}
