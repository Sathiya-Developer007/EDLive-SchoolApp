// class CoCurricularEnrollRequest {
//   int studentId;
//   int activityId;
//   int classId;
//   int categoryId;
//   String academicYear;
//   String remarks;

//   CoCurricularEnrollRequest({
//     required this.studentId,
//     required this.activityId,
//     required this.classId,
//     required this.categoryId,
//     required this.academicYear,
//     required this.remarks,
//   });

//   Map<String, dynamic> toJson() => {
//         'studentId': studentId,
//         'activityId': activityId,
//         'classId': classId,
//         'categoryId': categoryId,
//         'academicYear': academicYear,
//         'remarks': remarks,
//       };
// }

// class CoCurricularEnrollResponse {
//   int id;
//   int studentId;
//   int categoryId;
//   int activityId;
//   int classId;
//   String remarks;
//   String academicYear;
//   String status;

//   CoCurricularEnrollResponse({
//     required this.id,
//     required this.studentId,
//     required this.categoryId,
//     required this.activityId,
//     required this.classId,
//     required this.remarks,
//     required this.academicYear,
//     required this.status,
//   });

//   factory CoCurricularEnrollResponse.fromJson(Map<String, dynamic> json) {
//     return CoCurricularEnrollResponse(
//       id: json['id'],
//       studentId: json['student_id'],
//       categoryId: json['category_id'],
//       activityId: json['activity_id'],
//       classId: json['class_id'],
//       remarks: json['remarks'],
//       academicYear: json['academic_year'],
//       status: json['status'],
//     );
//   }
// }
