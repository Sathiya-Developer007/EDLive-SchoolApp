// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

class StudentToDoListPage extends StatefulWidget {
  const StudentToDoListPage({Key? key}) : super(key: key);

  @override
  State<StudentToDoListPage> createState() => _StudentToDoListPageState();
}

class _StudentToDoListPageState extends State<StudentToDoListPage> {
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;
  Map<int, String> _classDisplayNames = {};
  List<Map<String, dynamic>> _classList = [];
  Map<String, dynamic>? _selectedTask; // 🔹 selected task for detail view

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    _fetchClassList();
  }

  Future<void> _fetchTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final studentId = prefs.getInt('student_id');

      if (token == null || studentId == null) return;

      final url = Uri.parse(
          'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/todos/student/$studentId');

      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _tasks = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });

        for (var task in _tasks) {
          if (task['id'] != null) {
            await _markDashboardViewed(studentId, token, task['id']);
          }
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markDashboardViewed(
      int studentId, String token, int todoId) async {
    try {
      final url = Uri.parse(
          'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/viewed?studentId=$studentId');

      await http.post(url,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "item_type": "todo",
            "item_id": todoId,
          }));
    } catch (_) {}
  }

  Future<void> _fetchClassList() async {
    final url = Uri.parse(
        'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/master/classes');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _classList = data.map((item) {
            return {
              'class_id': item['class_id'],
              'class': item['class'],
              'section': item['section'],
            };
          }).toList();

          _classDisplayNames = {
            for (var classItem in _classList)
              classItem['class_id']:
                  '${classItem['class']} ${classItem['section']}',
          };
        });
      }
    } catch (_) {}
  }

  String _formatDisplayDate(String dateString) {
    try {
      return DateFormat('dd.MMM yyyy').format(DateTime.parse(dateString));
    } catch (_) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      appBar: StudentAppBar(),
      drawer: const StudentMenuDrawer(),
      body: Column(
        children: [
          // 🔙 Back
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: GestureDetector(
              onTap: () {
                if (_selectedTask != null) {
                  setState(() => _selectedTask = null);
                } else {
                  Navigator.pop(context);
                }
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/arrow_back.svg',
                    height: 11,
                    width: 11,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Back',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // 📘 Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                Icon(Icons.menu_book, color: Colors.indigo[900], size: 32),
                const SizedBox(width: 8),
                Text(
                  'My to-do list',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                ),
              ],
            ),
          ),

          // 🔹 List or Detail
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _tasks.isEmpty
                    ? const Center(child: Text('No tasks found.'))
                    : _selectedTask != null
                        ? _buildTaskDetail(_selectedTask!)
                        : ListView.builder(
                            itemCount: _tasks.length,
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              final className = task['class_id'] != null
                                  ? _classDisplayNames[task['class_id']]
                                  : null;

                            // Inside ListView.builder for task list (1st page)
return GestureDetector(
  onTap: () {
    setState(() => _selectedTask = task); // open full detail
  },
  child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatDisplayDate(task['date']),
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          task['title'] ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        // ✅ Show only first 2 lines of description
        Text(
          task['description'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        if (task['class_id'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Class: ${_classDisplayNames[task['class_id']] ?? ''}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue[700],
              ),
            ),
          ),
      ],
    ),
  ),
);
 },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDetail(Map<String, dynamic> task) {
    final className = task['class_id'] != null
        ? _classDisplayNames[task['class_id']]
        : null;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Text(
              task['title'] ?? 'No title',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3192),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Date: ${_formatDisplayDate(task['date'])}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (className != null)
            Text(
              'Class: $className',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          const SizedBox(height: 8),
          Text(
            task['description'] ?? 'No description',
            style: const TextStyle(fontSize: 16),
          ),
        ]),
      ),
    );
  }
}
