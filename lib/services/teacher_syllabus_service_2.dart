import 'dart:convert';
import 'package:http/http.dart' as http;

class SyllabusItem {
  final int id;
  final String title;
  final String description;
  final int sequence;

  SyllabusItem({
    required this.id,
    required this.title,
    required this.description,
    required this.sequence,
  });

  factory SyllabusItem.fromJson(Map<String, dynamic> json) {
    return SyllabusItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      sequence: json['sequence'],
    );
  }
}

class SyllabusTerm {
  final String term;
  final String academicYear;
  final List<SyllabusItem> items;

  SyllabusTerm({
    required this.term,
    required this.academicYear,
    required this.items,
  });

  factory SyllabusTerm.fromJson(Map<String, dynamic> json) {
    return SyllabusTerm(
      term: json['term'],
      academicYear: json['academic_year'],
      items: (json['items'] as List)
          .map((item) => SyllabusItem.fromJson(item))
          .toList(),
    );
  }
}

class SyllabusService {
  final String baseUrl =
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000';

  Future<List<SyllabusTerm>> fetchSyllabus(
      int classId, int subjectId, String academicYear) async {
    final url = Uri.parse('$baseUrl/api/syllabus/$classId/$subjectId/$academicYear');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SyllabusTerm.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load syllabus');
    }
  }
}
