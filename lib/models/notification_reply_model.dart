class NotificationReply {
  final int id;
  final int itemId;
  final String itemType;
  final int senderId;
  final String senderType;
  final String messageText;
  final int? parentId;
  final DateTime createdAt;
  final String senderName;
  final int depth;
  final List<int> path;
  final List<NotificationReply> replies;

  NotificationReply({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.senderId,
    required this.senderType,
    required this.messageText,
    required this.parentId,
    required this.createdAt,
    required this.senderName,
    required this.depth,
    required this.path,
    required this.replies,
  });

  factory NotificationReply.fromJson(Map<String, dynamic> json) {
    return NotificationReply(
      id: json['id'] ?? 0,
      itemId: json['item_id'] ?? 0,
      itemType: json['item_type'] ?? '',
      senderId: json['sender_id'] ?? 0,
      senderType: json['sender_type'] ?? '',
      messageText: json['message_text'] ?? '',
      parentId: json['parent_id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      senderName: json['sender_name'] ?? '',
      depth: json['depth'] ?? 0,
      path: List<int>.from(json['path'] ?? []),
      replies: json['replies'] != null
          ? List<NotificationReply>.from(
              (json['replies'] as List)
                  .map((e) => NotificationReply.fromJson(e)),
            )
          : [],
    );
  }
}
