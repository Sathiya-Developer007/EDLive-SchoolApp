import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:school_app/services/teacher_notification_service.dart';
import 'package:school_app/models/teacher_notification_reply_model.dart';

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
      dateTime: DateTime.tryParse(json['notification_date'] ?? json['timestamp'] ?? '') ?? DateTime.now(),
      type: json['type'] ?? '',
    );
  }
}

// ----------------- PAGE -----------------
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Map<String, List<NotificationItem>> _notificationsByDate = {};
  bool _loading = true;
  bool _fetchingMore = false;
  String? _error;
  DateTime? _nextFetchDate;
  Set<int> _viewedIds = {};

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _markAsViewed(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) return;

      final url =
          "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/viewed";

      await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "item_type": "notifications",
          "item_id": id,
        }),
      );

      debugPrint("✅ Marked notification $id as viewed");
    } catch (e) {
      debugPrint("❌ Error marking notification viewed: $e");
    }
  }

  Future<void> _fetchNotifications({bool loadMore = false}) async {
    try {
      if (loadMore) {
        setState(() => _fetchingMore = true);
      } else {
        setState(() {
          _loading = true;
          _error = null;
          _notificationsByDate.clear();
          _nextFetchDate = DateTime.now();
        });
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) {
        setState(() {
          _loading = false;
          _fetchingMore = false;
          _error = "No token found, please login again.";
        });
        return;
      }

      final dateToFetch = _nextFetchDate!;
      final formattedDate = DateFormat('yyyy-MM-dd').format(dateToFetch);

      final url =
          "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/daily-notifications?date=$formattedDate";

      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      if (response.statusCode != 200) throw Exception("Failed to fetch notifications");

      final data = json.decode(response.body);
      if (data['success'] != true) throw Exception("API returned error");

      final notificationsData =
          data['notifications']['notifications'] as Map<String, dynamic>? ?? {};

      notificationsData.forEach((dateStr, list) {
        final List items = list as List;
        if (items.isNotEmpty) {
          _notificationsByDate.putIfAbsent(dateStr, () => []);
          _notificationsByDate[dateStr]!.addAll(
              items.map((e) => NotificationItem.fromJson(e)).toList());
        }
      });

      // Prepare next fetch date
      final periodStart = data['notifications']['period_start'];
      if (periodStart != null) {
        DateTime prevStart = DateTime.parse(periodStart);
        _nextFetchDate = prevStart.isBefore(DateTime(2020)) ? null : prevStart.subtract(const Duration(days: 1));
      } else {
        _nextFetchDate = null;
      }

      // Sort notifications
      _notificationsByDate.forEach((key, value) => value.sort((a, b) => b.dateTime.compareTo(a.dateTime)));

      final sortedGrouped = Map.fromEntries(
        _notificationsByDate.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
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
        _error = "Something went wrong: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TeacherAppBar(),
      drawer: const MenuDrawer(),
      backgroundColor: const Color(0xFFF9F7A5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text("< Back", style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(color: Color(0xFF2E3192)),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset('assets/icons/notification.svg', color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Notifications",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E3192)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : _notificationsByDate.isEmpty
                          ? const Center(child: Text("No notifications found."))
                          : ListView(
                              children: [
                                ..._notificationsByDate.entries.map((entry) {
                                  final date = entry.key;
                                  final items = entry.value;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: Text(
                                          DateFormat('dd/MM/yyyy').format(DateTime.parse(date)),
                                          style: const TextStyle(
                                              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E3192)),
                                        ),
                                      ),
                                      ...items.map((item) {
                                        if (!_viewedIds.contains(item.id)) {
                                          _viewedIds.add(item.id);
                                          _markAsViewed(item.id);
                                        }

                                        return Card(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(item.type,
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                              color: Color(0xFF2E3192)),
                                                          overflow: TextOverflow.ellipsis),
                                                    ),
                                                    Text(item.moduleType,
                                                        style: const TextStyle(fontSize: 13, color: Colors.black54)),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(DateFormat('HH:mm').format(item.dateTime),
                                                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                                const SizedBox(height: 6),
                                                Text(item.title,
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                                const SizedBox(height: 4),
                                                Text(item.subtitle,
                                                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis),
                                                const SizedBox(height: 8),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => NotificationDetailPage(item: item),
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
                                if (_nextFetchDate != null)
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: _fetchingMore
                                        ? const Center(child: CircularProgressIndicator())
                                        : ElevatedButton(
                                            onPressed: () => _fetchNotifications(loadMore: true),
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



// ----------------- NOTIFICATION DETAIL PAGE -----------------


class NotificationDetailPage extends StatefulWidget {
  final NotificationItem item;

  NotificationDetailPage({super.key, required this.item});

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  final TextEditingController _msgController = TextEditingController();
  List<NotificationReply> _replies = [];
  bool _loadingReplies = true;
  String? _replyError;

  final NotificationService _service = NotificationService();

  NotificationReply? _selectedReply; // Selected message to reply

  @override
  void initState() {
    super.initState();
    _fetchReplies();
  }

  Future<void> _fetchReplies() async {
    setState(() {
      _loadingReplies = true;
      _replyError = null;
    });

    try {
      final replies = await _service.fetchReplies(
        itemId: widget.item.id,
        itemType: widget.item.moduleType,
      );
      setState(() {
        _replies = replies;
        _loadingReplies = false;
      });
    } catch (e) {
      setState(() {
        _replyError = e.toString();
        _loadingReplies = false;
      });
    }
  }

  // Flatten nested replies
  List<NotificationReply> _flattenReplies(List<NotificationReply> replies) {
    List<NotificationReply> list = [];
    for (var r in replies) {
      list.add(r);
      if (r.replies.isNotEmpty) {
        list.addAll(_flattenReplies(r.replies));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final flattenedReplies = _flattenReplies(_replies);

    return Scaffold(
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      backgroundColor: const Color(0xFFF9F7A5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Title + Back
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "< Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E3192),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/notification.svg',
                        height: 20,
                        width: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Replies",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3192),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),

            // Main content container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Notification Details
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.item.title,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("${widget.item.moduleType} • ${widget.item.type}",
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54)),
                          const SizedBox(height: 4),
                          Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(widget.item.dateTime),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black45)),
                        ],
                      ),
                    ),
                    const Divider(),

                    // Replies List
                    Expanded(
                      child: _loadingReplies
                          ? const Center(child: CircularProgressIndicator())
                          : _replyError != null
                              ? Center(child: Text(_replyError!))
                              : flattenedReplies.isEmpty
                                  ? const Center(child: Text("No replies yet"))
                                  : ListView.builder(
                                      itemCount: flattenedReplies.length,
                                      itemBuilder: (context, index) {
                                        final reply = flattenedReplies[index];
                                        final isTeacher =
                                            reply.senderType == 'Teacher';

                                        return GestureDetector(
                                          onLongPress: () {
                                            if (!isTeacher) {
                                              setState(() {
                                                _selectedReply = reply;
                                              });
                                            }
                                          },
                                          child: Align(
                                            alignment: isTeacher
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: isTeacher
                                                    ? const Color(0xFF2E3192)
                                                    : Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (_selectedReply == reply)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration:
                                                          BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: Text(
                                                        "Replying to: ${reply.messageText}",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                  Text(
                                                    reply.messageText,
                                                    style: TextStyle(
                                                      color: isTeacher
                                                          ? Colors.white
                                                          : Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    "${reply.senderName} • ${DateFormat('dd/MM/yyyy HH:mm').format(reply.createdAt)}",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: isTeacher
                                                          ? Colors.white70
                                                          : Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                    ),

                    // Reply input box
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_selectedReply != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Replying to: ${_selectedReply!.messageText}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedReply = null),
                                    child: const Icon(Icons.close, size: 16),
                                  ),
                                ],
                              ),
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _msgController,
                                  decoration: InputDecoration(
                                    hintText: "Write a reply...",
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
  onPressed: () async {
    if (_msgController.text.trim().isEmpty) return;
    await _service.sendReply(
      itemId: widget.item.id,
      itemType: widget.item.moduleType,
      message: _msgController.text.trim(),
      // replyToId removed
    );
    _msgController.clear();
    setState(() {
      _selectedReply = null; // clear selected reply after sending
    });
    _fetchReplies();
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2E3192),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  child: const Icon(Icons.send, color: Colors.white),
),
 ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}