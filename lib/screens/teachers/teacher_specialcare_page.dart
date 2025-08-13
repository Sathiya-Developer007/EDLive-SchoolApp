import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

class SpecialCarePage extends StatelessWidget {
  const SpecialCarePage({super.key});

  Widget  _buildCard(String iconPath, String title, String description) {
    return Container(
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
    color: Color(0xFF2E3192), // ✅ This is #2E3192
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9CCDB),
      appBar:TeacherAppBar(),
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
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Row(
              children: [
                
               Container(
  width: 36, // adjust size as needed
  height: 36,
  decoration: BoxDecoration(
    color: const Color(0xFF2E3192), // background color
    borderRadius: BorderRadius.circular(3), // optional rounded corners
  ),
  padding: const EdgeInsets.all(5), // optional padding inside container
  child: SvgPicture.asset(
    'assets/icons/special_care.svg',
    width: 25,
    height: 25,
    color: Colors.white, // icon color
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

            // Cards
            _buildCard(
              'assets/icons/book.svg',
              "Academic Support",
              "Remedial classes, study tips and homework help",
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
    );
  }
}
