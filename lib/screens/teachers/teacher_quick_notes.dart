import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'teacher_quick_notes_addpage.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import '/models/quick_note_model.dart';
import '/services/quick_note_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherQuickNotesPage extends StatefulWidget {
  const TeacherQuickNotesPage({super.key});

  @override
  State<TeacherQuickNotesPage> createState() => _TeacherQuickNotesPageState();
}

class _TeacherQuickNotesPageState extends State<TeacherQuickNotesPage> {
  late Future<List<QuickNote>> _notesFuture;
  final QuickNoteService _service = QuickNoteService();

  @override
  void initState() {
    super.initState();
    _loadQuickNotes();
  }

  // ✅ Load quick notes based on logged-in student class and ID
  void _loadQuickNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? studentId = prefs.getInt('student_id'); // stored at login
    int? classId = prefs.getInt('class_id');     // stored at login

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
                      child: const Text('< Back', style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddQuickNotePage()),
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
                      label: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 16)),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF29ABE2),
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(color: Color(0xFF2E3192)),
                      child: SvgPicture.asset(
                        'assets/icons/quick_notes.svg',
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Quick Notes',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF2E3192)),
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
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return _noteItem(note.title);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteItem(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontSize: 15, color: Color(0xFF2E3192), decoration: TextDecoration.underline)),
        contentPadding: const EdgeInsets.only(left: 10, right: 0),
        trailing: const Icon(Icons.chevron_right, color: Colors.black54),
        onTap: () {
          // Open note detail
        },
      ),
    );
  }
}
