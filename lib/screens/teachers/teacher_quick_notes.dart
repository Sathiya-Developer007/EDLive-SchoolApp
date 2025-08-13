import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

class TeacherQuickNotesPage extends StatelessWidget {
  const TeacherQuickNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color(0xFFE6E6E6),
      drawer: MenuDrawer(),
      appBar: TeacherAppBar(),
      body: Column(
        children: [
          // Combined Top Section (Top Bar + Header Row)
          Container(
            // color: Colors.white,
           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),

            child: Column(
              children: [
                // Top Bar Row
                    const SizedBox(height: 12),

                // Header Row (Back + Title + Add)
             // Header Row (Back + Title below)
Padding(
padding: const EdgeInsets.only(left: 5, right: 15, top: 0, bottom: 0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Back button with icon on right
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Row(
              children: [
                SizedBox(width: 2, height: 0),
                Text(
                  '< Back',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
          
         Row(
  mainAxisAlignment: MainAxisAlignment.end, // move to right side
  children: [
    TextButton.icon(
      onPressed: () {
        // Add icon click action here
      },
      icon: const Icon(
        Icons.add_circle_outline,
        color: Color(0xFF29ABE2), // updated color
        size: 20,
      ),
      label: const Text(
        'Add',
        style: TextStyle(
          color: Color(0xFF29ABE2), // matching text color
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  ],
)

        ],
      ),
      const SizedBox(height: 10),

      // Icon with background and title below
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: Color(0xFF2E3192),
            ),
            child: SvgPicture.asset(
              'assets/icons/quick_notes.svg',
              height: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Quick Notes',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3192),
            ),
          ),
        ],
      ),
    ],
  ),
)
  ],
            ),
          ),
          const SizedBox(height: 10),

          // Notes List
     Expanded(
  child: Container(
    margin: const EdgeInsets.only(bottom: 15,right: 12,left: 12), // ⬅ 10px gap at bottom
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        _noteItem("Maths Formulas"),
        _noteItem("Physics: Current Electricity Diagrams"),
        _noteItem("History: Important Dates & Events"),
        _noteItem("The French Revolution"),
        _noteItem("Maths The Making of a Global World"),
        _noteItem("Chemistry: Periodic Table Trends"),
        _noteItem("English Grammer Rules"),
        _noteItem("Tenses: Usage and Examples"),
        _noteItem("Civics: Types of Agriculture"),
        _noteItem("Economics: Five year plans"),
      ],
    ),
  ),
)

          ,
        ],
      ),
    );
  }

  Widget _noteItem(String title) {
    return Container(
      
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF2E3192),
            decoration: TextDecoration.underline,
          ),
        ),
        contentPadding: const EdgeInsets.only(left: 10, right: 0),

        trailing: const Icon(Icons.chevron_right, color: Colors.black54),
        onTap: () {
          // Open note detail
        },
      ),
    );
  }
}
