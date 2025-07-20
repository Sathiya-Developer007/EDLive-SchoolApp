import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '/providers/student_task_provider.dart';
import 'student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

class StudentToDoListPage extends StatefulWidget {
  const StudentToDoListPage({Key? key}) : super(key: key);

  @override
  State<StudentToDoListPage> createState() => _StudentToDoListPage();
}

class _StudentToDoListPage extends State<StudentToDoListPage> {
  Map<int, String> _classDisplayNames = {};
  List<Map<String, dynamic>> _classList = [];

  @override
  void initState() {
    super.initState();
    _loadTokenAndData();
  }

  Future<void> _loadTokenAndData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      Provider.of<StudentTaskProvider>(context, listen: false).setAuthToken(token);
      await Provider.of<StudentTaskProvider>(context, listen: false).fetchStudentTodos();
    } else {
      print("?? Token is null");
    }

    _fetchClassList();
  }

  Future<void> _fetchClassList() async {
    final url = Uri.parse(
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/master/classes',
    );

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
    } catch (e) {
      print('Error fetching classes: $e');
    }
  }

  String _formatDisplayDate(DateTime date) {
    return DateFormat('dd.MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentTaskProvider>(context);
    final tasks = provider.tasks;

    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      appBar: const StudentAppBar(),
      drawer: const StudentMenuDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/back_arrow.svg',
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
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : tasks.isEmpty
                    ? const Center(child: Text('No tasks found.'))
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final className = task.classId != null
                              ? _classDisplayNames[task.classId]
                              : null;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _formatDisplayDate(
                                      DateTime.parse(task.date),
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    task.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    task.description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  if (className != null && className.isNotEmpty)
                                    ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Class: $className',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ],
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
}
