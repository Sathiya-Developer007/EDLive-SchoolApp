import 'dart:convert';
import 'package:http/http.dart' as http;

class ClassItem {
  final int id;
  final String name;

  ClassItem({required this.id, required this.name});

  factory ClassItem.fromJson(Map<String, dynamic> json) {
    return ClassItem(
      id: json['class_id'],
      name: json['class_name'],
    );
  }
}

class ClassService {
  static const String _url = 'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/master/classes';

  static Future<List<ClassItem>> fetchClasses() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => ClassItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load classes');
    }
  }
}
