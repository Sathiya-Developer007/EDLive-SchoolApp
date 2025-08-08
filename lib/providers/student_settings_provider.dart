// lib/providers/settings_provider.dart
import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';

class StudentSettingsProvider extends ChangeNotifier {
  bool showAchievements = true;
  bool showTodo = true;
  bool showPTA = true;
  bool showLibrary = true;
  bool showSyllabus = true;
  bool showSpecialCare = true;
  bool showCoCurricular = true;
  bool showQuickNotes = true;
  bool showResources = true;

  // ✅ Added new flags
  bool showMessage = true;
  bool showSchoolBus = true;

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

      // ✅ Added new keys
      case 'Message': showMessage = value; break;
      case 'School bus': showSchoolBus = value; break;
    }
    notifyListeners();
  }
}
