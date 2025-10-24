// achievement_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:school_app/models/achievement_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:http_parser/http_parser.dart'; // for MediaType

class AchievementService {
  final String baseUrl =
      "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api";

  Future<void> createAchievement(
    Achievement achievement, {
    File? file,
    Uint8List? webFileBytes,
    String? webFileName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final uri = Uri.parse("$baseUrl/achievements");
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token';

      // ------------------- REQUIRED FIELDS -------------------
      request.fields['studentId'] = achievement.studentId.toString();
      request.fields['title'] = achievement.title;
      request.fields['description'] = achievement.description;
      request.fields['categoryId'] = achievement.categoryId; // string! "academic"
      request.fields['achievementDate'] = achievement.achievementDate;
      request.fields['awardedBy'] = achievement.awardedBy;
      request.fields['isVisible'] = achievement.isVisible; // string! "school"
      request.fields['classId'] = achievement.classId.toString();
      request.fields['academicYearId'] = achievement.academicYearId.toString();

      // ------------------- FILE UPLOAD -------------------
      if (file != null && !kIsWeb) {
        final fileName = file.path.split('/').last;
        request.files.add(await http.MultipartFile.fromPath(
          'achievementFileUpload', // backend expects this
          file.path,
          filename: fileName,
        ));
      } else if (webFileBytes != null && webFileName != null && kIsWeb) {
        final extension = webFileName.split('.').last.toLowerCase();
        request.files.add(http.MultipartFile.fromBytes(
          'achievementFileUpload',
          webFileBytes,
          filename: webFileName,
          contentType: MediaType('image', extension), // optional but safe
        ));
      }

      // ------------------- SEND REQUEST -------------------
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("✅ Achievement created successfully!");
        print("Response: $respStr");
      } else {
        print("❌ Failed to create achievement: ${response.statusCode}");
        print("Response: $respStr");
        throw Exception(
            "Failed to create achievement: ${response.statusCode}\n$respStr");
      }
    } catch (e) {
      print("❌ Error in createAchievement: $e");
      rethrow;
    }
  }
}
