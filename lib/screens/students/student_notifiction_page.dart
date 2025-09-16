import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

// ----------------- MODEL -----------------
class StudentNotificationItem {
  final int id;
  final String title;
  final String subtitle;
  final DateTime dateTime;
  final String moduleType;
  final String type;

  StudentNotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dateTime,
    required this.moduleType,
    required this.type,
  });

  factory StudentNotificationItem.fromJson(Map<String, dynamic> json) {
    return StudentNotificationItem(
      id: json['id'],
      title: json['title'] ?? '',
      subtitle: json['content'] ?? '',
      dateTime: DateTime.parse(json['timestamp']),
      moduleType: json['module_type'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

// ----------------- PAGE -----------------
class StudentNotificationPage extends StatefulWidget {
  final String studentId; // Pass from login page
  const StudentNotificationPage({super.key, required this.studentId});

  @override
  State<StudentNotificationPage> createState() =>
      _StudentNotificationPageState();
}

class _StudentNotificationPageState extends State<StudentNotificationPage> {
  List<StudentNotificationItem> notifications = [];
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();
  String? errorMessage;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetch();
  }

  Future<void> _loadTokenAndFetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');

    if (token == null) {
      setState(() {
        errorMessage = "Auth token not found. Please login again.";
      });
      return;
    }

    await fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (token == null || widget.studentId.isEmpty) {
        setState(() {
          errorMessage = "Token or Student ID not available.";
          isLoading = false;
        });
        return;
      }

      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      final url = Uri.parse(
        'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/daily-notifications?studentId=${widget.studentId}&date=$formattedDate',
      );

      debugPrint("Fetching URL: $url");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final List<dynamic> list = data['notifications'];
          setState(() {
            notifications =
                list.map((e) => StudentNotificationItem.fromJson(e)).toList();
          });
        } else {
          setState(() {
            notifications = [];
            errorMessage = "No notifications available";
          });
        }
      } else {
        setState(() {
          errorMessage =
              "Failed to fetch notifications. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
      setState(() {
        errorMessage = "Something went wrong while fetching notifications";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ----------------- DATE PICKER -----------------
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      await fetchNotifications();
    }
  }

  // ----------------- UI -----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBar(),
      drawer: const StudentMenuDrawer(),
      backgroundColor: const Color(0xFFF9F7A5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                "< Back",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Date Picker
            Row(
              children: [
                const Text(
                  "Select Date: ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(selectedDate),
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2E3192),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Notifications list
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : notifications.isEmpty
                          ? const Center(child: Text("No notifications"))
                          : ListView.builder(
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                final item = notifications[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Module: ${item.moduleType}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Color(0xFF2E3192),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.message,
                                                  color: Color(0xFF2E3192)),
                                              onPressed: () {
                                                // Optional: Open detail/chat page
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${item.dateTime.day}/${item.dateTime.month}/${item.dateTime.year} "
                                          "${item.dateTime.hour}:${item.dateTime.minute.toString().padLeft(2, '0')}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.subtitle,
                                          style: const TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Type: ${item.type}",
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.black45),
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
      ),
    );
  }
}
