import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/teacher_todo_model.dart';

class TeacherTaskProvider with ChangeNotifier {
  List<Todo> _tasks = [];
  final String _baseUrl =
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/todos';
  String? _authToken;

  // ====== AUTH TOKEN ======
  void setAuthToken(String? token) {
    _authToken = token;
    notifyListeners();
  }

  // ====== GETTERS ======
  List<Todo> get tasks => _tasks;

  Todo? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  // ====== FETCH TODOS ======
  Future<void> fetchTodos() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: _buildHeaders(),
      );

      debugPrint('GET /todos → status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _tasks = data.map((item) => Todo.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load todos. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchTodos: $e');
      rethrow;
    }
  }

  // ====== ADD TODO ======
  Future<void> addTodo({
    required String title,
    required String date,
    required String description,
    required int classId,
    required int subjectId,
    File? file,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final uri = Uri.parse(_baseUrl);
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['date'] = date;
    request.fields['description'] = description;
    request.fields['classid'] = classId.toString();
    request.fields['subjectid'] = subjectId.toString();

    if (file != null) {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final typeParts = mimeType.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'todoFileUpload',
          file.path,
          contentType: MediaType(typeParts[0], typeParts[1]),
        ),
      );
    }

    final response = await request.send();
    debugPrint('POST /todos → status: ${response.statusCode}');

    if (response.statusCode != 201) {
      final respStr = await response.stream.bytesToString();
      debugPrint('Add Todo failed: $respStr');
      throw Exception('Failed to add todo');
    }

    await fetchTodos();
  }

  // ====== UPDATE TODO ======
  Future<void> updateTodo({
    required String id,
    required String title,
    required String date,
    required String description,
    required int classId,
    required int subjectId,
    File? file,
    bool completed = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final uri = Uri.parse('$_baseUrl/$id');
    var request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['date'] = date;
    request.fields['description'] = description;
    request.fields['classid'] = classId.toString();
    request.fields['subjectid'] = subjectId.toString();
    request.fields['completed'] = completed.toString();

    if (file != null) {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final typeParts = mimeType.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'todoFileUpload',
          file.path,
          contentType: MediaType(typeParts[0], typeParts[1]),
        ),
      );
    }

    final response = await request.send();
    debugPrint('PUT /todos/$id → status: ${response.statusCode}');

    if (response.statusCode != 200) {
      final respStr = await response.stream.bytesToString();
      debugPrint('Update Todo failed: $respStr');
      throw Exception('Failed to update todo');
    }

    await fetchTodos();
  }

  // ====== DELETE TODO ======
  Future<void> deleteTodo({required String id}) async {
    final url = '$_baseUrl/$id';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: _buildHeaders(),
      );

      debugPrint('DELETE /todos/$id → status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        _tasks.removeWhere((task) => task.id == id);
        notifyListeners();
      } else {
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      debugPrint('Error in deleteTodo: $e');
      rethrow;
    }
  }

  // ====== HEADERS ======
  Map<String, String> _buildHeaders() {
    return {
      'Authorization': _authToken != null ? 'Bearer $_authToken' : '',
      'Accept': 'application/json',
    };
  }
}
