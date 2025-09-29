class PTAMember {
  final int id;
  final String position;
  final String name;
  final String email;
  final String phone;

  PTAMember({
    required this.id,
    required this.position,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory PTAMember.fromJson(Map<String, dynamic> json) {
    return PTAMember(
      id: json['id'],
      position: json['position'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
