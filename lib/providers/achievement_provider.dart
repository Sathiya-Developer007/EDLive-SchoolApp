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
      await _service.createAchievement(achievement);
    } catch (e) {
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
