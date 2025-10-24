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
    _loading = true;
    notifyListeners();

    try {
      await _service.createAchievement(achievement, file: file, webFileBytes: webFileBytes, webFileName: webFileName);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
