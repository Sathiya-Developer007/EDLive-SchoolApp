import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'student_notification_replies_page.dart'; // your replies page

// ----------------- MODEL -----------------
class StudentNotificationItem {
  final int id;
  final String title;
  final String subtitle;
  final String moduleType;
  final DateTime dateTime;
  final String type;
  final String apiItemType; // for backend API

  StudentNotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.moduleType,
    required this.dateTime,
    required this.type,
    required this.apiItemType,
  });

  factory StudentNotificationItem.fromJson(Map<String, dynamic> json) {
    return StudentNotificationItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['content'] ?? '',
      moduleType: json['module_type'] ?? '',
      dateTime: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      type: json['type'] ?? '',
      apiItemType: json['module_type'] ?? '',
    );
  }
}

// ----------------- PAGE -----------------
class StudentNotificationPage extends StatefulWidget {
  const StudentNotificationPage({super.key});

  @override
  State<StudentNotificationPage> createState() =>
      _StudentNotificationPageState();
}

class _StudentNotificationPageState extends State<StudentNotificationPage> {
  List<StudentNotificationItem> _notifications = [];
  bool _loading = true;
  String? _error;
  DateTime _selectedDate = DateTime.now();

  Set<int> _viewedIds = {};


  bool _fetchingMore = false;
DateTime? _nextFetchDate; // for keeping track of next week's start date



@override
void initState() {
  super.initState();
  _fetchNotifications();
}


  Future<void> _markAsViewed(int itemId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    final studentId = prefs.getInt("student_id");

    if (token == null || studentId == null) return;

    final url =
        "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/viewed?studentId=$studentId";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({
        "item_type": "notifications",
        "item_id": itemId,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"] == true) {
        debugPrint("✅ Student notification $itemId marked as viewed");
      }
    } else {
      debugPrint(
          "❌ Failed to mark notification viewed: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("❌ Error marking notification viewed: $e");
  }
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

 Map<String, List<StudentNotificationItem>> _notificationsByDate = {};

Future<void> _fetchNotifications({bool loadMore = false}) async {
  try {
    if (loadMore) {
      setState(() => _fetchingMore = true);
    } else {
      setState(() {
        _loading = true;
        _error = null;
        _notificationsByDate.clear();
        _nextFetchDate = _selectedDate; // reset when first load
      });
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    final studentId = prefs.getInt("student_id");

    if (token == null || studentId == null) {
      setState(() {
        _loading = false;
        _fetchingMore = false;
        _error = "Missing token or student ID. Please login again.";
      });
      return;
    }

    final dateToFetch = _nextFetchDate ?? _selectedDate;
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateToFetch);

    final url =
        "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/daily-notifications?studentId=$studentId&date=$formattedDate";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch notifications");
    }

    final data = json.decode(response.body);
    if (data['success'] != true) {
      throw Exception("API returned error");
    }

    final notificationsData =
        data['notifications']['notifications'] as Map<String, dynamic>? ?? {};

    notificationsData.forEach((dateStr, list) {
      final List items = list as List;
      if (items.isNotEmpty) {
        _notificationsByDate.putIfAbsent(dateStr, () => []);
        _notificationsByDate[dateStr]!.addAll(
          items.map((e) => StudentNotificationItem.fromJson(e)).toList(),
        );
      }
    });

    // prepare for next week
    final periodStart = data['notifications']['period_start'];
    if (periodStart != null) {
      DateTime prevStart = DateTime.parse(periodStart);
      if (!prevStart.isBefore(DateTime(2020))) {
        _nextFetchDate = prevStart.subtract(const Duration(days: 1));
      } else {
        _nextFetchDate = null; // stop fetching
      }
    } else {
      _nextFetchDate = null;
    }

    // sort data
    _notificationsByDate.forEach((key, value) {
      value.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    });

    final sortedGrouped = Map.fromEntries(
      _notificationsByDate.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key)),
    );

    setState(() {
      _notificationsByDate = sortedGrouped;
      _loading = false;
      _fetchingMore = false;
    });
  } catch (e) {
    setState(() {
      _loading = false;
      _fetchingMore = false;
      _error = "Error: $e";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  StudentAppBar(),
      drawer: const StudentMenuDrawer(),
      backgroundColor: const Color(0xFFF9F7A5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Back button
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                
                  SizedBox(width: 4),
                  Text(
                    "< Back",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                     
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Title row with icon
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E3192),
                   
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    'assets/icons/notification.svg',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Date picker
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}",
            //       style: const TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //         color: Color(0xFF2E3192),
            //       ),
            //     ),
            //     IconButton(
            //       icon: const Icon(
            //         Icons.calendar_today,
            //         color: Color(0xFF2E3192),
            //       ),
            //       onPressed: _pickDate,
            //     ),
            //   ],
            // ),
            const SizedBox(height: 10),

            // Loader / Error / List
Expanded(
  child: _loading
      ? const Center(child: CircularProgressIndicator())
      : _error != null
          ? Center(child: Text(_error!))
          : _notificationsByDate.isEmpty
              ? const Center(child: Text("No notifications found."))
              : ListView(
                  children: [
                    // 🔹 Notifications list
                    ..._notificationsByDate.entries.map((entry) {
                      final date = entry.key;
                      final items = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date header
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(DateTime.parse(date)),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E3192),
                              ),
                            ),
                          ),
                          ...items.map((item) {
                            // Mark as viewed if not already
                            if (!_viewedIds.contains(item.id)) {
                              _viewedIds.add(item.id);
                              _markAsViewed(item.id);
                            }

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
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
                                        Text(
                                          item.moduleType,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('HH:mm').format(item.dateTime),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.subtitle,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                         Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => NotificationRepliesPage(
      notificationItem: item, // pass the whole notification
    ),
  ),
);

                                        },
                                        child: const Text("Reply"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),

                    // 🔹 Load More button at bottom
                    if (_nextFetchDate != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: _fetchingMore
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: () =>
                                    _fetchNotifications(loadMore: true),
                                child: const Text("View the notifications from the past 7 days"),
                              ),
                      ),
                  ],
                ),
),
  ],
        ),
      ),
    );
  }
}
