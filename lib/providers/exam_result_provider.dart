import 'package:flutter/material.dart';
import '../models/exam_result_model.dart';
import '../services/teacher_exam_result_service.dart';

class ExamResultProvider extends ChangeNotifier {
  final ExamResultService _service = ExamResultService();

  bool isSaving = false;

  Future<void> saveResult(ExamResult result) async {
    isSaving = true;
    notifyListeners();

    try {
      await _service.saveExamResult(result);
    } catch (e) {
      rethrow;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
