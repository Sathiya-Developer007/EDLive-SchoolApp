import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:school_app/widgets/teacher_app_bar.dart';
import 'teacher_menu_drawer.dart';


class SyllabusDetailPage extends StatelessWidget {
  final String selectedClass;
  final String subject;

  const SyllabusDetailPage({
    super.key,
    required this.selectedClass,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7D7A7),
     appBar: TeacherAppBar(),
drawer: MenuDrawer(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // < Back button
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "< Back",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Syllabus Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        height: 24,
                        width: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Syllabus',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3192),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // White Container with subject & class info
              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: SizedBox(
    height: MediaQuery.of(context).size.height * 0.65, // adjust percentage as needed
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Class > Subject Row
                      Row(
                        children: [
                          Text(
                            'Class $selectedClass > ',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            subject,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.more_vert),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Add + Pencil Row
                   Container(
  padding: const EdgeInsets.only(bottom: 8), // optional spacing below content
  decoration: const BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Color(0xFF999999), // or any color you prefer
        width: 0.5, // thin border
      ),
    ),
  ),
  child: Row(
    children: [
      const Icon(Icons.add_circle_outline, color: Color(0xFF29ABE2)),
      const SizedBox(width: 4),
      const Text(
        'Add',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF29ABE2),
          fontWeight: FontWeight.w500,
        ),
      ),
      const Spacer(),
      SvgPicture.asset(
        'assets/icons/pencil.svg',
        height: 18,
        width: 18,
        color: Colors.black,
      ),
    ],
  ),
),

                      const SizedBox(height: 16),

                      // Semester 1 Section
                      const Text(
                        'Semester/Term 1',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF2E3192),
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '30, Aug 2019',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
const Padding(
  padding: EdgeInsets.all( 8.0), // or use all(), only(), etc.
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('1. Lesson name'),
      SizedBox(height: 4),
      Text('2. Lesson name two goes here'),
      SizedBox(height: 4),
      Text('3. Topic name three goes here'),
    ],
  ),
),

                      const Divider(height: 30),

                      // Semester 2 Section
                      const Text(
                        'Semester/Term 2',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF2E3192),
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                        const Text(
                        '30, Aug 2019',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    const SizedBox(height: 8),
const Padding(
  padding: EdgeInsets.all(8.0), // or use all(), only(), etc.
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('1. Lesson name'),
      SizedBox(height: 4),
      Text('2. Lesson name two goes here'),
      SizedBox(height: 4),
      Text('3. Topic name three goes here'),
    ],
  ),
),


                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // const SizedBox(height: 40),
           ), ],
          ),
        ),
      ),
    );
  }
}
