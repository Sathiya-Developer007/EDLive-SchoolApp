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

  void setAuthToken(String? token) {
    _authToken = token;
    notifyListeners();
  }

  List<Todo> get tasks => _tasks;

  Todo? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchTodos() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: _buildHeaders(),
      );

      print('GET /todos → status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _tasks = data.map((item) => Todo.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load todos. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchTodos: $e');
      rethrow;
    }
  }

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
      request.files.add(await http.MultipartFile.fromPath(
        'todoFileUpload',
        file.path,
        contentType: MediaType('application', lookupMimeType(file.path)!.split('/')[1]),
      ));
    }

    final response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Failed to add todo');
    }
  }

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
    request.files.add(await http.MultipartFile.fromPath(
      'todoFileUpload',
      file.path,
      contentType: MediaType('application', lookupMimeType(file.path)!.split('/')[1]),
    ));
  }

  final response = await request.send();
  if (response.statusCode != 200) {
    throw Exception('Failed to update todo');
  }
}



  Future<void> deleteTodo({required String id}) async {
    final url = '$_baseUrl/$id';
    try {
      final response = await http.delete(Uri.parse(url), headers: _buildHeaders());
      print('DELETE /todos/$id → status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 204) {
        _tasks.removeWhere((task) => task.id == id);
        notifyListeners();
      } else {
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      print('Error in deleteTodo: $e');
      rethrow;
    }
  }

  Map<String, String> _buildHeaders() {
    return {
      'Authorization': _authToken != null ? 'Bearer $_authToken' : '',
      'Accept': 'application/json',
    };
  }
}
