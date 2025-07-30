import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/student_todo_model.dart';

class StudentTaskProvider with ChangeNotifier {
  List<StudentTodo> _tasks = [];
  String? _authToken;
  bool _isLoading = false;

  final String _baseUrl =
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/todos/student';

  void setAuthToken(String? token) {
    _authToken = token;
    notifyListeners();
  }

  List<StudentTodo> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchStudentTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        },
      );

      print('GET /api/todos/student → ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _tasks = data.map((json) => StudentTodo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load student todos');
      }
    } catch (e) {
      print('Error fetching student todos: $e');
      _tasks = []; // Optionally clear on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
