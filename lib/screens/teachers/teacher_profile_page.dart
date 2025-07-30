import 'package:flutter/material.dart';
import 'teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';


class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({super.key});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = [
    "Basic",
    "Responsibilities",
    "Service",
    "Education",
    "Family",
    "Documents"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

 Widget _buildHeaderWithProfile() {
  return Container(
    width: double.infinity,
    color: const Color(0xFF29ABE2),
    padding: const EdgeInsets.only(top: 20, bottom: 16,left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔙 Back Button
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Navigate back
            },
            child: const Text(
              '< Back',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),

        // 👤 Profile Picture & Name Centered
        Center(
          child: Column(
            children: const [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 70, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Mr. Ezhil Selvan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),

        // 🧭 Tab Bar
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.deepPurple,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ],
    ),
  );
}

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: " $value"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required String title, required Map<String, String> items}) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ...items.entries.map((e) => _buildDetailRow(e.key, e.value)).toList(),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Mr. Ezhil Selvan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text("B.Sc. Information Technology, B.E IT, B.Ed", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  _buildInfoRow("ID No:", "STF-001"),
                  _buildInfoRow("Gender:", "Male"),
                  _buildInfoRow("Phone:", "9876543210, 1234567890"),
                  _buildInfoRow("Email:", "ezhilselvan@gmail.com"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileCard(),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: "Personal Information",
            items: {
              "Date of Birth": "14/06/1982",
              "Age": "42",
              "Blood Group": "B+",
              "Account No.": "1234567890",
              "PAN": "XXXXXXXXXX",
              "Aadhaar No.": "XXXXXXXXXXXX",
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResponsibilitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionHeader("Class Schedule"),
          Card(
            elevation: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Class")),
                  DataColumn(label: Text("Subject")),
                  DataColumn(label: Text("Mon")),
                  DataColumn(label: Text("Tue")),
                  DataColumn(label: Text("Wed")),
                  DataColumn(label: Text("Thu")),
                  DataColumn(label: Text("Fri")),
                  DataColumn(label: Text("Sat")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text("10 A")),
                    const DataCell(Text("Mathematics")),
                    const DataCell(Text("09:45 AM")),
                    const DataCell(Text("09:45 AM")),
                    const DataCell(Text("09:45 AM")),
                    const DataCell(Text("---")),
                    const DataCell(Text("09:45 AM")),
                    const DataCell(Text("01:00 PM")),
                    DataCell(IconButton(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onPressed: () {},
                    )),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDetailCard(
            title: "Service Information",
            items: {
              "Joining Date": "01/05/2025",
              "Total Leaves": "30",
              "Used Leaves": "20",
              "Organization": "School",
              "From Date": "17/01/2021",
              "To Date": "17/12/2023",
              "Designation": "Teacher",
              "PF Number": "123548",
            },
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("PF Document", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("View PF Document"),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text("Replace"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionHeader("Education History"),
          Card(
            elevation: 3,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Degree")),
                DataColumn(label: Text("University")),
                DataColumn(label: Text("Year")),
                DataColumn(label: Text("Actions")),
              ],
              rows: [
                _buildEducationRow("B.Sc. Information Technology", "Manonmaniom Sundaranar", "2008"),
                _buildEducationRow("B.E IT", "ManonManium Sundaranor", "2003"),
                _buildEducationRow("B.Ed", "Anna University", "2010"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildEducationRow(String degree, String university, String year) {
    return DataRow(cells: [
      DataCell(Text(degree)),
      DataCell(Text(university)),
      DataCell(Text(year)),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.visibility, size: 18), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.red), onPressed: () {}),
        ],
      )),
    ]);
  }

  Widget _buildFamilyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDetailCard(
            title: "Address Information",
            items: {
              "Current Address": "Click to add",
              "Permanent Address": "Same as Current",
            },
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Family Members", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text("Add Family Member"),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_upload, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text("Upload Documents", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.attach_file),
            label: const Text("Select Files"),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.favorite_border, color: Colors.deepPurple), onPressed: () {}),
              IconButton(icon: const Icon(Icons.share, color: Colors.deepPurple), onPressed: () {}),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Edit Profile"),
          ),
        ],
      ),
    );
  }


  @override
Widget build(BuildContext context) {
  return Column(
    children: [
      // 🔲 Black top bar
      Container(
        height: 20,
        width: double.infinity,
        color: Colors.black,
      ),

      // 🏗️ Rest of the UI
      Expanded(
        child: Scaffold(
          backgroundColor: const Color(0xFF29ABE2), // updated sky blue
          drawer: const MenuDrawer(),
          appBar: TeacherAppBar(),
             body: Column(
            children: [
              _buildHeaderWithProfile(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBasicTab(),
                    _buildResponsibilitiesTab(),
                    _buildServiceTab(),
                    _buildEducationTab(),
                    _buildFamilyTab(),
                    _buildDocumentsTab(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildActionBar(),
        ),
      ),
    ],
  );
}
}
