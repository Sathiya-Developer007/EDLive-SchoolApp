import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// ----------------- MODEL -----------------
class StudentNotificationItem {
  final int id;
  final String title;
  final String subtitle;
  final String moduleType;
  final DateTime dateTime;
  final String type;

  StudentNotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.moduleType,
    required this.dateTime,
    required this.type,
  });

  factory StudentNotificationItem.fromJson(Map<String, dynamic> json) {
    return StudentNotificationItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['content'] ?? '',
      moduleType: json['module_type'] ?? '',
      dateTime: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      type: json['type'] ?? '',
    );
  }
}

// ----------------- PAGE -----------------
class StudentNotificationPage extends StatefulWidget {
  const StudentNotificationPage({super.key});

  @override
  State<StudentNotificationPage> createState() => _StudentNotificationPageState();
}

class _StudentNotificationPageState extends State<StudentNotificationPage> {
  List<StudentNotificationItem> _notifications = [];
  bool _loading = true;
  String? _error;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _loading = true;
      });
      _fetchNotifications();
    }
  }

 Future<void> _fetchNotifications() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    final studentId = prefs.getInt("student_id");

    if (token == null || studentId == null) {
      setState(() {
        _loading = false;
        _error = "Missing token or student ID. Please login again.";
      });
      return;
    }

    // TEMP WORKAROUND: use a date that is known to work
    final formattedDate = "2025-08-01"; // <-- fixed working date
    // final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate); // original

    final url =
        "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/daily-notifications?studentId=$studentId&date=$formattedDate";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        final List list = data['notifications'] ?? [];
        setState(() {
          _notifications =
              list.map((e) => StudentNotificationItem.fromJson(e)).toList();
          _loading = false;
          _error = null;
        });
      } else {
        setState(() {
          _loading = false;
          _error = "Failed to load notifications.";
        });
      }
    } else {
      setState(() {
        _loading = false;
        _error = "Error ${response.statusCode}: ${response.reasonPhrase}";
      });
    }
  } catch (e) {
    setState(() {
      _loading = false;
      _error = "Something went wrong: $e";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TeacherAppBar(),
      drawer: const MenuDrawer(),
      backgroundColor: const Color(0xFFF9F7A5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text("< Back",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            const SizedBox(height: 12),

            // Date picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3192)),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Color(0xFF2E3192)),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Loader / Error / List
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : _notifications.isEmpty
                          ? const Center(child: Text("No notifications found."))
                          : ListView.builder(
                              itemCount: _notifications.length,
                              itemBuilder: (context, index) {
                                final item = _notifications[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.type,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Color(0xFF2E3192),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('dd/MM/yyyy HH:mm')
                                              .format(item.dateTime),
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
                                              fontSize: 13,
                                              color: Colors.grey),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "Module: ${item.moduleType}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black87),
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
