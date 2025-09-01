import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_app/models/quicknote_student_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickNoteStudentService {
  final String baseUrl =
      "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api";

  Future<List<QuickNoteStudent>> fetchStudents(int classId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/quicknotes/classes/$classId/students'),
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => QuickNoteStudent.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load students");
    }
  }
}
