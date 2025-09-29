class Transport {
  final int id;
  final String busNumber;
  final String routeName;
  final String stopName;
  final String arrivalTime;
  final String driverName;
  final String driverContact;
  final String? managerName;
  final String? managerContact;

  Transport({
    required this.id,
    required this.busNumber,
    required this.routeName,
    required this.stopName,
    required this.arrivalTime,
    required this.driverName,
    required this.driverContact,
    this.managerName,
    this.managerContact,
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      id: json['id'],
      busNumber: json['bus_number'] ?? '',
      routeName: json['route_name'] ?? '',
      stopName: json['stop_name'] ?? '',
      arrivalTime: json['arrival_time'] ?? '',
      driverName: json['driver_name'] ?? '',
      driverContact: json['driver_contact'] ?? '',
      managerName: json['manager_name'],
      managerContact: json['manager_contact'],
    );
  }
}
