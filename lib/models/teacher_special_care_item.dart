class SpecialCareItem {
  final int? id;
  final int studentId;
  final int categoryId;
  final String title;
  final String description;
  final String careType;
  final List<String> days;
  final String time;
  final List<String> materials;
  final List<String> tools;
  final int assignedTo;
  final String status;
  final String startDate;
  final String endDate;
  final String visibility;

  SpecialCareItem({
    this.id,
    required this.studentId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.careType,
    required this.days,
    required this.time,
    required this.materials,
    required this.tools,
    required this.assignedTo,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.visibility,
  });

  Map<String, dynamic> toJson() {
    return {
      "studentId": studentId,
      "categoryId": categoryId,
      "title": title,
      "description": description,
      "careType": careType,
      "scheduleDetails": {
        "days": days,
        "time": time,
      },
      "resources": {
        "materials": materials,
        "tools": tools,
      },
      "assignedTo": assignedTo,
      "status": status,
      "startDate": startDate,
      "endDate": endDate,
      "visibility": visibility,
    };
  }

  factory SpecialCareItem.fromJson(Map<String, dynamic> json) {
    return SpecialCareItem(
      id: json["id"],
      studentId: json["student_id"],
      categoryId: json["category_id"],
      title: json["title"],
      description: json["description"],
      careType: json["care_type"],
      days: List<String>.from(json["schedule_details"]["days"]),
      time: json["schedule_details"]["time"],
      materials: List<String>.from(json["resources"]["materials"]),
      tools: List<String>.from(json["resources"]["tools"]),
      assignedTo: json["assigned_to"],
      status: json["status"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      visibility: json["visibility"],
    );
  }
}
