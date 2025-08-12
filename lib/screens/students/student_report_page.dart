import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';


 final ValueNotifier<String> selectedTerm = ValueNotifier<String>("Final");
 
class StudentReportPage extends StatelessWidget {
  const StudentReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      body: Column(
        children: [
         
          // Pink Report Section
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFFDCFD0),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: const [
                          // Icon(Icons.arrow_back, size: 18, color: Colors.black),
                          SizedBox(width: 4),
                          Text("< Back", style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Report Header
                   Row(
  children: [
    Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Color(0xFF2E3192), // Background color
        // shape: BoxShape.circle,   // Makes it circular
      ),
      child: SvgPicture.asset(
        "assets/icons/reports.svg",
        height: 32,
        
        color: Colors.white, // Makes the icon white on dark background
      ),
    ),
    const SizedBox(width: 6),
    const Text(
      "Report",
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E3192), // Updated text color
      ),
    ),
  ],
)
,
                    const SizedBox(height: 6),
                    const Text(
                      "Grades & Marks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF2E3192),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Grade, Average Score, Class Rank
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _ReportStat(title: "Grade", value: "A"),
                        _ReportStat(title: "Average Score", value: "82%"),
                        _ReportStat(title: "Class Rank", value: "5/40"),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Term Dropdown + Table
                  Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: Colors.grey.shade300),
  ),
  child: Column(
    children: [
      // Term row with dropdown
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Term"),
            ValueListenableBuilder<String>(
              valueListenable: selectedTerm,
              builder: (context, value, _) {
                return Container(
                  height: 32, // slightly smaller height
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF4D4D4D)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<String>(
                    value: value,
                    underline: const SizedBox(),
                    isExpanded: false,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color(0xFF808080)),
                    style: const TextStyle(
                      color: Color(0xFF4D4D4D),
                      fontSize: 14,
                    ),
                    items: const [
                      DropdownMenuItem(value: "Final", child: Text("Final")),
                      DropdownMenuItem(value: "Mid", child: Text("Mid")),
                    ],
                    onChanged: (newValue) {
                      if (newValue != null) {
                        selectedTerm.value = newValue;
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // Divider line
      Container(height: 1, color: Colors.grey.shade300),

      // Table Header
      Container(
        color: Colors.grey.shade200,
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Subject", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Practical", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      // Table Rows
      _buildRow("Mathematics", "90"),
      _buildRow("Science", "85"),
      _buildRow("English", "78"),
      _buildRow("History", "85"),
      _buildRow("Tamil", "82"),

      // Total
     Container(
  color: const Color(0xFFEAEAEA), // Background color
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const [
      Text(
        "Total",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black, // Keep black text for contrast
        ),
      ),
      Text(
        "420",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black, // Keep black text for contrast
        ),
      ),
    ],
  ),
)

    ],
  ),
)
,
                    const SizedBox(height: 12),

                    // // Remove from dashboard
                    // Center(
                    //   child: Text(
                    //     "× Remove from dashboard",
                    //     style: TextStyle(
                    //       color: Colors.red.shade700,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRow(String subject, String marks) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subject),
          Text(marks),
        ],
      ),
    );
  }
}

class _ReportStat extends StatelessWidget {
  final String title;
  final String value;

  const _ReportStat({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF2E3192),)),
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
               color: Color(0xFF666666)),),
      ],
    );
  }
}
