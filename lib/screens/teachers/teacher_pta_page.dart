import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

import 'teacher_pta_announce_meeting.dart';

class TeacherPTAPage extends StatefulWidget {
  const TeacherPTAPage({Key? key}) : super(key: key);

  @override
  State<TeacherPTAPage> createState() => _TeacherPTAPageState();
}

class _TeacherPTAPageState extends State<TeacherPTAPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: const Color(0xFFDBC0B6),
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Top header
           Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Back text
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Text(
          "< Back",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      const SizedBox(height: 6),

      // PTA row with button

Row(
  children: [
    Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFF2E3192), // Dark blue background
        borderRadius: BorderRadius.circular(3),
      ),
      child: SvgPicture.asset(
        'assets/icons/pta.svg', // Path to your PTA SVG file
        width: 18,
        height: 20,
        color: Colors.white, // Make SVG icon white
      ),
    ),
    const SizedBox(width: 4),
    const Text(
      "PTA",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
         color: const Color(0xFF2E3192),
      ),
    ),
    const Spacer(),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AnnounceMeetingPage(),
          ),
        );
      },
      child: const Text(
        "Announce a meeting",
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    ),
  ],
)
 ],
  ),
)
,
            const SizedBox(height: 6),

            // White tab container
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Tab Bar
                    TabBar(
                      controller: _tabController,
                      indicatorColor:  Color(0xFF29ABE2),
                   labelColor: const Color(0xFF29ABE2),

                      unselectedLabelColor: Colors.black54,
                      labelStyle: const TextStyle(fontSize: 13),
                      tabs: const [
                        Tab(text: "Next Meeting"),
                        Tab(text: "History"),
                        Tab(text: "People"),
                      ],
                    ),
                    const Divider(height: 1),

                    // Tab Views
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Next Meeting
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                SizedBox(height: 10),
                                Text(
                                  "2, Nov. 2019, 2 pm",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "For classes\n8, 9 , 10\nAll divisions",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, "
                                  "sed diam nonummy nibh euismod tincidunt ut laoreet "
                                  "dolore magna aliquam erat volutpat. Ut wisi enim ad "
                                  "minim veniam, quis nostrud exerci tation",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),

                          // History
                          ListView(
                            padding: const EdgeInsets.all(20),
                            children: const [
                              _HistoryItem(
                                  date: "2, Apr 2019, 2 pm",
                                  classes: "8, 9 , 10"),
                              Divider(),
                              _HistoryItem(
                                  date: "2, Jan.2019, 2 pm",
                                  classes: "8, 9 , 10"),
                            ],
                          ),

                          // People
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("President",
                                    style: TextStyle(fontSize: 14)),
                                Text("Name",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(height: 10),
                                Text("Secretary",
                                    style: TextStyle(fontSize: 14)),
                                Text("Name",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 10),
const SizedBox(height: 10),
Padding(
  padding: const EdgeInsets.only(bottom: 20.0), // extra bottom space
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text(
        "Executive members",
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(height: 4),
      Text(
        "Name 1",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 2),
      
      Text(
        "Name 2",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 2),
      Text(
        "Name 3",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 2),
      Text(
        "Name 4",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ],
  ),
),

                              ],
                            ),
                          ),
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

class _HistoryItem extends StatelessWidget {
  final String date;
  final String classes;

  const _HistoryItem({
    Key? key,
    required this.date,
    required this.classes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500)),
        Text("For classes\n$classes\nAll divisions",
            style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
