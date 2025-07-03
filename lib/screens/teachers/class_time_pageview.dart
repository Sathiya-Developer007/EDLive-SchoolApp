import 'package:flutter/material.dart';
import 'time_table_page.dart';
import 'class_student_list_page.dart';
import 'menu_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClassTimePageView extends StatefulWidget {
  const ClassTimePageView({super.key});

  @override
  State<ClassTimePageView> createState() => _ClassTimePageViewState();
}

class _ClassTimePageViewState extends State<ClassTimePageView> {
  final PageController _controller = PageController();
  int _selectedTab = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 30, width: double.infinity, color: Colors.black),

        Expanded(
          child: Scaffold(
            backgroundColor: const Color(0xFFFCDBB1), // Soft warm background
            drawer: const MenuDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: Row(
                children: [
                  const Text(
                    'Ed',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const Text(
                    'Live',
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/icons/notification.svg',
                    height: 24,
                    width: 24,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Text(
                            "< Back",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E3192),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/class_time.svg',
                                height: 24,
                                width: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Class & Time",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2DA3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _onTabTapped(0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 0 ? Colors.blue.shade50 : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Time',
                                    style: TextStyle(
                                      color: _selectedTab == 0 ? Colors.blue : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => _onTabTapped(1),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 1 ? Colors.blue.shade50 : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'ClassPerformance',
                                    style: TextStyle(
                                      color: _selectedTab == 1 ? Colors.blue : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.more_vert),
                            ],
                          ),
                          const SizedBox(height: 0),
                          Expanded(
                            child: PageView(
                              controller: _controller,
                              onPageChanged: (index) => setState(() => _selectedTab = index),
                              children: const [
                                TimeTablePage(),
                                ClassStudentListPage(),
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
          ),
        ),
      ],
    );
  }
}
