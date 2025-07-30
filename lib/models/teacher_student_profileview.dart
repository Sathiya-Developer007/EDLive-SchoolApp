class StudentDetail {
  final int id;
  final String studentName;
  final String studentClass;
  final String rollNumber;
  final String dob;
  final String gender;
  final String address;
  final String? photoUrl;

  StudentDetail({
    required this.id,
    required this.studentName,
    required this.studentClass,
    required this.rollNumber,
    required this.dob,
    required this.gender,
    required this.address,
    this.photoUrl,
  });

  factory StudentDetail.fromJson(Map<String, dynamic> json) {
    return StudentDetail(
      id: json['id'],
      studentName: json['student_name'],
      studentClass: json['class'],
      rollNumber: json['roll_number'],
      dob: json['dob'],
      gender: json['gender'],
      address: json['address'],
      photoUrl: json['photo_url'],
    );
  }
}
