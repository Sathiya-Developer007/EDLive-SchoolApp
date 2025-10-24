import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_app/models/achievement_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementService {
  final String baseUrl = "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api";

  Future<Achievement> createAchievement(Achievement achievement) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";

    final response = await http.post(
      Uri.parse('$baseUrl/achievements'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(achievement.toJson()),
    );

    if (response.statusCode == 201) {
      return Achievement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create achievement: ${response.body}");
    }
  }
}