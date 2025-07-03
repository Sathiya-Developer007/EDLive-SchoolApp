// lib/services/student_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/teacher_class_student.dart';

class StudentService {
  static Future<List<Student>> fetchStudents(String token) async {
    final url = Uri.parse(
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/staff/staff/students/list',
    );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // ✅ Correct header format
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students. Status: ${response.statusCode}');
    }
  }
}
