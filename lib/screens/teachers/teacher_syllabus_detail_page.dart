import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:school_app/widgets/teacher_app_bar.dart';
import 'teacher_menu_drawer.dart';
import '../../services/teacher_syllabus_service_page2.dart';

class SyllabusDetailPage extends StatefulWidget {
  final String selectedClass;
  final int classId;
  final int subjectId;
  final String subject;
  final String academicYear;

  const SyllabusDetailPage({
    super.key,
    required this.selectedClass,
    required this.classId,
    required this.subjectId,
    required this.subject,
    this.academicYear = "2025-2026", // default
  });

  @override
  State<SyllabusDetailPage> createState() => _SyllabusDetailPageState();
}




class _SyllabusDetailPageState extends State<SyllabusDetailPage> {
  final SyllabusService syllabusService = SyllabusService();
  late Future<List<SyllabusTerm>> syllabusFuture;

  bool isAdding = false; // 👈 form show/hide control
  int? selectedSyllabusId;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final sequenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    syllabusFuture = syllabusService.fetchSyllabus(
      widget.classId,
      widget.subjectId,
      widget.academicYear,
    );
  }

  void _resetForm() {
    selectedSyllabusId = null;
    titleController.clear();
    descriptionController.clear();
    sequenceController.clear();
    isAdding = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7D7A7),
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // < Back button
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text("< Back", style: TextStyle(fontSize: 16)),
            ),
          ),

          const SizedBox(height: 8),

          // Header row with Add button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3192),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/syllabus.svg',
                    height: 24,
                    width: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Syllabus',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
                const Spacer(),
                FutureBuilder<List<SyllabusTerm>>(
                  future: syllabusFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isAdding = true;
                          });
                        },
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text("Add"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF29ABE2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                      );
                    }
                    return const SizedBox(); // nothing if no data
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // White Container
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0)
                  .copyWith(bottom: 50),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Class > Subject Row
                    Row(
                      children: [
                        Text('Class ${widget.selectedClass} > '),
                        Text(
                          widget.subject,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Add form or List
                    Expanded(
                      child: isAdding
                          ? _buildAddForm()
                          : _buildSyllabusList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddForm() {
  return FutureBuilder<List<SyllabusTerm>>(
    future: syllabusFuture,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      final terms = snapshot.data!;

      return Column(
        children: [
          // 🔹 Scrollable Form Fields
          Expanded(
            child: ListView(
              children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: "Select Term",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedSyllabusId,
                  items: terms.map((term) {
                    return DropdownMenuItem(
                      value: term.id,
                      child: Text("${term.term} (${term.academicYear})"),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedSyllabusId = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: sequenceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Sequence",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Fixed Buttons Row
          Row(
            children: [
              // Cancel Button (Grey)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _resetForm();
                    });
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Save Button (Blue)
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (selectedSyllabusId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a term")),
                      );
                      return;
                    }
                    try {
                      await syllabusService.addSyllabusItem(
                        syllabusId: selectedSyllabusId!,
                        title: titleController.text,
                        description: descriptionController.text,
                        sequence:
                            int.tryParse(sequenceController.text) ?? 0,
                      );

                      setState(() {
                        syllabusFuture = syllabusService.fetchSyllabus(
                          widget.classId,
                          widget.subjectId,
                          widget.academicYear,
                        );
                        _resetForm();
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF29ABE2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        "Save",
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

          const SizedBox(height: 20), // 🔹 20px bottom space
        ],
      );
    },
  );
}

Widget _buildSyllabusList() {
  return FutureBuilder<List<SyllabusTerm>>(
    future: syllabusFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text("No syllabus available.");
      }

      final terms = snapshot.data!;
      return ListView(
        children: terms.map((term) {
          // 🔹 Sort items by sequence
          final sortedItems = [...term.items]
            ..sort((a, b) => (a.sequence ?? 0).compareTo(b.sequence ?? 0));

          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  term.term,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Color(0xFF2E3192),
                  ),
                ),
                Text(
                  term.academicYear,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sortedItems.map((item) {
                    final seq = item.sequence ?? 0;
                    final title = item.title?.trim() ?? '';
                    final description = item.description?.trim() ?? '';

                    // 🔹 If both title & description are empty → skip sequence display
                    final hasContent = title.isNotEmpty || description.isNotEmpty;

                    return hasContent
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${seq}. $title"),
                                if (description.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 2.0),
                                    child: Text(
                                      description,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : const SizedBox(); // 👈 hide if no content
                  }).toList(),
                ),

                const Divider(height: 30),
              ],
            ),
          );
        }).toList(),
      );
    },
  );
}

}
