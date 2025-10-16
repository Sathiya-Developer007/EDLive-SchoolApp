import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

class StudentQuickNotesPage extends StatefulWidget {
  const StudentQuickNotesPage({super.key});

  @override
  State<StudentQuickNotesPage> createState() => _StudentQuickNotesPageState();
}

class _StudentQuickNotesPageState extends State<StudentQuickNotesPage> {
  final List<Map<String, String>> _notes = [];
  Map<String, String>? _selectedNote;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void _addNote() {
    if (_titleController.text.trim().isEmpty ||
        _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both title and description')),
      );
      return;
    }

    setState(() {
      _notes.add({
        "title": _titleController.text.trim(),
        "description": _descController.text.trim(),
      });
      _titleController.clear();
      _descController.clear();
    });

    Navigator.pop(context);
  }

  void _showAddNoteDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Note",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3192),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addNote,
              icon: const Icon(Icons.add),
              label: const Text("Add Note"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E3192),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
      backgroundColor: const Color(0xFFE6E6E6),
      drawer: StudentMenuDrawer(),
      appBar: StudentAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E3192),
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3192),
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
          ),
          const SizedBox(height: 10),

          // Notes Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _selectedNote != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _selectedNote = null),
                            child: const Row(
                              children: [
                                Icon(Icons.arrow_back, color: Color(0xFF2E3192)),
                                SizedBox(width: 6),
                                Text(
                                  "Back to Notes",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E3192),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _selectedNote!["title"] ?? "",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3192),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _selectedNote!["description"] ?? "",
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    )
                  : _notes.isEmpty
                      ? const Center(
                          child: Text(
                            "No notes yet. Tap + to add one!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(
                                  note["title"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E3192),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    note["description"] ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                onTap: () =>
                                    setState(() => _selectedNote = note),
                              ),
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






//Old Page Code (open link) 


// import 'dart:convert';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';


// import 'package:school_app/models/teacher_class_student.dart';
// import 'package:school_app/screens/students/student_menu_drawer.dart';
// import 'package:school_app/widgets/student_app_bar.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class StudentQuickNotesPage extends StatefulWidget {
//   const StudentQuickNotesPage({super.key});

//   @override
//   State<StudentQuickNotesPage> createState() => _StudentQuickNotesPageState();
// }

// class _StudentQuickNotesPageState extends State<StudentQuickNotesPage> {
//   List<dynamic> _notes = [];
//   bool _isLoading = true;
//   String? _error;
//   dynamic _selectedNote; // 🔹 track which note is selected

//   @override
//   void initState() {
//     super.initState();
//     _fetchQuickNotes();
//   }

//   Future<void> _fetchQuickNotes() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("auth_token") ?? "";
//       final studentId = prefs.getInt("student_id") ?? 0;
//       final classId = prefs.getInt("class_id") ?? 0;

//       final url =
//           "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/quicknotes?classId=$classId&studentId=$studentId";

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _notes = data;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _error = "Failed to load notes (status ${response.statusCode})";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = "Error: $e";
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE6E6E6),
//       drawer: StudentMenuDrawer(),
//       appBar: StudentAppBar(),
//       body: Column(
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     if (_selectedNote != null) {
//                       // go back to list view
//                       setState(() {
//                         _selectedNote = null;
//                       });
//                     } else {
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: const Text(
//                     '< Back',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF2E3192),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: SvgPicture.asset(
//                         "assets/icons/quick_notes.svg",
//                         width: 24,
//                         height: 24,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     const Text(
//                       'Quick Notes',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF2E3192),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),

//           // Notes container
// Expanded(
//   child: Container(
//     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // fixed outside spacing
//     padding: const EdgeInsets.all(16), // inner padding
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : _error != null
//             ? Center(
//                 child: Text(
//                   _error!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               )
//             : _selectedNote != null
//                 ? LayoutBuilder(
//                     builder: (context, constraints) {
//                       // constraints.maxWidth is the fixed container width
//                       return SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               width: constraints.maxWidth,
//                               child: Text(
//                                 _selectedNote["title"] ?? "",
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF2E3192),
//                                 ),
//                                 softWrap: true,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             SizedBox(
//                               width: constraints.maxWidth,
//                               child: Text(
//                                 _selectedNote["description"] ?? "",
//                                 style: const TextStyle(fontSize: 16),
//                                 softWrap: true,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                           if (_selectedNote["web_links"] != null &&
//     _selectedNote["web_links"].isNotEmpty)
//   Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Text(
//         "Links:",
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       ...(_selectedNote["web_links"] as List).map(
//         (link) => SizedBox(
//           width: constraints.maxWidth,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 2),
//             child: InkWell(
//               onTap: () async {
//   final uri = Uri.tryParse(link);
//   if (uri != null) {
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(
//         uri,
//         mode: LaunchMode.externalApplication, // 🔹 opens in Chrome/Safari
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Cannot open link")),
//       );
//     }
//   }
// },
//  child: Text(
//                 link,
//                 style: const TextStyle(
//                   color: Colors.blue,
//                   // decoration: TextDecoration.underline,
//                 ),
//                 softWrap: true,
//               ),
//             ),
//           ),
//         ),
//       ).toList(),
//     ],
//   ),

//                           ],
//                         ),
//                       );
//                     },
//                   )
//               // 🔹 Replace only the list section when _selectedNote == null
// : ListView.builder(
//     padding: const EdgeInsets.all(12),
//     itemCount: _notes.length,
//     itemBuilder: (context, index) {
//       final note = _notes[index];
//       return Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: ListTile(
//           contentPadding: EdgeInsets.zero,
//           title: Text(
//             note["title"] ?? "",
//             style: const TextStyle(
//               fontSize: 16,
//               color: Color(0xFF2E3192),
//               fontWeight: FontWeight.w600,
//             ),
//             softWrap: true,
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.only(top: 4),
//             child: Text(
//               note["description"] ?? "",
//               maxLines: 2, // 🔹 show only 2 lines
//               overflow: TextOverflow.ellipsis, // 🔹 truncate with "..."
//               softWrap: true,
//             ),
//           ),
//           trailing: Text(
//             note["created_by_name"] ?? "",
//             style: const TextStyle(
//               fontStyle: FontStyle.italic,
//               fontSize: 12,
//             ),
//             softWrap: true,
//           ),
//           onTap: () {
//             setState(() {
//               _selectedNote = note;
//             });
//           },
//         ),
//       );
//     },
//   ),
//  ),
// ),
//   ],
//       ),
//     );
//   }
// }
