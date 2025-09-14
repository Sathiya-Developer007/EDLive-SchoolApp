// lib/providers/dashboard_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dashboard_counts.dart';

class DashboardProvider with ChangeNotifier {
  DashboardCounts? _counts;
  bool _isLoading = false;

  DashboardCounts? get counts => _counts;
  bool get isLoading => _isLoading;

  Future<void> fetchCounts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // ensure token is saved at login

      final response = await http.get(
        Uri.parse(
          'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/counts',
        ),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _counts = DashboardCounts.fromJson(data);
      } else {
        _counts = null;
      }
    } catch (e) {
      _counts = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
