import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

class StudentSyllabusPage extends StatelessWidget {
  const StudentSyllabusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: const Color(0xFF91C1BC),
      drawer: StudentMenuDrawer(),
      appBar: StudentAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // Back and Syllabus Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                 GestureDetector(
  onTap: () {
    Navigator.pop(context); // ⬅️ Go back to previous screen
  },
  child: const Text(
    '< Back',
    style: TextStyle(fontSize: 14, color: Colors.black),
  ),
),

                  SizedBox(height: 4),
                Row(
  children: [
    // SVG Icon with background
   Container(
  width: 35,
  height: 35,
  padding: const EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: const Color(0xFF2E3192),
    borderRadius: BorderRadius.circular(5), // Rounded corners with radius 2
  ),
  child: SvgPicture.asset(
    'assets/icons/syllabus.svg',
    color: Colors.white,
  ),
),
  const SizedBox(width: 12),
    
    // Title Text
    const Text(
      'Syllabus',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E3192), // Updated text color
      ),
    ),
  ],
),

                ],
              ),
            ),

            // Syllabus Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'ICSE, Class 10\nYear 2018 - 19',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF2A2AC0),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Last updated on 1, January 2019',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                 ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2BB5E4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    minimumSize: const Size(120, 40), // width, height
  ),
  onPressed: () {
    // TODO: handle syllabus view
  },
  child: const Text(
    'View',
    style: TextStyle(color: Colors.white),
  ),
),
   ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
