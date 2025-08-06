import 'package:flutter/material.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'student_menu_drawer.dart';
import 'teacher_contact_page.dart';

class StudentTeacherPage extends StatelessWidget {
  const StudentTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD596), // Light orange background
      appBar: StudentAppBar(),
      drawer: const StudentMenuDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
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
            ),
          ),
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
          ),
        Expanded(
  child: Container(
    margin: const EdgeInsets.fromLTRB(16, 20, 16, 35), // Decreased top and bottom

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Tap to get contact details",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ),
                  Divider(height: 1),
                  Expanded(child: TeacherListView()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherListView extends StatelessWidget {
  const TeacherListView({super.key});

  @override
  Widget build(BuildContext context) {
    final teachers = [
      {
        "name": "Aravid K",
        "subject": "Class teacher",
        "phone": "91 9876543210",
        "email": "aravid@example.com"
      },
      {
        "name": "Abdul Rahman",
        "subject": "English",
        "phone": "91 8765432109",
        "email": "abdul@example.com"
      },
      {
        "name": "Reena K",
        "subject": "English",
        "phone": "91 7654321098",
        "email": "reena@example.com"
      },
      {
        "name": "Saji Varghese",
        "subject": "Social science",
        "phone": "91 9934567899",
        "email": "saji@gmail.com"
      },
      {
        "name": "Mujeesh V S",
        "subject": "Maths",
        "phone": "91 9123456789",
        "email": "mujeesh@example.com"
      },
    ];

    return ListView.builder(
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        final teacher = teachers[index];
        final isLast = index == teachers.length - 1;

        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: TeacherTile(
            name: teacher['name']!,
            subject: teacher['subject']!,
            phone: teacher['phone']!,
            email: teacher['email']!,
          ),
        );
      },
    );
  }
}

class TeacherTile extends StatelessWidget {
  final String name;
  final String subject;
  final String phone;
  final String email;

  const TeacherTile({
    super.key,
    required this.name,
    required this.subject,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subject),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherContactPage(
              name: name,
              subject: subject,
              phone: phone,
              email: email,
            ),
          ),
        );
      },
    );
  }
}
