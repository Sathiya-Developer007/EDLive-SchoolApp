import 'package:flutter/material.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart'; 


class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: StudentMenuDrawer(), // or your custom drawer
        appBar: CustomAppBar(
          onProfileTap: () {
            Navigator.pushNamed(context, '/student-profile');
          },
        ),
        body: Column(
          children: [
            // Top Profile Section
            Container(
              width: double.infinity,
              color: const Color(0xFF2E99EF),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ), // 👈 Reduced vertical padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '< Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6), // 👈 Reduced spacing
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 60, // 👈 Reduced profile picture size
                          backgroundImage: AssetImage(
                            'assets/images/child1.jpg',
                          ),
                        ),
                        const SizedBox(height: 6), // 👈 Reduced spacing
                        const Text(
                          'Student Name',
                          style: TextStyle(
                            fontSize: 18, // optional: slightly smaller
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            const TabBar(
  isScrollable: false, // ⬅️ Ensures equal spacing (default)
  labelColor: Color(0xFF29ABE2),
  unselectedLabelColor: Colors.black54,
  indicatorColor: Color(0xFF29ABE2),
  labelStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14, // Optional adjustment
  ),
  tabs: [
    Tab(text: 'Basic Info'),
    Tab(text: 'Parent/Guardian'),
    Tab(text: 'Documents'),
  ],
),


            // Tab Views
            Expanded(
              child: TabBarView(
                children: [
                  // Basic Info Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoText("Age:", "42"),
                        _infoText("Occupation:", "IT professional"),
                        _infoText("Mobile:", "+91 99506347823"),
                        _infoText("Email ID:", "sgfhgfsdf@gmail.com"),
                        const SizedBox(height: 10),
                        const Text(
                          "Address",
                          style: TextStyle(
                            color: Color(0xFF000000), // Black title
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _smallText("1/57, Gandhi Nagar,\nAlangulam,\nTenkasi."),

                        const SizedBox(height: 16),
                        const Divider(),
                        const Text(
                          "School Info",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000), // Pure black
                            fontSize: 16, // Increased font size
                          ),
                        ),
                        _infoText("Joining date:", "01, June 2017"),
                        _infoText("Class joined:", "LKG"),
                        _infoText("Previous school:", "N.A"),
                        _infoText("Class teacher:", "Mrs. Teacher name"),
                        _infoText("email:", "hgfsfjh@gmail.com"),
                        _infoText("Mobile:", "+91 4786655090"),
                        const SizedBox(height: 16),
                        const Divider(),
                        const Text(
                          "Health details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000), // Pure black
                            fontSize: 16, // Increased font size
                          ),
                        ),
                        _infoText("Any illness:", "01, June 2017"),
                        _infoText("Allergy info:", "Dust allergy"),
                      ],
                    ),
                  ),

                  // Parent/Guardian Tab
              SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        height: 30,
        color: Color(0xFF2E3192),
        alignment: Alignment.center,
        child: const Text(
          'Parents',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(height: 16),
      _parentCard("Mr. Parent Name", "Father"),
      // const SizedBox(height: 0), // 👈 push the Mother block further down
      _parentCard("Mrs. Parent Name", "Mother"),
    ],
  ),
),
// Documents Tab
SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      SizedBox(height: 40), // 👈 Push all content lower on screen

      Text(
        "Student’s ID/Passport",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 15),
      Text(
        "No: 45675789790898",
        style: TextStyle(
          color: Color(0xFF29ABE2),
        ),
      ),
      SizedBox(height: 24),

      Text(
        "Parent’s ID/Passport",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 15),
      Text(
        "No: 45675789790898",
        style: TextStyle(
          color: Color(0xFF29ABE2),
        ),
      ),
      SizedBox(height: 40), // 👈 Bottom padding
    ],
  ),
),
],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoText(String title, String value) {
    // Only highlight value color for 'Mobile' and 'Email ID'
    final isBlueValue =
        title.trim().toLowerCase().contains('mobile') ||
        title.trim().toLowerCase().contains('email');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D4D4D), // Title color
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isBlueValue
                    ? Color(0xFF29ABE2)
                    : Color(0xFF4D4D4D), // Value color
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallText(String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        value,
        style: const TextStyle(
          color: Color(0xFF000000), // Pure black for address content
        ),
      ),
    );
  }
Widget _parentCard(String name, String role) {
  final isFather = role.toLowerCase() == "father";

  return Container(
    padding: const EdgeInsets.fromLTRB(8, 20, 8, 16),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: isFather
        ? const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          )
        : null,
    child: Stack(
      children: [
        // 👤 Parent Content
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24), // Space for the icon
            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 76),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E3192),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "($role)",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            _infoText("Age:", "42"),
            _infoText("Nationality:", "Indian"),
            _infoText("Occupation:", "T professional"),
            _infoText("Mobile:", "+91 9956347823"),
            _infoText("Email ID:", "sghfgdfsd@gmail.com"),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Address",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "1/57, Gandhi Nagar,\nAlangulam,\nTenkasi.",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),

        // ✏️ Edit Icon (SVG at top-left)
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // TODO: Add your edit logic here
              print("Edit $role");
            },
            child: SvgPicture.asset(
              'assets/icons/pencil.svg', // Ensure this file exists and is in pubspec.yaml
              height: 20,
              width: 20,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}}
