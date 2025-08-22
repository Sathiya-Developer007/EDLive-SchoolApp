import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

// Notification model
class NotificationItem {
  final String title;
  final String subtitle;
  final String iconPath;
  final DateTime dateTime;
  final String teacherName;

  NotificationItem({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.dateTime,
    required this.teacherName,
  });
}

// Notification Page
class NotificationPage extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "PTA Meeting",
      subtitle: "PTA meeting on 12, Feb. 2019",
      iconPath: "assets/icons/message.svg",
      dateTime: DateTime(2019, 2, 12, 10, 0),
      teacherName: "Mr. John Doe",
    ),
    NotificationItem(
      title: "Homework Submission",
      subtitle: "Math homework is due tomorrow",
      iconPath: "assets/icons/message.svg",
      dateTime: DateTime(2019, 2, 11, 15, 30),
      teacherName: "Ms. Sarah Lee",
    ),
    NotificationItem(
      title: "School Event",
      subtitle:
          "Annual sports day on 20, Feb. 2019 lorem ipsum long message text",
      iconPath: "assets/icons/message.svg",
      dateTime: DateTime(2019, 2, 20, 9, 0),
      teacherName: "Mr. Robert Smith",
    ),
  ];

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
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
            const SizedBox(height: 16),

            // Notifications list
            Expanded(
              child: ListView.builder(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Teacher name + msg icon row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.teacherName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF2E3192),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            IconButton(
  icon: const Icon(Icons.message, color: Color(0xFF2E3192)),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailPage(
          item: item,       // ✅ use item here
          openChat: true,   // 🔥 this will auto open chat
        ),
      ),
    );
  },
),

                            ],
                          ),
                          const SizedBox(height: 4),

                          // Date/time
                          Text(
                            "${item.dateTime.day}/${item.dateTime.month}/${item.dateTime.year} "
                            "${item.dateTime.hour}:${item.dateTime.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 6),

                          // Title
                          Text(
                            item.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 4),

                          // Subtitle
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationDetailPage(item: item),
                                  ),
                                );
                              },
                              child: const Text("View More"),
                            ),
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



class NotificationDetailPage extends StatefulWidget {
  final NotificationItem item;
  final bool openChat; // 👈 old param

  const NotificationDetailPage({
    super.key,
    required this.item,
    this.openChat = false, // default false
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
      _showChat = true; // ✅ auto open chat if openChat true
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
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(width: 4),
                  Text("< Back",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // White container with notification details + chat
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
                    // Teacher name + msg icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Teacher: ${widget.item.teacherName}",
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
                              _showChat = true; // always open chat
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Text("Title: ${widget.item.title}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(widget.item.subtitle,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 12),
                    Text(
                      "Date: ${widget.item.dateTime.day}/${widget.item.dateTime.month}/${widget.item.dateTime.year}",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54),
                    ),

                    // ✅ Chat UI (only when _showChat true)
                    if (_showChat) ...[
                      const Divider(height: 30),
                      const Text(
                        "Chat with Teacher",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3192)),
                      ),
                      const SizedBox(height: 10),

                      Expanded(
                        child: ListView.builder(
                          itemCount: _messages.length,
                          itemBuilder: (context, index) => Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E3192),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _messages[index],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),

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
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
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
            ),
          ],
        ),
      ),
    );
  }
}
