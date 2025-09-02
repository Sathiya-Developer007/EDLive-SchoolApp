import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'teacher_quick_notes_addpage.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import '../../models/teacher_quick_note_model.dart';
import '../../services/teacher_quick_note_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherQuickNotesPage extends StatefulWidget {
  const TeacherQuickNotesPage({super.key});

  @override
  State<TeacherQuickNotesPage> createState() => _TeacherQuickNotesPageState();
}

class _TeacherQuickNotesPageState extends State<TeacherQuickNotesPage> {
  late Future<List<QuickNote>> _notesFuture;
  final QuickNoteService _service = QuickNoteService();

  /// store expanded notes (by index)
int? expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadQuickNotes();
  }

  // ✅ Load quick notes based on logged-in student class and ID
  void _loadQuickNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? studentId = prefs.getInt('student_id'); // stored at login
    int? classId = prefs.getInt('class_id'); // stored at login

    setState(() {
      _notesFuture = _service.fetchQuickNotes(
        classId: classId,
        studentId: studentId,
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      drawer: MenuDrawer(),
      appBar: TeacherAppBar(),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('< Back',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddQuickNotePage()),
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline,
                          color: Colors.white, size: 20),
                      label: const Text('Add',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF29ABE2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration:
                          const BoxDecoration(color: Color(0xFF2E3192)),
                      child: SvgPicture.asset(
                        'assets/icons/quick_notes.svg',
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Quick Notes',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E3192)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Notes List
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: FutureBuilder<List<QuickNote>>(
                future: _notesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Quick Notes available'));
                  } else {
                    final notes = snapshot.data!;
                   if (expandedIndex != null) {
  // Show only the expanded note with back button
  final note = notes[expandedIndex!];
  return ListView(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    children: [
      _expandedNoteView(note),
    ],
  );
} else {
  // Show all notes list
  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    itemCount: notes.length,
    itemBuilder: (context, index) {
      final note = notes[index];
      return _noteItem(note, index);
    },
  );
}

                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
Widget _expandedNoteView(QuickNote note) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back + Title Row
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3192)),
              onPressed: () {
                setState(() {
                  expandedIndex = null; // go back to list
                });
              },
            ),
            Expanded(
              child: Text(
                note.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3192),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Description
        if (note.description != null && note.description!.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text(
            "Description:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black, 
            ),
          ),
          const SizedBox(height: 6),
          Text(
            note.description!,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(height: 12),
        ],

        // Links
        // Links
if (note.webLinks != null && note.webLinks!.isNotEmpty) ...[
  const Divider(thickness: 1, color: Color(0xFFE6E6E6)),
  const SizedBox(height: 12),
  const Text(
    "Links:",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.black,
    ),
  ),
  const SizedBox(height: 6),
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: note.webLinks!
        .map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                onTap: () async {
                  final Uri uri = Uri.parse(l);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  l,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.none, // no underline
                  ),
                ),
              ),
            ))
        .toList(),
  ),
  const SizedBox(height: 12),
],

        // Class Name + Student Names
        const SizedBox(height: 12),
       if (note.className != null) ...[
  RichText(
    text: TextSpan(
      children: [
        const TextSpan(
          text: "Class: ",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black, // 🔹 Dark Blue for title
          ),
        ),
        TextSpan(
          text: note.className!,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  ),
  const SizedBox(height: 20), // 🔹 line space
],
if (note.studentNames != null && note.studentNames!.isNotEmpty) ...[
  RichText(
    text: TextSpan(
      children: [
        const TextSpan(
          text: "Students: ",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
             color: Colors.black,  // 🔹 Dark Blue for title
          ),
        ),
        TextSpan(
          text: note.studentNames!.join(", "),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  ),
  const SizedBox(height: 4), // 🔹 line space
],

      ],
    ),
  );
}

Widget _noteItem(QuickNote note, int index) {
  final isExpanded = expandedIndex == index;

  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            note.title,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF2E3192),
              // decoration: TextDecoration.underline,
            ),
          ),
          contentPadding: const EdgeInsets.only(left: 10, right: 0),
          trailing: IconButton(
            icon: Icon(
              isExpanded ? Icons.expand_less : Icons.chevron_right,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                if (expandedIndex == index) {
                  expandedIndex = null; // collapse
                } else {
                  expandedIndex = index; // expand only this one
                }
              });
            },
          ),
          onTap: () {
            setState(() {
              if (expandedIndex == index) {
                expandedIndex = null;
              } else {
                expandedIndex = index;
              }
            });
          },
        ),

        // Show details only for expanded item
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note.description != null && note.description!.isNotEmpty) ...[
                  const Text("Description:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(note.description!),
                  const SizedBox(height: 8),
                ],
                if (note.webLinks != null && note.webLinks!.isNotEmpty) ...[
                  const Text("Links:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...note.webLinks!.map((l) => Text(l)),
                  const SizedBox(height: 8),
                ],
                Text("Class ID: ${note.classId}"),
                Text("Student IDs: ${note.studentIds.join(", ")}"),
              ],
            ),
          ),
      ],
    ),
  );
}

}