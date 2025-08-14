// class Event {
//   final int id;
//   final String title;
//   final String description;
//   final DateTime startDate;
//   final DateTime endDate;

//   Event({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.startDate,
//     required this.endDate,
//   });

//   factory Event.fromJson(Map<String, dynamic> json) {
//     return Event(
//       id: json['id'] ?? 0,
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       startDate: DateTime.parse(json['startDate']),
//       endDate: DateTime.parse(json['endDate']),
//     );
//   }
// }
