import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

void main() {
  runApp(const MaterialApp(home: CoCurricularActivitiesPage()));
}

class CoCurricularActivitiesPage extends StatelessWidget {
  const CoCurricularActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
  appBar: TeacherAppBar(),
  drawer: MenuDrawer(),
  body: Container(
    width: double.infinity,
    height: double.infinity,
    color: const Color(0xFFDBD88A),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header (Back + Add + Icon + Title)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      '< Back',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFF29ABE2)),
                    label: const Text(
                      'Add',
                      style: TextStyle(color: Color(0xFF29ABE2), fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3192),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/co_curricular.svg',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Co curricular activities',
                    style: TextStyle(
                      color: Color(0xFF2E3192),
                      fontWeight: FontWeight.bold,
                      fontSize: 29,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Scrollable white container
      Expanded(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20), // 20px bottom outside white container
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Academic Clubs & Competitions', [
              'Science Club',
              'Mathematics Club',
              'Quiz Competitions',
              'Debate Club',
              'Spelling Bee',
              'Coding & Robotics Club',
            ]),
            const SizedBox(height: 16),
            _buildSection('Sports & Physical Activities', [
              'Cricket',
              'Football',
              'Basketball',
              'Athletics (Track & Field)',
              'Badminton',
              'Table Tennis',
              'Yoga',
              'Chess',
            ]),
            const SizedBox(height: 16),
            _buildSection('Arts & Creative Activities', [
              'Music (Vocal & Instrumental)',
              'Dance (Classical, Contemporary)',
              'Drama & Theatre',
              'Painting & Sketching',
              'Photography Club',
              'Craft & Sculpture',
            ]),
          ],
        ),
      ),
    ),
  ),
),
 ],
    ),
  ),
);

  }

Widget _buildSection(String title, List<String> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 5),
      for (var item in items) _buildListItem(item),
    ],
  );
}

Widget _buildListItem(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2E3192),
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFF2E3192),
            decorationThickness: 1.5,
          ),
        ),
        const Icon(Icons.chevron_right, size: 27),
      ],
    ),
  );
}
}
