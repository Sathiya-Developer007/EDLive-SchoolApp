import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

import '../../providers/teacher_task_provider.dart';
import '../../models/teacher_todo_model.dart';

import 'teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

import 'package:school_app/services/teacher_syllabus_subject_service.dart';
import 'package:school_app/models/teacher_syllabus_subject_model.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  bool _isEditMode = false;
  String? _editingTaskId;
  bool _showAddForm = false;
  DateTime? _selectedDate;
  PlatformFile? _selectedFile;

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> _classList = [];
  Map<String, dynamic>? _selectedClass;
  Map<int, String> _classDisplayNames = {};
  String? _authToken;

  List<SubjectModel> _subjectList = [];
  SubjectModel? _selectedSubject;

  @override
  void initState() {
    super.initState();
    _loadTokenAndData();
  }

  Future<void> _loadTokenAndData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('Auth token: $token');

    setState(() => _authToken = token);

    final provider = Provider.of<TeacherTaskProvider>(context, listen: false);
    provider.setAuthToken(token);

    await _fetchClassList();
    await provider.fetchTodos();
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
            _classDisplayNames[classId] =
                '${classItem['class']} ${classItem['section']}';
          }
        });
      }
    } catch (e) {
      print('Error fetching classes: $e');
    }
  }

  Future<void> _fetchSubjectsForClass() async {
    try {
      final subjects = await SubjectService().fetchSubjects();
      setState(() {
        _subjectList = subjects;
        _selectedSubject = null;
      });
    } catch (e) {
      print('Error fetching subjects: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching subjects: $e')),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
        });
        print('✅ File selected: ${_selectedFile!.name}');
      } else {
        print('⚠️ File picking cancelled.');
      }
    } catch (e) {
      print('❌ File picking failed: $e');
    }
  }

  Future<void> _submitTask() async {
    if (_authToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication error: No token found')),
      );
      return;
    }

    if (_selectedClass == null || _selectedDate == null || _selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select class, subject, and date')),
      );
      return;
    }

    final provider = Provider.of<TeacherTaskProvider>(context, listen: false);
    final title = _taskController.text.trim();
    final description = _descriptionController.text.trim();
    final classId = int.tryParse(_selectedClass!['class_id'].toString()) ?? 0;
    final subjectId = _selectedSubject!.id;
    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      print('Uploading ToDo...');
      print('Title: $title');
      print('Date: $formattedDate');
      print('ClassId: $classId');
      print('SubjectId: $subjectId');
      print('File: ${_selectedFile?.name ?? "none"}');
      print('Auth Token: $_authToken');

      if (_isEditMode && _editingTaskId != null) {
        await provider.updateTodo(
          id: _editingTaskId!,
          title: title,
          date: formattedDate,
          description: description,
          classId: classId,
          subjectId: subjectId,
          pickedFile: _selectedFile,
        );
      } else {
        await provider.addTodo(
          title: title,
          date: formattedDate,
          description: description,
          classId: classId,
          subjectId: subjectId,
          pickedFile: _selectedFile,
        );
      }

      await provider.fetchTodos();
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operation successful')),
      );
    } catch (e) {
      print('Submit failed: $e');
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
      _selectedFile = null;
      _showAddForm = false;
      _isEditMode = false;
      _editingTaskId = null;
      _selectedClass = null;
      _selectedSubject = null;
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
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF87CEEB),
      drawer: MenuDrawer(),
      appBar: TeacherAppBar(),
      body: Column(
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
                    Icon(Icons.menu_book, color: Colors.indigo[900], size: 32),
                    const SizedBox(width: 8),
                    Text(
                      'Home Work',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),
                  ],
                ),
                if (!_showAddForm)
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _showAddForm = true),
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
                    ),
                  ),
              ],
            ),
          ),
          if (_showAddForm) _buildAddForm(),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final className = task.classId != null
                    ? _classDisplayNames[task.classId]
                    : null;

                return GestureDetector(
                  onTap: () {},
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
                              Text(
                                _formatDisplayDate(DateTime.parse(task.date)),
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
                              if (task.fileUrl != null && task.fileUrl!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'File: ${task.fileUrl!.split('/').last}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green[700],
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
                                _editingTaskId = task.id;
                                _taskController.text = task.title;
                                _descriptionController.text = task.description;
                                _selectedDate = DateTime.tryParse(task.date);

                                _selectedClass = _classList.firstWhere(
                                  (c) => c['class_id'] == task.classId,
                                  orElse: () => {},
                                );
                                if (_selectedClass!.isEmpty) _selectedClass = null;

                                _showAddForm = true;
                                _selectedSubject = null;
                              });

                              if (_selectedClass != null) {
                                _fetchSubjectsForClass().then((_) {
                                  SubjectModel? selected;
                                  try {
                                    selected = _subjectList.firstWhere(
                                      (s) => s.id == task.subjectId,
                                    );
                                  } catch (e) {
                                    selected = null;
                                  }
                                  setState(() {
                                    _selectedSubject = selected;
                                  });
                                });
                              }
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
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await provider.deleteTodo(id: task.id!);
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.fromLTRB(16, 10, 16, bottomInset > 0 ? bottomInset : 10),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Class"),
              DropdownButton<Map<String, dynamic>>(
                isExpanded: true,
                value: _selectedClass,
                hint: const Text("Choose Class"),
                items: _classList.map<DropdownMenuItem<Map<String, dynamic>>>((classItem) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: classItem,
                    child: Text(classItem['class_name']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() => _selectedClass = newValue);
                  if (newValue != null) {
                    _fetchSubjectsForClass();
                  }
                },
              ),
              const SizedBox(height: 12),
              const Text("Select Subject"),
              DropdownButton<SubjectModel>(
                isExpanded: true,
                value: _selectedSubject,
                hint: const Text("Choose Subject"),
                items: _subjectList.map((subjectItem) {
                  return DropdownMenuItem<SubjectModel>(
                    value: subjectItem,
                    child: Text(subjectItem.name),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedSubject = newValue),
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.attach_file),
                      label: Text(
                        _selectedFile != null
                            ? 'Selected: ${_selectedFile!.name}'
                            : 'Attach File',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetForm,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitTask,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text('Send', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}