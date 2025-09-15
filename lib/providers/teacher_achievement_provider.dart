import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:school_app/models/achievement_model.dart';
import 'package:school_app/services/teacher_achievement_service.dart';

class AchievementProvider with ChangeNotifier {
  final AchievementService _service = AchievementService();
  bool _loading = false;

  bool get loading => _loading;

  /// Add Achievement
  /// Returns the created Achievement object
  Future<Achievement> addAchievement(Achievement achievement) async {
    _loading = true;
    notifyListeners();

    try {
      // Send the Achievement object directly
      final createdAchievement = await _service.createAchievement(achievement);

      print("Achievement created: ${createdAchievement.toJson()}");

      return createdAchievement;
    } catch (e, stack) {
      print("Error adding achievement: $e");
      print(stack);
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
