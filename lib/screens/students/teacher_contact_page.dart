import 'package:flutter/material.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

class TeacherContactPage extends StatelessWidget {
  final String name;
  final String subject;
  final String phone;
  final String email;

  const TeacherContactPage({
    super.key,
    required this.name,
    required this.subject,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD596), // light orange
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 0, 0),
           
               child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate back
              },
              child: const Row(
                children: [
                  SizedBox(width: 5),
                  Text("< Back", style: TextStyle(fontSize: 14)),
                ],
              ),
          ),),
            Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
  color: const Color(0xFF2E3192),
  borderRadius: BorderRadius.circular(2), // 2px radius
),

                  child: const Icon(Icons.group, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Teachers",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
              ],
            ),
          ), const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
             margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(subject,
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 20),
               Center(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Call: "),
          GestureDetector(
            onTap: () {
              // launch phone call
            },
            child: Text(
              phone,
              style: const TextStyle(
                color: Color(0xFF29ABE2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("WhatsApp: "),
          GestureDetector(
            onTap: () {
              // launch WhatsApp
            },
            child: Text(
              phone,
              style: const TextStyle(
                color: Color(0xFF29ABE2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("email: "),
          GestureDetector(
            onTap: () {
              // launch email
            },
            child: Text(
              email,
              style: const TextStyle(
                color: Color(0xFF29ABE2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
    );
  }
}
