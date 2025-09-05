import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LibraryStatusService {
  final String baseUrl =
      "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/library";

  Future<Map<String, dynamic>?> getMemberStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token"); // your saved login token

      final response = await http.get(
        Uri.parse("$baseUrl/members/status"),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $token", // 👈 attach token
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception("Failed to load member status: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
