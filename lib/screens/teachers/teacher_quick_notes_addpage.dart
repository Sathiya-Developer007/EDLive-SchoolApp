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
      backgroundColor: const Color(0xFFD3C4D6), // same purple bg
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + Title
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
                      'assets/icons/quick_notes.svg',
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Quick Notes",
                    style: TextStyle(
                      color: Color(0xFF2D3E9A),
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // White container (same style as Resources page)
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
                      // scrollable form
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
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<String>(
                  value: selectedClass,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ["10 A", "9 B", "8 C"].map((cls) {
                    return DropdownMenuItem(
                      value: cls,
                      child: Text(cls),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedClass = val);
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Student Name Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Student Name", style: TextStyle(fontSize: 14)),
            const SizedBox(width: 20),
            SizedBox(
              width: 200,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<String>(
                  value: selectedStudent,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ["All", "John", "Ananya", "Rahul"].map((stu) {
                    return DropdownMenuItem(
                      value: stu,
                      child: Text(stu),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedStudent = val);
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Quick Notes
        const Text("Quick Notes:", style: TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        TextField(
          controller: noteController,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 16),

        // Description
        const Text("Description:", style: TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        TextField(
          controller: descController,
          maxLines: 3,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 16),

        // Web Links
        const Text("Web Links:", style: TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        TextField(
          controller: linkController,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 16),
      ],
    ),
  ),
),


                      const SizedBox(height: 16),

                      // Buttons always at bottom
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
                                debugPrint("Added Quick Note: "
                                    "${noteController.text}, ${descController.text}, ${linkController.text}");
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
    );
  }
}
