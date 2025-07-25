
class AttendanceStudent {
  final int id;
  final String name;
  bool isPresentMorning;
  bool isPresentAfternoon;

  AttendanceStudent({
    required this.id,
    required this.name,
    this.isPresentMorning = false,
    this.isPresentAfternoon = false,
  });
}