import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'student_menu_drawer.dart';

class StudentSchoolBusPage extends StatelessWidget {
  const StudentSchoolBusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAD9FF),
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔙 Back and Title Row
         Padding(
  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Text(
          '< Back',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      const SizedBox(height: 12),
    Row(
  children: [
    Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF2E3192), // Background color for icon
        borderRadius: BorderRadius.circular(8),
      ),
      child: SvgPicture.asset(
        'assets/icons/transport.svg',
        height: 20,
        width: 20,
        color: Colors.white, // Make the icon white for contrast
      ),
    ),
    const SizedBox(width: 8),
    const Text(
      'School bus',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F227A),
      ),
    ),
  ],
),
 ],
  ),
),

            // 🚌 Bus Info Card
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Bus No.',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF1F227A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'KL 8 G 1214',
                          style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                            color: Color(0xFF1F227A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '7 : 45 am',
                          style: TextStyle(
                            fontSize: 14,
                           color: Color(0xFF0000FF),

                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '@',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Gandhi Street,T Nagar',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        const SizedBox(height: 24),
                        // const Divider(thickness: 1, color: Colors.grey),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text(
                              'Driver Mobile: ',
                              style: TextStyle(fontSize: 14, color: Color(0xFF4D4D4D),
),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                '+91 8056347856',
                                style: TextStyle(
                                  fontSize: 14,
                                 color: Color(0xFF0000FF),

                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            const Text(
                              'Transport Manager: ',
                              style: TextStyle(fontSize: 14,color: Color(0xFF4D4D4D),
),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                '+91 8056347856',
                                style: TextStyle(
                                  fontSize: 14,
                                 color: Color(0xFF0000FF),
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
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
}
