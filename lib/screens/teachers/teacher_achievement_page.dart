import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/models/achievement_model.dart';
import 'package:school_app/models/class_section.dart';
import 'package:school_app/providers/achievement_provider.dart';
import 'package:school_app/services/class_section_service.dart';

class TeacherAchievementPage extends StatefulWidget {
  const TeacherAchievementPage({super.key});

  @override
  State<TeacherAchievementPage> createState() => _TeacherAchievementPageState();
}

class _TeacherAchievementPageState extends State<TeacherAchievementPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _awardedByController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  int? _categoryId = 1;
  int? _classId;
  int _academicYearId = 2024;
  String _visibility = "school";
  DateTime? _selectedDate;

  List<ClassSection> _classSections = [];
  bool _loadingClasses = true;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      final service = ClassService();
      final classes = await service.fetchClassSections();
      setState(() {
        _classSections = classes;
        if (_classSections.isNotEmpty) {
          _classId = _classSections.first.id; // default selection
        }
        _loadingClasses = false;
      });
    } catch (e) {
      setState(() {
        _loadingClasses = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading classes: $e")),
      );
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_classId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a class")),
        );
        return;
      }

      final achievement = Achievement(
        studentId: int.parse(_studentIdController.text),
        title: _titleController.text,
        description: _descController.text,
        categoryId: _categoryId!,
        achievementDate: _selectedDate?.toIso8601String().split("T").first ?? "",
        awardedBy: _awardedByController.text,
        imageUrl: _imageUrlController.text,
        isVisible: _visibility,
        classId: _classId!,
        academicYearId: _academicYearId,
      );

      try {
        await Provider.of<AchievementProvider>(context, listen: false)
            .addAchievement(achievement);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Achievement added successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AchievementProvider>().loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Achievement"),
        backgroundColor: Colors.blue,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _studentIdController,
                      decoration: const InputDecoration(labelText: "Student ID"),
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val!.isEmpty ? "Enter student ID" : null,
                    ),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                      validator: (val) =>
                          val!.isEmpty ? "Enter achievement title" : null,
                    ),
                    TextFormField(
                      controller: _descController,
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      validator: (val) =>
                          val!.isEmpty ? "Enter description" : null,
                    ),
                    TextFormField(
                      controller: _awardedByController,
                      decoration:
                          const InputDecoration(labelText: "Awarded By"),
                      validator: (val) =>
                          val!.isEmpty ? "Enter awarded by" : null,
                    ),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                          labelText: "Image URL (pick or paste)"),
                      validator: (val) =>
                          val!.isEmpty ? "Enter image url" : null,
                    ),
                    const SizedBox(height: 12),

                    // Date Picker
                    Row(
                      children: [
                        const Text("Date: "),
                        Text(_selectedDate == null
                            ? "Not selected"
                            : _selectedDate!.toString().split(" ").first),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => _selectedDate = picked);
                            }
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Category Dropdown
                    DropdownButtonFormField<int>(
                      value: _categoryId,
                      decoration:
                          const InputDecoration(labelText: "Select Category"),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text("Sports")),
                        DropdownMenuItem(value: 2, child: Text("Academics")),
                        DropdownMenuItem(value: 3, child: Text("Arts")),
                      ],
                      onChanged: (val) {
                        setState(() => _categoryId = val);
                      },
                    ),

                    // Class Dropdown (API connected)
                    _loadingClasses
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<int>(
                            value: _classId,
                            decoration: const InputDecoration(
                                labelText: "Select Class"),
                            items: _classSections
                                .map((c) => DropdownMenuItem<int>(
                                      value: c.id,
                                      child: Text(c.fullName),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() => _classId = val);
                            },
                            validator: (val) =>
                                val == null ? "Select a class" : null,
                          ),

                    // Visibility Dropdown
                    DropdownButtonFormField<String>(
                      value: _visibility,
                      decoration:
                          const InputDecoration(labelText: "Visibility"),
                      items: const [
                        DropdownMenuItem(value: "school", child: Text("School")),
                        DropdownMenuItem(value: "public", child: Text("Public")),
                      ],
                      onChanged: (val) {
                        setState(() => _visibility = val ?? "school");
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _submit(context),
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
