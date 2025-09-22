class NotificationReply {
  final int id;
  final int itemId;
  final String itemType;
  final int senderId;
  final String senderType;
  final String messageText;
  final String senderName;
  final DateTime createdAt;
  final int? parentId;
  final int depth;
  final List<NotificationReply> replies;

  NotificationReply({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.senderId,
    required this.senderType,
    required this.messageText,
    required this.senderName,
    required this.createdAt,
    this.parentId,
    required this.depth,
    required this.replies,
  });

  factory NotificationReply.fromJson(Map<String, dynamic> json) {
    return NotificationReply(
      id: json['id'],
      itemId: json['item_id'],
      itemType: json['item_type'],
      senderId: json['sender_id'],
      senderType: json['sender_type'],
      messageText: json['message_text'] ?? '',
      senderName: json['sender_name'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      parentId: json['parent_id'],
      depth: json['depth'] ?? 1,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => NotificationReply.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Flatten nested replies for ListView
  List<NotificationReply> flatten() {
    List<NotificationReply> result = [this];
    for (var r in replies) {
      result.addAll(r.flatten());
    }
    return result;
  }
}
