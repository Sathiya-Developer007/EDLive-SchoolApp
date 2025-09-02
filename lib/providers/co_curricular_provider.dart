import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/co_curricular_category.dart';

class CoCurricularProvider extends ChangeNotifier {
  List<CoCurricularCategory> categories = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchCategories() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse(
            'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/co-curricular/categories'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        categories = data
            .map((json) => CoCurricularCategory.fromJson(json))
            .toList();
      } else {
        error = 'Failed to load categories';
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
