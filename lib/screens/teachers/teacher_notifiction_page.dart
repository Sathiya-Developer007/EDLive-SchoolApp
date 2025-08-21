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
      iconPath: "assets/icons/notification.svg",
      dateTime: DateTime(2019, 2, 12, 10, 0),
      teacherName: "Mr. John Doe",
    ),
    NotificationItem(
      title: "Homework Submission",
      subtitle: "Math homework is due tomorrow",
      iconPath: "assets/icons/notification.svg",
      dateTime: DateTime(2019, 2, 11, 15, 30),
      teacherName: "Ms. Sarah Lee",
    ),
    NotificationItem(
      title: "School Event",
      subtitle: "Annual sports day on 20, Feb. 2019 lorem12  Math homework is due tomorrow Math homework is due tomorrow Math homework is due tomorrow Math homework is due tomorrow Math homework is due tomorrow" ,
      iconPath: "assets/icons/notification.svg",
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
    backgroundColor: const Color(0xFFF9F7A5), // Full page background
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
            child: Row(
              children: const [
                // Icon(Icons.arrow_back, color: Color(0xFF2E3192)),
                SizedBox(width: 8),
                Text(
                  "< Back",
                  style: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Notifications list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero, // Already have outer padding
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Teacher name
                        Text(
                          item.teacherName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2E3192),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Date/time
                        Text(
                          "${item.dateTime.day}/${item.dateTime.month}/${item.dateTime.year} ${item.dateTime.hour}:${item.dateTime.minute.toString().padLeft(2,'0')}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Title
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Subtitle (2 lines max)
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // View More button
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
class NotificationDetailPage extends StatelessWidget {
  final NotificationItem item;

  const NotificationDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TeacherAppBar(),
      drawer: const MenuDrawer(),
      backgroundColor: const Color(0xFFF9F7A5), // full page background
     body: Padding(
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Custom back button
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            // Icon(Icons.arrow_back, size: 20, color: Colors.blueAccent),
            SizedBox(width: 4),
            Text(
              "< Back",
              style: TextStyle(
                fontSize: 14,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),

      // White container with notification details
      Expanded(
        child: SingleChildScrollView(
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
                Text(
                  "Teacher: ${item.teacherName}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192)
,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Title: ${item.title}",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  item.subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Text(
                  "Date: ${item.dateTime.day}/${item.dateTime.month}/${item.dateTime.year}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
),
 );
  }
}