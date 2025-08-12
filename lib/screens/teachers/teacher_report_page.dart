import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

final ValueNotifier<String> selectedTerm = ValueNotifier<String>("Final");

class TeacherReportPage extends StatefulWidget {
  const TeacherReportPage({super.key});

  @override
  State<TeacherReportPage> createState() => _TeacherReportPageState();
}

class _TeacherReportPageState extends State<TeacherReportPage> {
  Map<String, Map<String, String>> marks = {
    "John Doe": {
      "Mathematics": "",
      "Science": "",
      "English": "",
      "History": "",
      "Tamil": "",
    },
    "Jane Smith": {
      "Mathematics": "",
      "Science": "",
      "English": "",
      "History": "",
      "Tamil": "",
    },
    "Alice Johnson": {
      "Mathematics": "",
      "Science": "",
      "English": "",
      "History": "",
      "Tamil": "",
    },
  };

  void _openMarkEntrySheet(String student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: MarkEntryForm(
            student: student,
            subjectsMarks: marks[student]!,
            onSave: (updatedMarks) {
              setState(() {
                marks[student] = updatedMarks;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Marks saved for $student")),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: Container(
        color: const Color(0xFFFDCFD0), // pink background
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back, size: 20, color: Colors.black),
                  SizedBox(width: 6),
                  Text("< Back", style: TextStyle(color: Colors.black, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E3192),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/reports.svg",
                    height: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Class Report",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              "Class Performance Summary",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF2E3192),
              ),
            ),
            const SizedBox(height: 24),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _ReportStat(title: "Class", value: "10 A"),
                _ReportStat(title: "Average Score", value: "78%"),
                _ReportStat(title: "Top Student", value: "John D."),
              ],
            ),

            const SizedBox(height: 30),

            // Term selector with modern dropdown style
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Term:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: selectedTerm,
                  builder: (context, value, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF4D4D4D)),
                        color: Colors.white,
                      ),
                      child: DropdownButton<String>(
                        value: value,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: "Final", child: Text("Final")),
                          DropdownMenuItem(value: "Mid", child: Text("Mid")),
                        ],
                        onChanged: (newVal) {
                          if (newVal != null) selectedTerm.value = newVal;
                        },
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4D4D4D),
                        ),
                        icon: const Icon(Icons.arrow_drop_down, size: 28),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Students list as cards
            Expanded(
              child: ListView.builder(
                itemCount: marks.length,
                itemBuilder: (context, index) {
                  final student = marks.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () => _openMarkEntrySheet(student),
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFF2E3192),
                              child: Text(
                                student.split(" ").map((e) => e[0]).take(2).join(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                student,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(Icons.edit, color: Color(0xFF2E3192)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for marks entry form inside bottom sheet
class MarkEntryForm extends StatefulWidget {
  final String student;
  final Map<String, String> subjectsMarks;
  final void Function(Map<String, String>) onSave;

  const MarkEntryForm({
    required this.student,
    required this.subjectsMarks,
    required this.onSave,
    super.key,
  });

  @override
  State<MarkEntryForm> createState() => _MarkEntryFormState();
}

class _MarkEntryFormState extends State<MarkEntryForm> {
  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = {
      for (var e in widget.subjectsMarks.entries)
        e.key: TextEditingController(text: e.value),
    };
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final updatedMarks = {
      for (var entry in controllers.entries) entry.key: entry.value.text.trim(),
    };
    widget.onSave(updatedMarks);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Marks for ${widget.student}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF2E3192),
            ),
          ),
          const SizedBox(height: 20),
          ...controllers.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: entry.key,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            );
          }),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E3192),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Save Marks",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ReportStat extends StatelessWidget {
  final String title;
  final String value;

  const _ReportStat({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF2E3192),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
