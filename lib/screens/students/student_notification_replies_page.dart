import 'package:flutter/material.dart';
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
  State<NotificationRepliesPage> createState() => _NotificationRepliesPageState();
}

class _NotificationRepliesPageState extends State<NotificationRepliesPage> {
  final NotificationReplyService _service = NotificationReplyService();
  List<NotificationReply> _replies = [];
  bool _loading = true;
  String? _error;
  final TextEditingController _replyController = TextEditingController();
  int? _replyToId; // If replying to a nested reply

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
        parentId: _replyToId,
        messageText: text,
      );

      _replyController.clear();
      _replyToId = null;
      await _fetchReplies();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send reply: $e")),
      );
    }
  }

  Widget _buildReply(NotificationReply reply, {int indent = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: indent * 16.0, bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender
            Text(
              "${reply.senderName} (${reply.senderType})",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Message
            Text(reply.messageText),
            const SizedBox(height: 4),
            // Timestamp
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(reply.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            // Reply button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _replyToId = reply.id;
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: const Text("Reply"),
              ),
            ),
            // Nested replies
            if (reply.replies.isNotEmpty)
              ...reply.replies.map((r) => _buildReply(r, indent: indent + 1)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Replies"),
        backgroundColor: const Color(0xFF2E3192),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _replies.isEmpty
                        ? const Center(child: Text("No replies found."))
                        : RefreshIndicator(
                            onRefresh: _fetchReplies,
                            child: ListView(
                              padding: const EdgeInsets.all(16),
                              children: _replies.map((r) => _buildReply(r)).toList(),
                            ),
                          ),
          ),
          // Reply input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: _replyToId == null
                          ? "Write a reply..."
                          : "Replying to ID $_replyToId",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _postReply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E3192),
                  ),
                  child: const Text("Send"),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF9F7A5),
    );
  }
}
