// achievement_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:school_app/models/achievement_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:http_parser/http_parser.dart'; // MediaType

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
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Required fields
      request.fields['studentId'] = achievement.studentId.toString();
      request.fields['title'] = achievement.title;
      request.fields['description'] = achievement.description;
      request.fields['categoryId'] = achievement.categoryId;
      request.fields['achievementDate'] = achievement.achievementDate;
      request.fields['awardedBy'] = achievement.awardedBy;
      request.fields['isVisible'] = achievement.isVisible;
      request.fields['classId'] = achievement.classId.toString();
      request.fields['academicYearId'] = achievement.academicYearId.toString();

      // File upload
      if (file != null && !kIsWeb) {
  if (!file.existsSync()) throw Exception("Selected file does not exist");

  final fileName = file.path.split('/').last;
  final ext = fileName.split('.').last.toLowerCase();
  final mimeType = switch (ext) {
    'png' => 'image/png',
    'jpg' => 'image/jpeg',
    'jpeg' => 'image/jpeg',
    'gif' => 'image/gif',
    _ => 'application/octet-stream',
  };

  request.files.add(await http.MultipartFile.fromPath(
    'achievementFileUpload',
    file.path,
    filename: fileName,
    contentType: MediaType.parse(mimeType),
  ));
}
 else if (webFileBytes != null && webFileName != null && kIsWeb) {
        final extension = webFileName.split('.').last.toLowerCase();
        final webMimeType = switch (extension) {
          'png' => 'image/png',
          'jpg' => 'image/jpeg',
          'jpeg' => 'image/jpeg',
          'gif' => 'image/gif',
          _ => 'application/octet-stream',
        };

        request.files.add(
          http.MultipartFile.fromBytes(
            'achievementFileUpload',
            webFileBytes,
            filename: webFileName,
            contentType: MediaType.parse(webMimeType),
          ),
        );
      }

      // Send request
      print("📤 Sending Achievement Request...");
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      print("📥 Response Code: ${response.statusCode}");
      print("📥 Response Body: $respStr");

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(
          "Failed to create achievement (${response.statusCode}): $respStr",
        );
      }
    } catch (e) {
      print("❌ Error in createAchievement: $e");
      rethrow;
    }
  }
}
