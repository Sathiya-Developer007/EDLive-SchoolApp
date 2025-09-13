import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/models/teacher_class_student.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentQuickNotesPage extends StatefulWidget {
  const StudentQuickNotesPage({super.key});

  @override
  State<StudentQuickNotesPage> createState() => _StudentQuickNotesPageState();
}

class _StudentQuickNotesPageState extends State<StudentQuickNotesPage> {
  List<dynamic> _notes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchQuickNotes();
  }

  Future<void> _fetchQuickNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token") ?? "";
      final studentId = prefs.getInt("student_id") ?? 0;
      final classId = prefs.getInt("class_id") ?? 0;

      final url =
          "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/quicknotes?classId=$classId&studentId=$studentId";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _notes = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "Failed to load notes (status ${response.statusCode})";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      drawer:  StudentMenuDrawer(),
      appBar: StudentAppBar(),
      body: Column(
        children: [
          // Header
         Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 🔹 Back button
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Text(
          '< Back',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      const SizedBox(height: 8),

      // 🔹 Row with Icon + Title
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2E3192), // background color
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              "assets/icons/quick_notes.svg",
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Quick Notes',
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
)
,const SizedBox(height: 10),

          // Notes container
         Expanded(
  child: Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 0,
    ).copyWith(bottom: 20), // 🔹 Add 20px space at the bottom
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : _notes.isEmpty
                ? const Center(child: Text("No notes available"))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _notes.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.grey),
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return ListTile(
                        title: Text(
                          note["title"] ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2E3192),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(note["description"] ?? ""),
                        trailing: Text(
                          note["created_by_name"] ?? "",
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          if (note["web_links"] != null &&
                              note["web_links"].isNotEmpty) {
                            final links =
                                (note["web_links"] as List).join("\n");
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(note["title"] ?? ""),
                                content: Text(
                                    "${note["description"]}\n\nLinks:\n$links"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: const Text("Close"),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
  ),
),
  ],
      ),
    );
  }
}
