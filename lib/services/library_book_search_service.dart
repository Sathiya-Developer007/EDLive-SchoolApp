import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LibraryApiService {
  static const String baseUrl = "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/library";

  /// 🔎 Search Books
  static Future<List<dynamic>> searchBooks({
    String? title,
    String? author,
    String? isbn,
    String? genre,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    final queryParams = {
      if (title != null && title.isNotEmpty) "title": title,
      if (author != null && author.isNotEmpty) "author": author,
      if (isbn != null && isbn.isNotEmpty) "isbn": isbn,
      if (genre != null && genre.isNotEmpty) "genre": genre,
    };

    final uri = Uri.parse("$baseUrl/books/search").replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"] ?? [];
    } else {
      throw Exception("Failed to fetch books: ${response.body}");
    }
  }

  /// ➕ Add Book
  static Future<bool> addBook(Map<String, dynamic> bookData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    final response = await http.post(
      Uri.parse("$baseUrl/books"),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(bookData),
    );

    return response.statusCode == 201;
  }
}
