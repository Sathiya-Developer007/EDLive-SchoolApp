import 'package:flutter/material.dart';
import 'package:school_app/models/achievement_model.dart';
import 'package:school_app/services/achievement_service.dart';

class AchievementProvider with ChangeNotifier {
  final AchievementService _service = AchievementService();
  bool _loading = false;

  bool get loading => _loading;

  Future<void> addAchievement(Achievement achievement) async {
    _loading = true;
    notifyListeners();

    try {
      // Log payload
      print("Sending Achievement: ${achievement.toJson()}");

      // Call backend
      final response = await _service.createAchievement(achievement);

      // Log backend response
      print("Backend response: $response");

    } catch (e, stack) {
      // Only log error to console; do not show UI
      print("Error adding achievement: $e");
      print(stack);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
