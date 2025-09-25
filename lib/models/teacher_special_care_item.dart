class SpecialCareItem {
  final List<int> studentIds;
  final int categoryId;   // <-- NEW
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
    required this.studentIds,
    required this.categoryId,   // <-- NEW
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
      "studentIds": studentIds,
      "categoryId": categoryId,   // <-- NEW
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
      studentIds: List<int>.from(json["studentIds"] ?? []),
      categoryId: json["categoryId"],   // <-- NEW
      title: json["title"],
      description: json["description"],
      careType: json["careType"],
      days: List<String>.from(json["scheduleDetails"]["days"]),
      time: json["scheduleDetails"]["time"],
      materials: List<String>.from(json["resources"]["materials"]),
      tools: List<String>.from(json["resources"]["tools"]),
      assignedTo: json["assignedTo"],
      status: json["status"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      visibility: json["visibility"],
    );
  }
}
