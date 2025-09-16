import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// ----------------- MODEL -----------------
class NotificationItem {
  final int id;
  final String title;
  final String subtitle;
  final String moduleType;
  final DateTime dateTime;
  final String type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.moduleType,
    required this.dateTime,
    required this.type,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'] ?? '',
      subtitle: json['content'] ?? '',
      moduleType: json['module_type'] ?? '',
      dateTime: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      type: json['type'] ?? '',
    );
  }
}

// ----------------- NOTIFICATION PAGE -----------------
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> _notifications = [];
  bool _loading = true;
  String? _error;

  DateTime _selectedDate = DateTime.now(); // 👈 selected date

  @override
  void initState() {
    super.initState();
    _fetchNotifications(); // load today's notifications first
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
      _fetchNotifications(); // reload API with new date
    }
  }

  Future<void> _fetchNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null) {
        setState(() {
          _loading = false;
          _error = "No token found, please login again.";
        });
        return;
      }

      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final url =
          "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/daily-notifications?date=$formattedDate";

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
                list.map((e) => NotificationItem.fromJson(e)).toList();
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
            // Back button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Text(
                "< Back",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),

            // 👇 Date picker row
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
                                    child: // Inside ListView.builder -> Card -> Column
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        // 👇 show module type here
        Text(
          item.moduleType,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    ),
    const SizedBox(height: 4),
    Text(
      DateFormat('dd/MM/yyyy HH:mm').format(item.dateTime),
      style: const TextStyle(fontSize: 12, color: Colors.black54),
    ),
    const SizedBox(height: 6),
    Text(
      item.title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    ),
    const SizedBox(height: 4),
    Text(
      item.subtitle,
      style: const TextStyle(fontSize: 13, color: Colors.grey),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
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

// ----------------- DETAIL PAGE -----------------
class NotificationDetailPage extends StatefulWidget {
  final NotificationItem item;
  final bool openChat;

  const NotificationDetailPage({
    super.key,
    required this.item,
    this.openChat = false,
  });

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  final TextEditingController _msgController = TextEditingController();
  final List<String> _messages = [];
  bool _showChat = false;

  @override
  void initState() {
    super.initState();
    if (widget.openChat) {
      _showChat = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TeacherAppBar(),
      drawer: const MenuDrawer(),
      backgroundColor: const Color(0xFFF9F7A5),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text("< Back",
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ),
            const SizedBox(height: 12),
         Expanded(
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- TYPE + CHAT ICON ----------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Type: ${widget.item.type}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3192),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.message, color: Color(0xFF2E3192)),
              onPressed: () {
                setState(() {
                  _showChat = true;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ---------- MODULE TYPE ----------
        Text(
          "Module: ${widget.item.moduleType}",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // ---------- TITLE ----------
        Text(
          widget.item.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // ---------- CONTENT ----------
        Text(
          widget.item.subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // ---------- DATE ----------
        Text(
          "Date: ${DateFormat('dd/MM/yyyy').format(widget.item.dateTime)}",
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),

        // ---------- CHAT SECTION ----------
        if (_showChat) ...[
          const Divider(height: 30),
          const Text(
            "Chat with Teacher",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3192),
            ),
          ),
          const SizedBox(height: 10),

          // MESSAGES LIST
          Flexible(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3192),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _messages[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // INPUT BOX
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgController,
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF2E3192)),
                onPressed: () {
                  if (_msgController.text.trim().isEmpty) return;
                  setState(() {
                    _messages.add(_msgController.text.trim());
                    _msgController.clear();
                  });
                },
              ),
            ],
          ),
        ],
      ],
    ),
  ),
)
 ]),
      ),
    );
  }
}
