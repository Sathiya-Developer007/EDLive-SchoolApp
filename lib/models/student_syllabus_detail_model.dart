class SyllabusDetail {
  final int? id; // nullable
  final String term;
  final String academicYear;
  final List<SyllabusItem> items;

  SyllabusDetail({
    this.id,
    required this.term,
    required this.academicYear,
    required this.items,
  });

  factory SyllabusDetail.fromJson(Map<String, dynamic> json) {
    return SyllabusDetail(
      id: json['id'],
      term: json['term'] ?? "",
      academicYear: json['academic_year'] ?? "",
      items: (json['items'] as List?)
              ?.map((item) => SyllabusItem.fromJson(item))
              .toList()
              ?? [],
    );
  }
}

class SyllabusItem {
  final int? id;         // make nullable
  final String title;
  final String description;
  final int? sequence;   // make nullable too

  SyllabusItem({
    this.id,
    required this.title,
    required this.description,
    this.sequence,
  });

  factory SyllabusItem.fromJson(Map<String, dynamic> json) {
    return SyllabusItem(
      id: json['id'],
      title: json['title'] ?? "",            // fallback
      description: json['description'] ?? "",// fallback
      sequence: json['sequence'],
    );
  }
}
