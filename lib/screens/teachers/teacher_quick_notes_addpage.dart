import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

class AddQuickNotePage extends StatefulWidget {
  const AddQuickNotePage({super.key});

  @override
  State<AddQuickNotePage> createState() => _AddQuickNotePageState();
}

class _AddQuickNotePageState extends State<AddQuickNotePage> {
  String? selectedClass = "10 A";
  String? selectedStudent = "All";

  final TextEditingController noteController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
     body: SafeArea(
  child: Column(
    children: [
      // Top section (Back + Title)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                "< Back",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  color: const Color(0xFF2E3192),
                  child: SvgPicture.asset(
                    'assets/icons/quick_notes.svg',
                    height: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Quick notes",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E3192),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // White container that expands + scrolls internally
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(bottom: 20,right: 20,left:10), // 20px gap at bottom
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Class"),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: selectedClass,
                  decoration: _inputDecoration(),
                  items: ["10 A", "9 B", "8 C"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setState(() => selectedClass = val);
                  },
                ),
                const SizedBox(height: 16),

                const Text("Student Name"),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: selectedStudent,
                  decoration: _inputDecoration(),
                  items: ["All", "John", "Ananya", "Rahul"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setState(() => selectedStudent = val);
                  },
                ),
                const SizedBox(height: 16),

                const Text("Quick Notes:"),
                const SizedBox(height: 4),
                TextField(
                  controller: noteController,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 16),

                const Text("Description:"),
                const SizedBox(height: 4),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 16),

                const Text("Web Links:"),
                const SizedBox(height: 4),
                TextField(
                  controller: linkController,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Remove",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF29ABE2),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Add",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16),
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
    ],
  ),
),
 );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.black26),
      ),
    );
  }
}
