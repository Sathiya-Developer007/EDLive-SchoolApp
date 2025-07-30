import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'student_menu_drawer.dart';

class StudentExamsScreen extends StatelessWidget {
  final List<Map<String, String>> examList = [
    {
      'title': 'Class test',
      'dateTime': '30, Jan 2019, 2.30 pm',
      'subject': 'Biology',
    },
    {
      'title': 'Class test',
      'dateTime': '2, Feb 2019, 1.00 pm',
      'subject': 'Science',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xFFFCDBB1), // ✅ new (as per your request)
      drawer: StudentMenuDrawer(),
      appBar: StudentAppBar(),
     body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back Button Text
              GestureDetector(
                onTap: () => Navigator.pop(context),
                
                child: const Text(
                  '< Back',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 📘 Title with Icon and Background
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFF2E3192), // Icon background
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/exams.svg',
                      height: 20,
                      width: 20,
                      color: Colors.white, // optional: makes icon white
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Exams',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3192), // Title color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 🧾 Exam Cards
              Expanded(
                child: ListView.builder(
                  itemCount: examList.length,
                  itemBuilder: (context, index) {
                    final exam = examList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              exam['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2E3192),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            exam['dateTime'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            exam['subject'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2E3192),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}  
