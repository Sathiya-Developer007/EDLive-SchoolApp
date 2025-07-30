// lib/providers/settings_provider.dart
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool showAchievements = true;
  bool showTodo = true;
  bool showPTA = true;
  bool showLibrary = true;
  bool showSyllabus = true;
  bool showSpecialCare = true;
  bool showCoCurricular = true;
  bool showQuickNotes = true;
  bool showResources = true;

  void updateVisibility(String key, bool value) {
    switch (key) {
      case 'Achievements': showAchievements = value; break;
      case 'My to-do list': showTodo = value; break;
      case 'PTA': showPTA = value; break;
      case 'Library': showLibrary = value; break;
      case 'Syllabus': showSyllabus = value; break;
      case 'Special care': showSpecialCare = value; break;
      case 'Co curricular activities': showCoCurricular = value; break;
      case 'Quick notes': showQuickNotes = value; break;
      case 'Resources': showResources = value; break;
    }
    notifyListeners();
  }
}