import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import '../../models/student_message_model.dart';
import '../../services/student_message_service.dart';

class StudentMessagesPage extends StatefulWidget {
  final int studentId;
  const StudentMessagesPage({Key? key, required this.studentId})
    : super(key: key);

  @override
  State<StudentMessagesPage> createState() => _StudentMessagesPageState();
}

class _StudentMessagesPageState extends State<StudentMessagesPage> {
  late Future<List<StudentMessage>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = MessageService.fetchMessages(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      backgroundColor: const Color(0xFFA3D3A7), // ✅ new page background

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔙 Back button at top-left

          // Inside your build method, above the FutureBuilder:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Back Button
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "< Back",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),

              // 🔹 Row with SVG Icon + Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                child: Row(
                  children: [
                    // Circle background for icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E3192), // background color
                        // shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/message.svg", // replace with your svg path
                        height: 20,
                        width: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Messages",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3192),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Messages content (takes remaining space)
          Expanded(
            child: FutureBuilder<List<StudentMessage>>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No messages found"));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon Avatar
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: msg.isAppreciation
                                  ? Colors.green
                                  : const Color(0xFF2E3192),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              msg.isAppreciation
                                  ? Icons.thumb_up_alt_rounded
                                  : Icons
                                        .chat_bubble_outline, // 👈 received msg bubble
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Message Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Sender + Date Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      msg.senderName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E3192),
                                      ),
                                    ),
                                    Text(
                                      "${msg.createdAt.toLocal()}".split(
                                        " ",
                                      )[0], // only date
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Message Text
                                Text(
                                  msg.messageText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Message Type Tag
                                // Container(
                                //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                //   decoration: BoxDecoration(
                                //     color: Colors.blue.shade50,
                                //     borderRadius: BorderRadius.circular(8),
                                //   ),
                                //   child: Text(
                                //     msg.messageType,
                                //     style: const TextStyle(
                                //       fontSize: 12,
                                //       fontWeight: FontWeight.w500,
                                //       color: Color(0xFF2E3192),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
