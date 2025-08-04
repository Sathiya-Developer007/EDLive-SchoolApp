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

import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  void initState() {
    super.initState();
    _loadTokenAndData();
  }

  Future<void> _loadTokenAndData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Pass the token directly (it can be null)
    Provider.of<TeacherTaskProvider>(context, listen: false).setAuthToken(token);

    setState(() => _authToken = token);
    _fetchClassList();
    Provider.of<TeacherTaskProvider>(context, listen: false).fetchTodos();
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

          // Initialize _classDisplayNames here
          _classDisplayNames = {};
          for (var classItem in _classList) {
            final classId = classItem['class_id'] as int;
            final className = '${classItem['class']} ${classItem['section']}';
            _classDisplayNames[classId] = className;
          }
        });

        // Debug print class list
        print('Fetched classes:');
        for (var c in _classList) {
          print('${c['class_id']}: ${c['class']} ${c['section']}');
        }
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
        const SnackBar(
          content: Text('Authentication required! Please login again'),
        ),
      );
      return;
    }

    final provider = Provider.of<TeacherTaskProvider>(context, listen: false);
    final title = _taskController.text.trim();
    final description = _descriptionController.text.trim();

    // Validate required fields
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a date')));
      return;
    }

    if (_selectedClass == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a class')));
      return;
    }

    // Extract class ID from selected class
    final classId = _selectedClass!['class_id'];
    if (classId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid class selection')));
      return;
    }

    // Format date to match backend format
    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    // Debug print before submission
    print('Submitting task:');
    print('Title: $title');
    print('Description: $description');
    print('Date: $formattedDate');
    print('Class ID: $classId');
    print('Is Edit Mode: $_isEditMode');
    print('Editing Task ID: $_editingTaskId');

    try {
      if (_isEditMode && _editingTaskId != null) {
        await provider.updateTodo(
          id: _editingTaskId!,
          title: title,
          date: formattedDate,
          description: description,
          completed: false,
          classId: classId, // Ensure this is integer
        );
      } else if (_isDeleteMode && _editingTaskId != null) {
        await provider.deleteTodo(
          id: _editingTaskId!
          );
      } else {
        await provider.addTodo(
          title: title,
          date: formattedDate,
          description: description,
          classId: classId, // Ensure this is integer
        );
      }

      // Refresh tasks and reset form
      await provider.fetchTodos();
      _resetForm();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Operation successful')));
    } catch (e) {
      print("Submit failed: $e");

      String errorMessage = 'Operation failed';
      if (e is http.ClientException) {
        errorMessage = 'Network error: ${e.message}';
      } else if (e is FormatException) {
        errorMessage = 'Data format error: ${e.message}';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
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
      drawer:  MenuDrawer(),
      appBar: TeacherAppBar(),
     body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book,
                          color: Colors.indigo[900],
                          size: 32,
                        ),
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
                    ElevatedButton.icon(
                      onPressed: () =>
                          setState(() => _showAddForm = !_showAddForm),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (_showAddForm)
            Padding(
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
                          .map<DropdownMenuItem<Map<String, dynamic>>>((
                            classItem,
                          ) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: classItem,
                              child: Text(classItem['class_name']),
                            );
                          })
                          .toList(),
                      onChanged: (Map<String, dynamic>? newValue) {
                        setState(() => _selectedClass = newValue);
                      },
                    ),
                    const SizedBox(height: 12),
                    // Select Date
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
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickDate,
                        ),
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
                            child: const Text('Cancel',style: TextStyle(color: Colors.white),)
                            ,
                          
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
                            child: const Text('Send',style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                // Get class name using _classDisplayNames map
                final className = task.classId != null
                    ? _classDisplayNames[task.classId]
                    : null;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${index + 1}'),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
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
                                  // Display class name if available
                                  if (className != null &&
                                      className.isNotEmpty) ...[
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
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  setState(() {
                                    _isEditMode = true;
                                    _selectedClassId = task.classId;
                                    _editingTaskId = task.id;
                                    _taskController.text = task.title;
                                    _descriptionController.text =
                                        task.description;
                                    _selectedDate = DateTime.tryParse(
                                      task.date,
                                    );

                                    // Pre-select class for editing
                                    if (task.classId != null) {
                                      try {
                                        _selectedClass = _classList.firstWhere(
                                          (c) => c['class_id'] == task.classId,
                                        );
                                      } catch (e) {
                                        if (_classList.isNotEmpty) {
                                          _selectedClass = _classList[0];
                                        }
                                      }
                                    }
                                    _showAddForm = true;
                                  });
                                } else if (value == 'delete') {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: const Text(
                                        'Are you sure you want to delete this task?',
                                      ),
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
                                      await provider.deleteTodo(id:task.id!);
                                    } catch (e) {
                                      print('Delete failed: $e');
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to delete: $e'),
                                        ),
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
                    ],
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
