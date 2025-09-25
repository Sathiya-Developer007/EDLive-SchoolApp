import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import '../../models/teacher_special_care_model.dart';
import '../../services/teacher_special_care_service.dart';
import '../../models/teacher_special_care_item.dart';
import '../../services/teacher_special_care_item_service.dart';
import '/models/teacher_class_student.dart';
import 'package:school_app/services/teacher_class_student_list.dart';

/// ---------------- SpecialCarePage ----------------
class SpecialCarePage extends StatefulWidget {
  const SpecialCarePage({super.key});

  @override
  State<SpecialCarePage> createState() => _SpecialCarePageState();
}

class _SpecialCarePageState extends State<SpecialCarePage> {
  late Future<List<SpecialCareCategory>> _futureCategories;
  final SpecialCareService _service = SpecialCareService();

  @override
  void initState() {
    super.initState();
    _futureCategories = _service.fetchCategories();
  }

  String _getIconPath(String categoryName) {
    switch (categoryName) {
      case "Academic Support":
        return 'assets/icons/book.svg';
      case "Emotional & Mental Wellbeing":
        return 'assets/icons/head.svg';
      case "Health & Safety":
        return 'assets/icons/health.svg';
      case "Inclusive Learning":
        return 'assets/icons/inclusive.svg';
      default:
        return 'assets/icons/book.svg';
    }
  }

  Widget _buildCard(SpecialCareCategory category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryDetailPage(category: category),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              _getIconPath(category.name),
              width: 28,
              height: 28,
              color: const Color(0xFF2E3192),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      color: Color(0xFF2E3192),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.3,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9CCDB),
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text("< Back",
                  style: TextStyle(color: Colors.black, fontSize: 14)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3192),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: SvgPicture.asset(
                    'assets/icons/special_care.svg',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Special Care",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<SpecialCareCategory>>(
                future: _futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("Error: ${snapshot.error.toString()}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No categories found"));
                  }

                  final categories = snapshot.data!;
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildCard(category);
                    },
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

/// ---------------- Category Detail Page ----------------
class CategoryDetailPage extends StatefulWidget {
  final SpecialCareCategory category;
  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  final TextEditingController notesController = TextEditingController();
  final SpecialCareItemService _service = SpecialCareItemService();

  List<Student> allStudents = [];
  List<Student> selectedStudents = [];
  bool isLoadingStudents = true;

  Map<String, List<String>> _selectedDays = {};
  Map<String, TimeOfDay> _startTimes = {};
  Map<String, TimeOfDay> _endTimes = {};

  @override
  void initState() {
    super.initState();
    _loadStudents();

    for (var subject in ['Math', 'Science', 'English']) {
      _startTimes[subject] = const TimeOfDay(hour: 16, minute: 0);
      _endTimes[subject] = const TimeOfDay(hour: 17, minute: 0);
      _selectedDays[subject] = [];
    }
  }

  Future<void> _loadStudents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final students = await StudentService.fetchStudents(token);
      if (!mounted) return;
      setState(() {
        allStudents = students;
        isLoadingStudents = false;
      });
    } catch (e) {
      setState(() => isLoadingStudents = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load students: $e")),
      );
    }
  }

  void _showMultiSelectStudents() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(12),
          child: ListView(
            children: allStudents.map((student) {
              final isSelected = selectedStudents.contains(student);
              return CheckboxListTile(
                title: Text(student.studentName),
                value: isSelected,
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected == true) {
                      selectedStudents.add(student);
                    } else {
                      selectedStudents.remove(student);
                    }
                  });
                  Navigator.pop(context);
                  _showMultiSelectStudents(); // reopen modal to reflect changes
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _submitSpecialCare() async {
    if (selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one student.")),
      );
      return;
    }

    try {
      final daysList = _selectedDays.values.expand((e) => e).toList();
      final timeString = _startTimes.keys.map((subject) {
        final start = _startTimes[subject]!;
        final end = _endTimes[subject]!;
        return "${start.format(context)} - ${end.format(context)}";
      }).join(", ");

      String careType;
      switch (widget.category.name.trim()) {
        case "Academic Support":
          careType = "academic";
          break;
        case "Emotional & Mental Wellbeing":
          careType = "emotional";
          break;
        case "Health & Safety":
          careType = "health";
          break;
        case "Inclusive Learning":
          careType = "inclusive";
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid category: ${widget.category.name}")),
          );
          return;
      }

      final item = SpecialCareItem(
        studentIds: selectedStudents.map((s) => s.id).toList(),
        categoryId: widget.category.id,
        title: widget.category.name,
        description: notesController.text.isEmpty
            ? "No description"
            : notesController.text,
        careType: careType,
        days: daysList,
        time: timeString,
        materials: ["workbook.pdf"],
        tools: ["calculator"],
        assignedTo: 5,
        status: "active",
        startDate: "2023-09-01",
        endDate: "2023-12-15",
        visibility: "class",
      );

      final createdItem = await _service.createSpecialCareItem(item);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Created: ${createdItem.title}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9CCDB),
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: const [
                  SizedBox(width: 4),
                  Text("< Back", style: TextStyle(color: Colors.black, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: const Color(0xFF2E3192)),
                  child: SvgPicture.asset(
                    "assets/icons/special_care.svg",
                    height: 20,
                    width: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.category.name,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E3192)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔽 Dynamic Student Dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Student Name", style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 200,
                            child: isLoadingStudents
                                ? const Center(child: CircularProgressIndicator())
                                : GestureDetector(
                                    onTap: _showMultiSelectStudents,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        selectedStudents.isEmpty
                                            ? "Select Students"
                                            : selectedStudents
                                                .map((s) => s.studentName)
                                                .join(", "),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Remedial Class Timetable
                      const Text(
                        'Remedial Class Timetable',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E3192)),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: ['Math', 'Science', 'English'].map((subject) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'].map((day) {
                                        final isSelected = _selectedDays[subject]?.contains(day) ?? false;
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 6),
                                          child: ChoiceChip(
                                            label: Text(day, style: const TextStyle(fontSize: 12)),
                                            selected: isSelected,
                                            selectedColor: Colors.blue.shade100,
                                            onSelected: (selected) {
                                              setState(() {
                                                if (selected) {
                                                  _selectedDays[subject] ??= [];
                                                  _selectedDays[subject]!.add(day);
                                                } else {
                                                  _selectedDays[subject]?.remove(day);
                                                }
                                              });
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(height: 1, color: Colors.grey),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule, size: 16, color: Colors.grey),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () async {
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: _startTimes[subject]!,
                                          );
                                          if (picked != null) setState(() => _startTimes[subject] = picked);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            _startTimes[subject]?.format(context) ?? 'Start',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('-', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () async {
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: _endTimes[subject]!,
                                          );
                                          if (picked != null) setState(() => _endTimes[subject] = picked);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            _endTimes[subject]?.format(context) ?? 'End',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Text('Upload Files:', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.grey),
                              elevation: 0,
                            ),
                            child: const Text('Choose File'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Notes:', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: notesController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(border: InputBorder.none, hintText: 'Enter notes here'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitSpecialCare,
                          child: const Text('Submit'),
                        ),
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
}
