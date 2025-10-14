import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:school_app/models/achievement_model.dart';
import 'package:school_app/services/teacher_achievement_service.dart';

class AchievementProvider with ChangeNotifier {
  final AchievementService _service = AchievementService();
  bool _loading = false;

  bool get loading => _loading;

  Future<Achievement> addAchievement(Achievement achievement) async {
    _loading = true;
    notifyListeners();

    try {
      print("Provider: Calling service with achievement: ${achievement.toJson()}");
      final createdAchievement = await _service.createAchievement(achievement);

      print("Provider: Achievement created successfully: ${createdAchievement.toJson()}");

      _loading = false;
      notifyListeners();
      return createdAchievement;
    } catch (e, stack) {
      print("Provider Error: $e");
      print("Provider Stack: $stack");
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }
}