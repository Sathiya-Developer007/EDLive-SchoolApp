import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/teacher_subject_model.dart';

class SubjectResourceService {
  static const String subjectUrl =
      "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/resources/teacher/subjects";

  static Future<List<TeacherSubjectModel>> fetchTeacherSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    final response = await http.get(
      Uri.parse(subjectUrl),
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => TeacherSubjectModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load subjects: ${response.body}");
    }
  }
}
