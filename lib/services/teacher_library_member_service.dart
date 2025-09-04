import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/teacher_library_member.dart';

class LibraryMemberService {
  final String baseUrl = "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api";

  Future<LibraryMember?> addMember(LibraryMember member) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse("$baseUrl/library/members");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(member.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];
      return LibraryMember.fromJson(data);
    } else {
      throw Exception("Failed to add member: ${response.body}");
    }
  }
}
