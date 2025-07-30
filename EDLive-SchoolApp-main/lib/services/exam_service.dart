// services/exam_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student_exam_model.dart';

class ExamService {
  static Future<List<StudentExam>> fetchExams(String classId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse(
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/exams/student/$classId',
    );

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final upcoming = data['data']['upcoming'] as List;
      return upcoming.map((e) => StudentExam.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load exams');
    }
  }
}
