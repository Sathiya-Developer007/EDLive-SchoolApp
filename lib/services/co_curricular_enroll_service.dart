import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/co_curricular_enroll_model.dart';

class CoCurricularEnrollService {
  static const String baseUrl =
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api';

  static Future<CoCurricularEnrollResponse?> enrollStudent(
      CoCurricularEnrollRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final url = Uri.parse('$baseUrl/co-curricular/enroll');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CoCurricularEnrollResponse.fromJson(data);
    } else {
      throw Exception(
          'Failed to enroll student: ${response.statusCode} ${response.body}');
    }
  }
}
