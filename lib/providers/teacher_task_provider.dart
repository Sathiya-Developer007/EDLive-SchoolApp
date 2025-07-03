import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/teacher_todo_model.dart';

class TeacherTaskProvider with ChangeNotifier {
  List<Todo> _tasks = [];
  final String _baseUrl =
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/todos';
  String? _authToken;

  final Map<String, String> _classDisplayNames = {
    'Task': 'Task Display Name',
    'Reminder': 'Reminder Display Name',
    // Add other class-to-display-name mappings as needed
  };

  void setAuthToken(String? token) {
    _authToken = token;
    notifyListeners();
  }

  List<Todo> get tasks => _tasks;

  Future<void> fetchTodos() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        },
      );

      print('GET /todos → status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        print('\n==== TASK VERIFICATION ====');
        print('Number of tasks: ${data.length}');

        _tasks = data.map((item) {
          final todo = Todo.fromJson(item);
          print(
            'Task: ${todo.title} | Class ID: ${todo.classId} | Class: ${todo.classId != null ? _classDisplayNames[todo.classId] : "N/A"}',
          );
          return todo;
        }).toList();

        print('==== END TASK VERIFICATION ====\n');
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
  }) async {
    final todoData = {
      'title': title,
      'date': date,
      'description': description,
      'classid': classId, // Key must be 'classid'
      'completed': false,
    };

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        },
        body: json.encode(todoData),
      );

      print('POST /todos → status: ${response.statusCode}');
      print('Request body: ${json.encode(todoData)}'); // Log request payload
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchTodos();
      } else {
        throw Exception('Failed to add todo. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in addTodo: $e');
      rethrow;
    }
  }

  Future<void> updateTodo({
    required String id,
    required String title,
    required String date,
    required String description,
    required bool completed,
    required int classId,
  }) async {
    final url = '$_baseUrl/$id';

    final updatedData = {
      'title': title,
      'date': date,
      'description': description,
      'classid': classId, // Key must be 'classid'
      'completed': completed,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        },
        body: json.encode(updatedData),
      );

      print('PUT /todos/$id → status: ${response.statusCode}');
      print('Request body: ${json.encode(updatedData)}'); // Log request payload
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        await fetchTodos();
      } else {
        throw Exception(
          'Failed to update todo. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in updateTodo: $e');
      rethrow;
    }
  }

  Future<void> deleteTodo({required String id}) async {
    final url = '$_baseUrl/$id';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: _buildHeaders(),
      );

      _logRequest('DELETE', url, response);

      if (response.statusCode == 204 || response.statusCode == 200) {
        _tasks.removeWhere((task) => task.id == id);
        notifyListeners();
        await fetchTodos();
      } else {
        throw Exception(
          'Failed to delete todo. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in deleteTodo: $e');
      rethrow;
    }
  }

  Todo? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
  }

  void _logRequest(String method, String url, http.Response response) {
    print('$method $url → status: ${response.statusCode}');
    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Response body: ${response.body}');
    }
  }
}
