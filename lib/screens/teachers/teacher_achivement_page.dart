import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'teacher_addachievement_page.dart';

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
    );
  }
}

// ----------------- HELPER -----------------
String getFullImageUrl(String url) {
  if (url.isEmpty) return "";
  if (url.startsWith("http")) {
    return url; // external full URL
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
class TeacherAchievementPage extends StatefulWidget {
  const TeacherAchievementPage({super.key}); // no classId

  @override
  State<TeacherAchievementPage> createState() =>
      _TeacherAchievementPageState();
}

class _TeacherAchievementPageState extends State<TeacherAchievementPage> {
  late Future<List<Achievement>> futureAchievements;

  @override
  void initState() {
    super.initState();
    futureAchievements = fetchAchievements();
  }

  Future<List<Achievement>> fetchAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    // API URL without classId
    final url =
        "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/achievements/visible";

    final response = await http.get(
      Uri.parse(url),
      headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((e) => Achievement.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load achievements');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
       backgroundColor: const Color(0xFFFCEE21),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Row with Back button and Add button
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              "< Back",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
         ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTeacherAchievementPage(),
      ),
    );
  },
  icon: const Icon(Icons.add_circle, color: Colors.white), // add circle icon
  label: const Text(
    "Add",
    style: TextStyle(color: Colors.white),
  ),
)

        ],
      ),

      const SizedBox(height: 16),

      // Title with icon
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF2E3192),
              // shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              "assets/icons/achievements.svg", // your svg icon
              width: 20,
              height: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "Achievements",
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3192),
            ),
          ),
        ],
      ),
    ],
  ),
),

  Expanded(
            child: FutureBuilder<List<Achievement>>(
              future: futureAchievements,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF2E3192)),
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
                            buildAchievementImage(
                              item.evidenceUrl,
                              height: 150,
                            ),
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
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
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
                      buildAchievementImage(achievement.evidenceUrl, height: 220),
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
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                      const Divider(height: 28),
                      Row(
                        children: [
                          const Text(
                            "Teacher: ",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            achievement.fullName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            "Category: ",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            achievement.category,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            "Awarded by: ",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            achievement.awardedBy,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            "Date: ",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            achievement.achievementDate.isNotEmpty
                                ? achievement.achievementDate.split('T').first
                                : 'N/A',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            "Visibility: ",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            achievement.visibility,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
