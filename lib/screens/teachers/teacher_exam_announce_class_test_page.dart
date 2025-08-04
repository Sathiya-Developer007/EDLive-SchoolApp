import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:school_app/services/announce_exam_service.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AnnounceClassTestPage extends StatefulWidget {
  final int? examId;

  const AnnounceClassTestPage({Key? key, this.examId}) : super(key: key);

  @override
  State<AnnounceClassTestPage> createState() => _AnnounceClassTestPageState();
}


class _AnnounceClassTestPageState extends State<AnnounceClassTestPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController examTypeController = TextEditingController();

  final String currentDate = DateFormat('d, MMM. yyyy').format(DateTime.now());

  bool sms = true;
  bool whatsapp = true;
  bool email = true;

  bool _isEditMode = false;

@override
void initState() {
  super.initState();
  if (widget.examId != null) {
    _isEditMode = true; // ✅ Set edit mode
    fetchExamDetails(widget.examId!); // ✅ Fetch existing data
  }
}




  Future<void> fetchExamDetails(int id) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token') ?? '';

  final url = Uri.parse('http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/exams/$id');

  try {
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];

      setState(() {
        examTypeController.text = data['title'] ?? '';
        subjectController.text = data['subject'] ?? '';
        descriptionController.text = data['description'] ?? '';

        DateTime dt = DateTime.parse(data['exam_date']);
        dateController.text = DateFormat('d, MMM. yyyy').format(dt);
        timeController.text = DateFormat('h:mm a').format(dt);
      });
    } else {
      print("Failed to load exam details");
    }
  } catch (e) {
    print("Error fetching exam: $e");
  }
}



  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    subjectController.dispose();
    descriptionController.dispose();
    examTypeController.dispose();
    super.dispose();
  }

  

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dateController.text = DateFormat('d, MMM. yyyy').format(picked);
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      timeController.text = picked.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 13, fontFamily: 'Arial'),
                      children: [
                        TextSpan(
                          text: 'Exams > 10 A ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: '> Class tests',
                          style: TextStyle(color: Color(0xFFB3B3B3)),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

             Text(
  _isEditMode ? 'Edit class test' : 'Announce class test',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF29ABE2),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: currentDate,

                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF2E3192), // Set your custom color
                          ),

                          onPressed: pickDate,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: timeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: pickTime,
                          color: Color(0xFF2E3192),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Exam Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: examTypeController, // ✅ Attach controller
                decoration: const InputDecoration(
                  hintText: 'e.g. Class Test, Mid-Term',
                  border: OutlineInputBorder(),
                ),
              ),

              // const SizedBox(height: 12),

              const SizedBox(height: 12),
              const Text(
                'Subject or title',

                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  hintText: 'Lesson name, topic etc...',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Type',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              // Checkboxes
              Row(
                children: [
                  Checkbox(
                    value: sms,
                    activeColor: Colors.green, // ✅ Tick icon color
                    checkColor: Colors.white, // ✅ Tick mark color (inside box)
                    side: const BorderSide(
                      color: Colors.black,
                    ), // Optional: to define box border

                    onChanged: (val) => setState(() => sms = val ?? false),
                  ),

                  const Text('SMS'),
                  Checkbox(
                    value: whatsapp,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    side: const BorderSide(color: Colors.black),

                    onChanged: (val) => setState(() => whatsapp = val ?? false),
                  ),

                  const Text('Whats app'),
                  Checkbox(
                    value: email,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    side: const BorderSide(color: Colors.black),

                    onChanged: (val) => setState(() => email = val ?? false),
                  ),

                  const Text('Email'),
                ],
              ),

              const Spacer(),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // ✅ closes the current screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                     onPressed: () async {
  if (subjectController.text.isEmpty ||
      descriptionController.text.isEmpty ||
      dateController.text.isEmpty ||
      timeController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields")),
    );
    return;
  }

  final date = dateController.text;
  final time = timeController.text;

  final combined = DateFormat('d, MMM. yyyy h:mm a').parse('$date $time');
  final isoString = combined.toIso8601String();

  final prefs = await SharedPreferences.getInstance();
  final classId = prefs.getString('classId') ?? '';
  final token = prefs.getString('auth_token') ?? '';

  final examData = {
    "title": examTypeController.text,
    "subject": subjectController.text,
    "exam_date": isoString,
    "class_id": classId,
    "description": descriptionController.text,
    "exam_type_id": 1,
  };

final url = _isEditMode
    ? Uri.parse('http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/exams/${widget.examId}')
    : Uri.parse('http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/exams');


  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

 final response = _isEditMode
    ? await http.put(url, headers: headers, body: jsonEncode(examData))
    : await http.post(url, headers: headers, body: jsonEncode(examData));

  if (response.statusCode == 200 || response.statusCode == 201) {
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditMode
              ? "Class test updated successfully"
              : "Class test announced successfully"),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditMode
            ? "Failed to update class test"
            : "Failed to announce class test"),
      ),
    );
  }
},
        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                  child: Text(
  _isEditMode ? 'Update' : 'Send',
  style: TextStyle(color: Colors.white),
),


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
