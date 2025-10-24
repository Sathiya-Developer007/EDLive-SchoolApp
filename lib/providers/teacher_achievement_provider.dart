import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:school_app/models/achievement_model.dart';
import 'package:school_app/services/teacher_achievement_service.dart';

class AchievementProvider with ChangeNotifier {
  final AchievementService _service = AchievementService();

  bool _loading = false;
  bool get loading => _loading;

  Future<void> addAchievement(Achievement achievement, {File? file, Uint8List? webFileBytes, String? webFileName}) async {
    // ✅ FIX: Check if already loading
    if (_loading) {
      print("⚠️ Provider is already loading, skipping duplicate request");
      return;
    }
    
    _loading = true;
    notifyListeners();

    try {
      print("🔄 Provider: Starting achievement creation...");
      
      await _service.createAchievement(
        achievement, 
        file: file, 
        webFileBytes: webFileBytes, 
        webFileName: webFileName
      );
      
      print("✅ Provider: Achievement created successfully!");
      
    } catch (e) {
      print("🚨 PROVIDER ERROR: $e");
      rethrow; // Important: rethrow the error
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}