import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import '../../models/student_notification_msg_view_model.dart';
import '../../services/student_notification_msg_view_service.dart';
import 'package:intl/intl.dart';

class NotificationRepliesPage extends StatefulWidget {
  final int itemId;
  final String itemType;

  const NotificationRepliesPage({
    super.key,
    required this.itemId,
    required this.itemType,
  });

  @override
  State<NotificationRepliesPage> createState() =>
      _NotificationRepliesPageState();
}

class _NotificationRepliesPageState extends State<NotificationRepliesPage> {
  final NotificationReplyService _service = NotificationReplyService();
  List<NotificationReply> _replies = [];
  bool _loading = true;
  String? _error;
  final TextEditingController _replyController = TextEditingController();
  NotificationReply? _selectedReply;

  @override
  void initState() {
    super.initState();
    _fetchReplies();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _fetchReplies() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final replies = await _service.fetchReplies(
        itemId: widget.itemId,
        itemType: widget.itemType,
      );
      setState(() {
        _replies = replies;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _postReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    try {
      await _service.postReply(
        itemId: widget.itemId,
        itemType: widget.itemType,
        parentId: _selectedReply?.id,
        messageText: text,
      );

      _replyController.clear();
      setState(() => _selectedReply = null);
      await _fetchReplies();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to send reply: $e")));
    }
  }

  // flatten nested replies like teacher page
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
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      backgroundColor: const Color(0xFFF9F7A5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Top title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "< Back",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
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
                        'assets/icons/message.svg',
                        height: 20,
                        width: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Message Replies",
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

            // 🔹 Replies container
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
                padding: const EdgeInsets.all(12),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(child: Text(_error!))
                        : flattenedReplies.isEmpty
                            ? const Center(child: Text("No replies yet"))
                            : ListView.builder(
                                itemCount: flattenedReplies.length,
                                itemBuilder: (context, index) {
                                  final reply = flattenedReplies[index];
                                  final isStudent =
                                      reply.senderType == 'Student';

                                  return GestureDetector(
                                    onLongPress: () {
                                      if (!isStudent) {
                                        setState(() {
                                          _selectedReply = reply;
                                        });
                                      }
                                    },
                                    child: Align(
                                      alignment: isStudent
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isStudent
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
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  "Replying to: ${reply.messageText}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            Text(
                                              reply.messageText,
                                              style: TextStyle(
                                                color: isStudent
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "${reply.senderName} • ${DateFormat('dd/MM/yyyy HH:mm').format(reply.createdAt)}",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isStudent
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
            ),

            // 🔹 Reply box
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
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
                                  fontSize: 12, fontStyle: FontStyle.italic),
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
                          controller: _replyController,
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
                        onPressed: () => _postReply(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E3192),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
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
    );
  }
}
