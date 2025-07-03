import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'student_menu_drawer.dart';
import 'student_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class SelectChildPage extends StatelessWidget {
  final Map<String, dynamic> studentData;
  const SelectChildPage({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> children = [
      {
        'name': studentData['name'] ?? 'Student',
        'id': studentData['id']?.toString() ?? '',
        'class': studentData['class'] ?? '',
        'image': 'assets/images/child1.jpg',
        'notification': 4,
      },
      {
        'name': 'Child Name 2',
        'id': '5678',
        'class': '5 A',
        'image': 'assets/images/child2.jpeg',
        'notification': 0,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      drawer: const StudentMenuDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            for (var child in children)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: GestureDetector(
            onTap: () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('selected_child', jsonEncode(child)); // Save selected child

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StudentDashboardPage(childData: child),
    ),
  );
},

                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                ClipOval(
                                  child: child['image'] != null &&
                                          child['image'].toString().isNotEmpty
                                      ? Image.asset(
                                          child['image'],
                                          width: 160,
                                          height: 160,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: 160,
                                              height: 160,
                                              color: Colors.grey.shade300,
                                              child: const Icon(Icons.person,
                                                  size: 50,
                                                  color: Colors.white),
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 160,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.person,
                                              size: 50, color: Colors.white),
                                        ),
                                ),
                                if (child['notification'] > 0)
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Colors.purple,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        child['notification'].toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              child['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E266D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID No. ${child['id']}   |   Class: ${child['class']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
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
