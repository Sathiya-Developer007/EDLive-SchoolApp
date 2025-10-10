import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/day_food_tab.dart';
import 'package:school_app/screens/students//week_food_tab.dart';
import 'package:school_app/screens/students//month_food_tab.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

class StudentFoodPage extends StatefulWidget {
  const StudentFoodPage({super.key});

  @override
  State<StudentFoodPage> createState() => _StudentFoodPageState();
}

class _StudentFoodPageState extends State<StudentFoodPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDC87D),
        appBar: StudentAppBar(),
        drawer: StudentMenuDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section remains the same
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "< Back",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E3192),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/food.svg",
                          width: 20,
                          height: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Food",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3192),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab content area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color(0xFF2E3192),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFF2E3192),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(text: "Day"),
                        Tab(text: "Week"),
                        Tab(text: "Month"),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Expanded(
                      child: TabBarView(
                        children: [
                          DayFoodTab(),
                          WeekFoodTab(),
                          MonthFoodTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}