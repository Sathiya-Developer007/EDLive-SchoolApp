class LibraryMember {
  final int? id;
  final int userId;
  final String userType; // "student", "teacher", etc.
  final String membershipNumber;
  final String membershipStart;
  final String membershipEnd;
  final int maxBooks;
  final bool? isActive;

  LibraryMember({
    this.id,
    required this.userId,
    required this.userType,
    required this.membershipNumber,
    required this.membershipStart,
    required this.membershipEnd,
    required this.maxBooks,
    this.isActive,
  });

  factory LibraryMember.fromJson(Map<String, dynamic> json) {
    return LibraryMember(
      id: json['id'],
      userId: json['user_id'],
      userType: json['user_type'],
      membershipNumber: json['membership_number'],
      membershipStart: json['membership_start'],
      membershipEnd: json['membership_end'],
      maxBooks: json['max_books'],
      isActive: json['is_active'],
    );
  }

 Map<String, dynamic> toJson() {
  return {
    "user_id": userId,
    "user_type": userType, // <-- make sure it's exactly 'student', 'faculty', or 'staff'
    "membership_number": membershipNumber,
    "membership_start": membershipStart,
    "membership_end": membershipEnd,
    "max_books": maxBooks,
  };
}

}
