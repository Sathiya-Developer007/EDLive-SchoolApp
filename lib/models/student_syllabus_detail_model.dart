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

class SyllabusDetail {
  final int id;
  final String term;
  final String academicYear;
  final List<SyllabusItem> items;

  SyllabusDetail({
    required this.id,
    required this.term,
    required this.academicYear,
    required this.items,
  });

  factory SyllabusDetail.fromJson(Map<String, dynamic> json) {
    return SyllabusDetail(
      id: json['id'],
      term: json['term'],
      academicYear: json['academic_year'],
      items: (json['items'] as List)
          .map((item) => SyllabusItem.fromJson(item))
          .toList(),
    );
  }
}
