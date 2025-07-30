import 'package:flutter/material.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'teacher_menu_drawer.dart';

class TeacherExamPage extends StatefulWidget {
  const TeacherExamPage({super.key});

  @override
  State<TeacherExamPage> createState() => _TeacherExamPageState();
}

class _TeacherExamPageState extends State<TeacherExamPage>
    with SingleTickerProviderStateMixin {
  String selectedClass = '10A';
  late TabController _tabController;

  final List<String> classes = ['10A', '10B', '10C'];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC9F4E5),
       drawer:const MenuDrawer(), 
      appBar: TeacherAppBar(),
       body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Text(
                  'Select your class',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedClass,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedClass = value);
                    }
                  },
                  items: classes
                      .map((cls) =>
                          DropdownMenuItem(value: cls, child: Text(cls)))
                      .toList(),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue,
              labelColor: Colors.black,
              tabs: const [
                Tab(text: 'Class tests'),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Other Exams'),
                      SizedBox(width: 4),
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.purple,
                        child: Text(
                          '1',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildClassTestsTab(),
                const Center(child: Text('Other Exams Coming Soon')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassTestsTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Text('Announce a class test'),
          ),
          const SizedBox(height: 20),
          _buildUpcomingTestCard(),
          const SizedBox(height: 20),
          _buildPastTestCard(),
        ],
      ),
    );
  }

  Widget _buildUpcomingTestCard() {
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Next class test\n12 Sep.2019, 11.15 am',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text(
              'English 1',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
              'sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat vo',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.black54),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildPastTestCard() {
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '20, Oct. 2019',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              'English 1',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
              'sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat vo',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.black54),
          onPressed: () {},
        ),
      ),
    );
  }
}
