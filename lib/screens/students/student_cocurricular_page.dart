import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentActivitiesPage extends StatefulWidget {
  final int studentId;
  final String academicYear;

  const StudentActivitiesPage({
    super.key,
    required this.studentId,
    required this.academicYear,
  });

  @override
  State<StudentActivitiesPage> createState() => _StudentActivitiesPageState();
}

class _StudentActivitiesPageState extends State<StudentActivitiesPage> {
  bool isLoading = true;
  List<dynamic> activities = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchStudentActivities();
  }

  Future<void> fetchStudentActivities() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null) {
        setState(() => errorMessage = "No auth token found");
        return;
      }

      final url =
          "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/co-curricular/student-activities"
          "?studentId=${widget.studentId}&academicYear=${widget.academicYear}";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          activities = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to fetch activities: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
    body: Container(
  color: const Color(0xFFDBD88A),
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ✅ Back button at top left
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            '< Back',
            style: TextStyle(
              color: Colors.black,
              // fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),

      // ✅ Activities list
      Expanded(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : activities.isEmpty
                    ? const Center(child: Text("No activities found"))
                    : ListView.builder(
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activity["activity_name"] ?? "Unknown Activity",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFF2E3192),
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Category: ${activity["category_name"]}", style: const TextStyle(height: 1.4)),
                                  const SizedBox(height: 4),
                                  Text("Class: ${activity["class_name"]}", style: const TextStyle(height: 1.4)),
                                  const SizedBox(height: 4),
                                  Text("Student: ${activity["student_name"]}", style: const TextStyle(height: 1.4)),
                                  const SizedBox(height: 4),
                                  Text("Academic Year: ${activity["academic_year"]}", style: const TextStyle(height: 1.4)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    ],
  ),
)
 );
  }
}
