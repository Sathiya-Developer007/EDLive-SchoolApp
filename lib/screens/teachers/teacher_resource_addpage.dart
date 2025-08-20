import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'teacher_menu_drawer.dart';

class TeacherResourceAddPage extends StatefulWidget {
  const TeacherResourceAddPage({super.key});

  @override
  State<TeacherResourceAddPage> createState() => _TeacherResourceAddPageState();
}

class _TeacherResourceAddPageState extends State<TeacherResourceAddPage> {
  String selectedClass = '10 A';
  String selectedSubject = 'All';

  final List<String> classes = ['10 A', '9 A', '8 A', '7 A'];
  final List<String> subjects = ['All', 'Math', 'Science', 'English'];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFD3C4D6); // purple bg
    const Color headerTextColor = Color(0xFF2D3E9A); // dark blue

  return Scaffold(
  backgroundColor: backgroundColor,
  appBar: TeacherAppBar(),
  drawer: MenuDrawer(),
  body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              // Back + Title Row
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  "< Back",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E3192),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/resources.svg',
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Resources",
                    style: TextStyle(
                      color: headerTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // White container form
           Expanded(
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Scrollable form fields
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Class Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Class", style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 200,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButton<String>(
                          value: selectedClass,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: classes.map((cls) {
                            return DropdownMenuItem(
                              value: cls,
                              child: Text(cls),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => selectedClass = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Subject Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subject", style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 200,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButton<String>(
                          value: selectedSubject,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: subjects.map((subj) {
                            return DropdownMenuItem(
                              value: subj,
                              child: Text(subj),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => selectedSubject = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                const Text("Resource Title:", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                const Text("Description:", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                TextField(
                  controller: descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Links
                const Text("Web Links:", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                TextField(
                  controller: linkController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 🔹 Buttons always at bottom
        Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    "Remove",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  debugPrint("Added Resource: "
                      "${titleController.text}, ${descController.text}, ${linkController.text}");
                  Navigator.pop(context);
                },
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF29ABE2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
)
  ],
          ),
        ),
      ),
    );
  }
}
