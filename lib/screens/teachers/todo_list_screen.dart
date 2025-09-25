import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/teacher_task_provider.dart';
import '../../models/teacher_todo_model.dart';
import 'teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  bool _isEditMode = false;
  bool _isDeleteMode = false;
  String? _editingTaskId;
  bool _showAddForm = false;
  DateTime? _selectedDate;
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> _classList = [];
  Map<String, dynamic>? _selectedClass;
  String? _authToken;
  int? _selectedClassId;
  Map<int, String> _classDisplayNames = {};
  Map<String, dynamic>? _selectedTask; // 🔹 for detail view toggle

  @override
  void initState() {
    super.initState();
    _loadTokenAndData();
  }

  Future<void> _markTodoViewed(String todoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse(
          'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/viewed',
        ),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "item_type": "todo",
          "item_id": todoId,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Marked todo $todoId as viewed");
      } else {
        print("❌ Failed: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error: $e");
    }
  }

  Future<void> _loadTokenAndData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    Provider.of<TeacherTaskProvider>(context, listen: false).setAuthToken(token);
    setState(() => _authToken = token);

    _fetchClassList();

    final provider = Provider.of<TeacherTaskProvider>(context, listen: false);
    await provider.fetchTodos();

    // ✅ Mark all fetched todos as viewed
    for (var task in provider.tasks) {
      if (task.id != null) {
        _markTodoViewed(task.id!);
      }
    }
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
              'class_name': item['class_name'],
              'class': item['class'],
              'section': item['section'],
            };
          }).toList();

          _classDisplayNames = {};
          for (var classItem in _classList) {
            final classId = classItem['class_id'] as int;
            final className = '${classItem['class']} ${classItem['section']}';
            _classDisplayNames[classId] = className;
          }
        });
      } else {
        throw Exception('Failed to load class list');
      }
    } catch (e) {
      print('Error fetching classes: $e');
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitTask() async {
    if (_authToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication required! Please login again')),
      );
      return;
    }

    final provider = Provider.of<TeacherTaskProvider>(context, listen: false);
    final title = _taskController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || _selectedDate == null || _selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final classId = _selectedClass!['class_id'];
    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    try {
      if (_isEditMode && _editingTaskId != null) {
        await provider.updateTodo(
          id: _editingTaskId!,
          title: title,
          date: formattedDate,
          description: description,
          completed: false,
          classId: classId,
        );
      } else {
        await provider.addTodo(
          title: title,
          date: formattedDate,
          description: description,
          classId: classId,
        );
      }

      await provider.fetchTodos();
      _resetForm();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operation successful')),
      );
    } catch (e) {
      print("Submit failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Operation failed: $e')),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _taskController.clear();
      _descriptionController.clear();
      _selectedDate = null;
      _showAddForm = false;
      _isEditMode = false;
      _selectedClassId = null;
      _editingTaskId = null;
      _selectedClass = null;
    });
  }

  String _formatDisplayDate(DateTime date) {
    return DateFormat('dd.MMM yyyy').format(date);
  }

  @override
  void dispose() {
    _taskController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherTaskProvider>(context);
    final tasks = provider.tasks;

    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      drawer: MenuDrawer(),
      appBar: TeacherAppBar(),
      body: Column(
        children: [
          // 🔙 Back button
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
                  SvgPicture.asset('assets/icons/arrow_back.svg', height: 11, width: 11),
                  const SizedBox(width: 4),
                  const Text('Back', style: TextStyle(color: Colors.black, fontSize: 16)),
                ],
              ),
            ),
          ),

          // 📘 Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book, color: Colors.indigo[900], size: 32),
                    const SizedBox(width: 8),
                    Text(
                      'To-Do List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _showAddForm = !_showAddForm),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),

          // ✏️ Add form
          if (_showAddForm) _buildAddForm(),

          // 🔹 Task list OR Detail view
          Expanded(
            child: _selectedTask != null
                ? _buildTaskDetail(_selectedTask!)
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final className =
                          task.classId != null ? _classDisplayNames[task.classId] : null;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedTask = task.toJson()),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_formatDisplayDate(DateTime.parse(task.date))),
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
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    if (className != null && className.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Class: $className',
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
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    setState(() {
                                      _isEditMode = true;
                                      _selectedClassId = task.classId;
                                      _editingTaskId = task.id;
                                      _taskController.text = task.title;
                                      _descriptionController.text = task.description;
                                      _selectedDate = DateTime.tryParse(task.date);

                                      if (task.classId != null) {
                                        try {
                                          _selectedClass = _classList.firstWhere(
                                            (c) => c['class_id'] == task.classId,
                                          );
                                        } catch (_) {}
                                      }
                                      _showAddForm = true;
                                    });
                                  } else if (value == 'delete') {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirm Delete'),
                                        content: const Text(
                                            'Are you sure you want to delete this task?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      try {
                                        await provider.deleteTodo(id: task.id!);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Delete failed: $e')),
                                        );
                                      }
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
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

  Widget _buildAddForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Class"),
            DropdownButton<Map<String, dynamic>>(
              isExpanded: true,
              value: _selectedClass,
              hint: const Text("Choose Class"),
              items: _classList
                  .map<DropdownMenuItem<Map<String, dynamic>>>((classItem) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: classItem,
                  child: Text(classItem['class_name']),
                );
              }).toList(),
              onChanged: (newValue) => setState(() => _selectedClass = newValue),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? _formatDisplayDate(_selectedDate!)
                        : 'Select Date',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(icon: const Icon(Icons.calendar_today), onPressed: _pickDate),
              ],
            ),
            const SizedBox(height: 12),
            const Text("Task Title"),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter title...',
              ),
            ),
            const SizedBox(height: 12),
            const Text("Description"),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter description...',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _resetForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Send', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskDetail(Map<String, dynamic> task) {
    final className =
        task['classId'] != null ? _classDisplayNames[task['classId']] : null;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text("Date: ${_formatDisplayDate(DateTime.parse(task['date']))}"),
            const SizedBox(height: 8),
            if (className != null) Text("Class: $className"),
            const SizedBox(height: 8),
            Text(task['description'] ?? 'No description',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
