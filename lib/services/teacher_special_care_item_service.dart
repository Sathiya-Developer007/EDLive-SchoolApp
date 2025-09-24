import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/teacher_special_care_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecialCareItemService {
  static const String baseUrl =
      "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/specialcareitems";

  // Fetch items by category
  static Future<List<SpecialCareItem>> fetchItemsByCategory(int categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.get(
      Uri.parse("$baseUrl?categoryId=$categoryId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SpecialCareItem.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch items: ${response.body}");
    }
  }

  // Existing createSpecialCareItem method
  Future<SpecialCareItem> createSpecialCareItem(SpecialCareItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return SpecialCareItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create special care item: ${response.body}');
    }
  }
}
