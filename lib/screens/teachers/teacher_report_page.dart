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
  String? selectedStudent;
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

  final TextEditingController searchController = TextEditingController();

  List<String> get filteredStudents {
    if (searchController.text.isEmpty) {
      return marks.keys.toList();
    }
    return marks.keys
        .where((s) =>
            s.toLowerCase().contains(searchController.text.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: Container(
        color: const Color(0xFFFDCFD0),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header + Term dropdown
          Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Title row (icon + title)
  // Back button + title row
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Back Button Row
    GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        children: const [
          // Icon(Icons.arrow_back, color: Color(0xFF2E3192), size: 24),
          SizedBox(width: 4),
          Text(
            "< Back",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
    const SizedBox(height: 12),

    // Icon + Title Row
    Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2E3192),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            "assets/icons/reports.svg",
            height: 36,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          "Teacher Report",
          style: TextStyle(
            color: Color(0xFF2E3192),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ],
)
,
    const SizedBox(height: 16),

    // Bottom row with total class marks on left and term dropdown on right
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Total Class Avg % Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Total Class Avg %",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "78%",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3192),
                ),
              ),
            ],
          ),
        ),

        // Term Dropdown on right
        ValueListenableBuilder<String>(
          valueListenable: selectedTerm,
          builder: (context, value, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButton<String>(
                value: value,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, size: 28),
                items: const [
                  DropdownMenuItem(value: "Final", child: Text("Final")),
                  DropdownMenuItem(value: "Mid", child: Text("Mid")),
                ],
                onChanged: (newVal) {
                  if (newVal != null) selectedTerm.value = newVal;
                },
                style: const TextStyle(
                  color: Color(0xFF4D4D4D),
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
      ],
    ),
  ],
),

            const SizedBox(height: 24),

            Expanded(
              child: isWide
                  ? Row(
                      children: [
                        // Left: Student list with search
                        SizedBox(
                          width: 300,
                          child: Column(
                            children: [
                              TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: "Search students",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 12),
                              
                              Expanded(
                                child: ListView.builder(
                                  itemCount: filteredStudents.length,
                                  itemBuilder: (context, index) {
                                    final student = filteredStudents[index];
                                    final isSelected = student == selectedStudent;
                                    return Card(
                                      color: isSelected
                                          ? const Color(0xFFEAEAEA)
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: isSelected
                                              ? const Color(0xFF2E3192)
                                              : Colors.grey.shade300,
                                          width: isSelected ? 2 : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin:
                                          const EdgeInsets.symmetric(vertical: 6),
                                      child: ListTile(
                                        title: Text(
                                          student,
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? const Color(0xFF2E3192)
                                                : Colors.black87,
                                          ),
                                        ),
                                        trailing: isSelected
                                            ? const Icon(Icons.edit,
                                                color: Color(0xFF2E3192))
                                            : null,
                                        onTap: () {
                                          setState(() {
                                            selectedStudent = student;
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        // Right: Mark entry form
                        Expanded(
                          child: selectedStudent == null
                              ? Center(
                                  child: Text(
                                    "Select a student to enter marks",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                )
                              : MarkEntryCard(
                                  student: selectedStudent!,
                                  subjectsMarks: marks[selectedStudent!]!,
                                  onSave: (updatedMarks) {
                                    setState(() {
                                      marks[selectedStudent!] = updatedMarks;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Marks saved for $selectedStudent")),
                                    );
                                  },
                                ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        // On narrow screens, stacked layout:
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: "Search students",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (val) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredStudents.length,
                            itemBuilder: (context, index) {
                              final student = filteredStudents[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text(student),
                                  trailing: const Icon(Icons.edit, color: Color(0xFF2E3192)),
                                  onTap: () {
                                    setState(() {
                                      selectedStudent = student;
                                    });
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (_) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                          left: 16,
                                          right: 16,
                                          top: 16,
                                        ),
                                        child: MarkEntryCard(
                                          student: student,
                                          subjectsMarks: marks[student]!,
                                          onSave: (updatedMarks) {
                                            setState(() {
                                              marks[student] = updatedMarks;
                                            });
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Marks saved for $student")),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarkEntryCard extends StatefulWidget {
  final String student;
  final Map<String, String> subjectsMarks;
  final void Function(Map<String, String>) onSave;

  const MarkEntryCard({
    required this.student,
    required this.subjectsMarks,
    required this.onSave,
    super.key,
  });

  @override
  State<MarkEntryCard> createState() => _MarkEntryCardState();
}

class _MarkEntryCardState extends State<MarkEntryCard> {
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
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 20, top: 10, left: 4, right: 4),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Marks for ${widget.student}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xFF2E3192),
                  ),
                ),
                const SizedBox(height: 24),
                ...controllers.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        labelText: entry.key,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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
                      backgroundColor:  Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Save Marks",
                      style: TextStyle(fontSize: 18,  color: Color(0xFF2E3192),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
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
