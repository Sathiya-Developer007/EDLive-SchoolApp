// lib/services/todo_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/teacher_todo_model.dart';

class TodoService {
  final String baseUrl = 'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/todos';

  // GET /api/todos
  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonList = json.decode(response.body);
      return jsonList.map((e) => Todo.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  // POST /api/todos
  Future<void> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create todo');
    }
  }

  // GET /api/todos/{id}
  Future<Todo> getTodoById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch todo by ID');
    }
  }

  // PUT /api/todos/{id}
  Future<void> updateTodo(int id, Todo todo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }

  // DELETE /api/todos/{id}
  Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
}





