import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TeacherAchievementPage extends StatefulWidget {
  const TeacherAchievementPage({super.key});

  @override
  _TeacherAchievementPageState createState() => _TeacherAchievementPageState();
}

class _TeacherAchievementPageState extends State<TeacherAchievementPage> {
  final _formKey = GlobalKey<FormState>();

  int? studentId;
  String title = '';
  String description = '';
  int? categoryId;
  DateTime? achievementDate;
  String awardedBy = '';
  String imageUrl = '';
  String visibility = 'school';
  int? classId;
  int? academicYearId;

  bool isLoading = false;

  // Example static lists, replace with API fetch if needed
  List<Map<String, dynamic>> students = [
    {"id": 1, "name": "John Doe"},
    {"id": 2, "name": "Jane Smith"}
  ];

  List<Map<String, dynamic>> classes = [
    {"id": 5, "name": "Class 5"},
    {"id": 6, "name": "Class 6"}
  ];

  List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "Sports"},
    {"id": 2, "name": "Academics"}
  ];

  Future<void> submitAchievement() async {
    if (!_formKey.currentState!.validate() ||
        studentId == null ||
        classId == null ||
        categoryId == null ||
        achievementDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Saved token

    final body = {
      "studentId": studentId,
      "title": title,
      "description": description,
      "categoryId": categoryId,
      "achievementDate": achievementDate!.toIso8601String().split('T').first,
      "awardedBy": awardedBy,
      "imageUrl": imageUrl,
      "isVisible": visibility,
      "classId": classId,
      "academicYearId": academicYearId ?? DateTime.now().year,
    };

    final response = await http.post(
      Uri.parse('http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/achievements'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Achievement created successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Achievement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Student Dropdown
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Student'),
                items: students.map<DropdownMenuItem<int>>((s) => DropdownMenuItem<int>(
                  value: s['id'] as int,
                  child: Text(s['name'] as String),
                )).toList(),
                onChanged: (val) => studentId = val,
                validator: (val) => val == null ? 'Select a student' : null,
              ),
              const SizedBox(height: 10),

              // Title
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 10),

              // Description
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (val) => description = val,
                validator: (val) => val!.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 10),

              // Category Dropdown
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories.map<DropdownMenuItem<int>>((c) => DropdownMenuItem<int>(
                  value: c['id'] as int,
                  child: Text(c['name'] as String),
                )).toList(),
                onChanged: (val) => categoryId = val,
                validator: (val) => val == null ? 'Select a category' : null,
              ),
              const SizedBox(height: 10),

              // Achievement Date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      achievementDate == null
                          ? 'Select Date'
                          : achievementDate!.toIso8601String().split('T').first,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => achievementDate = picked);
                    },
                    child: const Text('Pick Date'),
                  )
                ],
              ),
              const SizedBox(height: 10),

              // Awarded By
              TextFormField(
                decoration: const InputDecoration(labelText: 'Awarded By'),
                onChanged: (val) => awardedBy = val,
                validator: (val) => val!.isEmpty ? 'Enter awarded by' : null,
              ),
              const SizedBox(height: 10),

              // Class Dropdown
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Class'),
                items: classes.map<DropdownMenuItem<int>>((c) => DropdownMenuItem<int>(
                  value: c['id'] as int,
                  child: Text(c['name'] as String),
                )).toList(),
                onChanged: (val) => classId = val,
                validator: (val) => val == null ? 'Select a class' : null,
              ),
              const SizedBox(height: 10),

              // Visibility Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Visibility'),
                value: visibility,
                items: ['school', 'class']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (val) => visibility = val!,
              ),
              const SizedBox(height: 10),

              // Image URL input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'Enter image URL',
                ),
                onChanged: (val) => imageUrl = val,
                validator: (val) => val!.isEmpty ? 'Enter image URL' : null,
              ),
              const SizedBox(height: 20),

              // Submit button
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: submitAchievement,
                      child: const Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
