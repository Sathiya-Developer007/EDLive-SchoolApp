class StudentMessage {
  final int id;
  final int studentId;
  final int senderId;
  final String messageType;
  final String messageText;
  final bool isAppreciation;
  final bool isMeetingRequest;
  final DateTime? meetingDate;
  final String sentVia;
  final String whatsappStatus;
  final String smsStatus;
  final String emailStatus;
  final DateTime createdAt;
  final String senderName;
  final String studentName;

  StudentMessage({
    required this.id,
    required this.studentId,
    required this.senderId,
    required this.messageType,
    required this.messageText,
    required this.isAppreciation,
    required this.isMeetingRequest,
    required this.meetingDate,
    required this.sentVia,
    required this.whatsappStatus,
    required this.smsStatus,
    required this.emailStatus,
    required this.createdAt,
    required this.senderName,
    required this.studentName,
  });

  factory StudentMessage.fromJson(Map<String, dynamic> json) {
    return StudentMessage(
      id: json['id'],
      studentId: json['student_id'],
      senderId: json['sender_id'],
      messageType: json['message_type'] ?? '',
      messageText: json['message_text'] ?? '',
      isAppreciation: json['is_appreciation'] ?? false,
      isMeetingRequest: json['is_meeting_request'] ?? false,
      meetingDate: json['meeting_date'] != null
          ? DateTime.tryParse(json['meeting_date'])
          : null,
      sentVia: json['sent_via'] ?? '',
      whatsappStatus: json['whatsapp_status'] ?? '',
      smsStatus: json['sms_status'] ?? '',
      emailStatus: json['email_status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      senderName: json['sender_name'] ?? '',
      studentName: json['student_name'] ?? '',
    );
  }
}
