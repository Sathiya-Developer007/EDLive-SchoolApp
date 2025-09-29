import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:school_app/models/pta_next_meeting_model.dart';
import 'package:school_app/services/pta_next_meeting_service.dart';

import 'package:school_app/models/pta_history_model.dart';
import 'package:school_app/services/pta_history_service.dart';

import 'package:school_app/models/pta_member_model.dart';
import 'package:school_app/services/pta_member_service.dart';


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

                    const SizedBox(height: 15),

                    // Tab Views
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Next Meeting
FutureBuilder<List<PTAMeeting>>(
  future: PTAService().getUpcomingMeetings(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No upcoming meetings'));
    } else {
      final meetings = snapshot.data!;
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          final meeting = meetings[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                meeting.title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                meeting.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              // Date & Time
              Text(
                '${meeting.date.day}-${meeting.date.month}-${meeting.date.year}, ${meeting.time}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              // Classes
              Text(
                'For classes: ${meeting.classNames?.join(", ")}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Divider(), // optional separator between meetings
              const SizedBox(height: 16),
            ],
          );
        },
      );
    }
  },
),


                          // History
                         FutureBuilder<List<PTAHistory>>(
  future: PTAHistoryService().getHistory(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No past meetings'));
    } else {
      final history = snapshot.data!;
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final meeting = history[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                meeting.title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                meeting.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Text(
                '${meeting.date.day}-${meeting.date.month}-${meeting.date.year}, ${meeting.time}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'For classes: ${meeting.classNames?.join(", ")}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
            ],
          );
        },
      );
    }
  },
),

                          // People
FutureBuilder<List<PTAMember>>(
  future: PTAMemberService().getMembers(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No members found'));
    } else {
      final members = snapshot.data!;
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.position,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                member.name,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      );
    }
  },
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
