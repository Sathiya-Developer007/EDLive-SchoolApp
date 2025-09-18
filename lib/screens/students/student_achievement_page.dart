import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ----------------- MODEL -----------------
class Achievement {
  final int id;
  final String title;
  final String description;
  final String category;
  final String achievementDate;
  final String awardedBy;
  final String evidenceUrl;
  final String fullName;
  final String visibility;
  final String createdAt;
  final String updatedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.achievementDate,
    required this.awardedBy,
    required this.evidenceUrl,
    required this.fullName,
    required this.visibility,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      achievementDate: json['achievement_date'] ?? '',
      awardedBy: json['awarded_by'] ?? '',
      evidenceUrl: json['evidence_url'] ?? '',
      fullName: json['full_name'] ?? '',
      visibility: json['visibility'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

// ----------------- HELPERS -----------------
String getFullImageUrl(String url) {
  if (url.isEmpty) return "";
  if (url.startsWith("http")) {
    return url;
  } else {
    return "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000$url";
  }
}

Widget buildAchievementImage(String url, {double height = 180}) {
  if (url.isEmpty) {
    return SizedBox(
      height: height,
      child: const Center(child: Text("No image available")),
    );
  }

  final fullUrl = getFullImageUrl(url);

  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(
      fullUrl,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => SizedBox(
        height: height,
        child: const Center(child: Text("Image not available")),
      ),
    ),
  );
}

// ----------------- MAIN PAGE -----------------
class StudentAchievementPage extends StatefulWidget {
  final int classId;
  const StudentAchievementPage({super.key, required this.classId});

  @override
  State<StudentAchievementPage> createState() =>
      _StudentAchievementPageState();
}

class _StudentAchievementPageState extends State<StudentAchievementPage> {
  late Future<List<Achievement>> futureAchievements;

  @override
  void initState() {
    super.initState();
    futureAchievements = fetchAchievements();
  }

  Future<List<Achievement>> fetchAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    if (token.isEmpty) {
      throw Exception("⚠️ Missing token");
    }

    final response = await http.get(
      Uri.parse(
        "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/achievements/visible?classId=${widget.classId}",
      ),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      final achievements =
          jsonData.map((e) => Achievement.fromJson(e)).toList();

      // Sort by createdAt (latest first)
      achievements.sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt) ?? DateTime(1900);
        final dateB = DateTime.tryParse(b.createdAt) ?? DateTime(1900);
        return dateB.compareTo(dateA);
      });

      // ✅ Automatically mark all as viewed
      for (var item in achievements) {
        _markAchievementViewed(item.id);
      }

      return achievements;
    } else {
      throw Exception('Failed to load achievements');
    }
  }

  Future<void> _markAchievementViewed(int achievementId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final studentId = prefs.getInt('student_id');

    if (studentId == null || token.isEmpty) return;

    try {
      final url = Uri.parse(
        "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/viewed?studentId=$studentId",
      );

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "item_type": "achievements",
          "item_id": achievementId,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Achievement $achievementId marked as viewed");
      } else {
        debugPrint("❌ Failed to mark viewed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error marking viewed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      backgroundColor: const Color(0xFFF7EB7C),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                "< Back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // Achievement list
          Expanded(
            child: FutureBuilder<List<Achievement>>(
              future: futureAchievements,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: Color(0xFF2E3192)),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No achievements found."));
                }

                final achievements = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final item = achievements[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AchievementDetailPage(achievement: item),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildAchievementImage(item.evidenceUrl, height: 150),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.fullName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF2E3192),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${item.title} - ${item.description}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- DETAIL PAGE -----------------
class AchievementDetailPage extends StatelessWidget {
  final Achievement achievement;
  const AchievementDetailPage({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      backgroundColor: const Color(0xFFF7EB7C),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  "< Back",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildAchievementImage(achievement.evidenceUrl,
                          height: 220),
                      const SizedBox(height: 16),
                      Text(
                        achievement.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3192),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        achievement.description,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black87),
                      ),
                      const Divider(height: 28),
                      Row(
                        children: [
                          const Text("Student: ",
                              style: TextStyle(fontSize: 14)),
                          Text(achievement.fullName,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text("Category: ",
                              style: TextStyle(fontSize: 14)),
                          Text(achievement.category,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text("Awarded by: ",
                              style: TextStyle(fontSize: 14)),
                          Text(achievement.awardedBy,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text("Date: ",
                              style: TextStyle(fontSize: 14)),
                          Text(
                            achievement.achievementDate.isNotEmpty
                                ? achievement.achievementDate.split('T').first
                                : 'N/A',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text("Visibility: ",
                              style: TextStyle(fontSize: 14)),
                          Text(achievement.visibility,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
