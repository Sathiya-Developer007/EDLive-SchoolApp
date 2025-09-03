import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '/providers/co_curricular_provider.dart';
import 'teacher_co_curricular_addpage.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:school_app/models/co_curricular_stat.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';

class CoCurricularActivitiesPage extends StatelessWidget {
  const CoCurricularActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
create: (_) => CoCurricularProvider()..fetchStats(),

      child: Scaffold(
        appBar: TeacherAppBar(),
        drawer: MenuDrawer(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFDBD88A),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            '< Back',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                   TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCoCurricularActivityPage(),
      ),
    );
  },
  style: TextButton.styleFrom(
    backgroundColor:  Colors.blue, // Blue background
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Rounded button
    ),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.add, color: Colors.white, size: 18),
      SizedBox(width: 6),
      Text(
        'Add',
        style: TextStyle(
          color: Colors.white, // White text
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),
 ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E3192),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/co_curricular.svg',
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Co curricular activities',
                          style: TextStyle(
                            color: Color(0xFF2E3192),
                            fontWeight: FontWeight.bold,
                            fontSize: 29,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Scrollable white container
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
child: Consumer<CoCurricularProvider>(
  builder: (context, provider, _) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error}'));
    } else if (provider.stats.isEmpty) {
      return const Center(child: Text('No stats found'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: provider.stats.map((stat) {
          return _buildStatItem(stat);
        }).toList(),
      ),
    );
  },
),
  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildStatItem(CoCurricularStat stat) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stat.activityName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF2E3192),
          ),
        ),
        const SizedBox(height: 4),
        Text("Category: ${stat.categoryName}"),
        Text("Class: ${stat.className}"),
        // Text("Enrollments: ${stat.enrollmentCount}"),
        const Divider(),
      ],
    ),
  );
}

  Widget _buildSection(String title, String description) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: const TextStyle(
            color: Color(0xFF2E3192),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        const Divider(color: Colors.grey),
      ],
    ),
  );
}

  Widget _buildListItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2E3192),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF2E3192),
              decorationThickness: 1.5,
            ),
          ),
          const Icon(Icons.chevron_right, size: 27),
        ],
      ),
    );
  }
}
