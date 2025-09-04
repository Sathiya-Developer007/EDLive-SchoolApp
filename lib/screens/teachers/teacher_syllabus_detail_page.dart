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


Future<void> _showAddItemDialog(BuildContext context, List<SyllabusTerm> terms) async {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final sequenceController = TextEditingController();

  int? selectedSyllabusId; // store chosen term

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Add Syllabus Item"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: "Select Term"),
                  value: selectedSyllabusId,
                  items: terms.map((term) {
                    return DropdownMenuItem(
                      value: term.id,
                      child: Text("${term.term} (${term.academicYear})"),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => selectedSyllabusId = val);
                  },
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: sequenceController,
                  decoration: const InputDecoration(labelText: "Sequence"),
                  keyboardType: TextInputType.number,
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
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
                  sequence: int.tryParse(sequenceController.text) ?? 0,
                );

                setState(() {
                  syllabusFuture = syllabusService.fetchSyllabus(
                    widget.classId,
                    widget.subjectId,
                    widget.academicYear,
                  );
                });

                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}

  @override
  void initState() {
    super.initState();
    syllabusFuture = syllabusService.fetchSyllabus(
      widget.classId,
      widget.subjectId,
      widget.academicYear,
    );
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

        // Header
      // Header row with Add button
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
              onPressed: () async {
                await _showAddItemDialog(context, snapshot.data!);
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text("Add"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF29ABE2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

        // White Container (fixed height, full screen minus appbar + header)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0)
                .copyWith(bottom: 50), // 👈 gap at bottom
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
                      const Spacer(),
                      // const Icon(Icons.more_vert),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Divider row with Add + Pencil
                  // Container(
                  //   padding: const EdgeInsets.only(bottom: 8),
                  //   decoration: const BoxDecoration(
                  //     border: Border(
                  //       bottom: BorderSide(color: Color(0xFF999999), width: 0.5),
                  //     ),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       const Icon(Icons.add_circle_outline,
                  //           color: Color(0xFF29ABE2)),
                  //       const SizedBox(width: 4),
                  //       const Text('Add',
                  //           style: TextStyle(
                  //               fontSize: 14,
                  //               color: Color(0xFF29ABE2),
                  //               fontWeight: FontWeight.w500)),
                  //       const Spacer(),
                  //       // SvgPicture.asset(
                  //       //   'assets/icons/pencil.svg',
                  //       //   height: 18,
                  //       //   width: 18,
                  //       //   color: Colors.black,
                  //       // ),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 16),

                  // 🔹 Scrollable API Data inside white box
                  Expanded(
                    child: FutureBuilder<List<SyllabusTerm>>(
                      future: syllabusFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text("No syllabus available.");
                        }

                        final terms = snapshot.data!;
                        return ListView(
                          children: terms.map((term) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20.0),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: term.items.map((item) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: term.items.map((item) {
    final seq = item.sequence ?? 0; // fallback to 0 if null
    final title = item.title ?? ''; // fallback to empty string
    final description = item.description ?? ''; // fallback to empty string

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${seq + 1}. $title"),
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 2.0),
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
    );
  }).toList(),
),

                                      );
                                    }).toList(),
                                  ),
                                  const Divider(height: 30),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
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
}
