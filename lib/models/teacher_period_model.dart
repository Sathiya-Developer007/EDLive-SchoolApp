class Period {
  final int id;
  final String name;
  final String timeRange;

  Period({required this.id, required this.name, required this.timeRange});

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      id: json['id'],
      name: json['name'],
      timeRange: json['time'],
    );
  }
}
