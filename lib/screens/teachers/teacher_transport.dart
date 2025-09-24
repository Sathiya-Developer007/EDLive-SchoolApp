import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'teacher_menu_drawer.dart';

class TransportPage extends StatelessWidget {
  const TransportPage({super.key});

  Widget buildInfoRow(String label, String value, {String? value2}) {
    return Container(
      width: double.infinity, // Full width
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: value2 == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                Text(
                  value2,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
      body: Container(
        color: const Color(0xFFCCCCFF),
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  '<Back',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 8),
Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Container(
      padding: const EdgeInsets.all(6), // space inside background
      decoration: BoxDecoration(
        color: const Color(0xFF2E3192), // background color
        // shape: BoxShape.circle, // makes it circular
      ),
      child: SvgPicture.asset(
        'assets/icons/transport.svg', // your SVG path
        height: 20,
        width: 20,
        color: Colors.white, // icon color (white inside blue bg)
      ),
    ),
    const SizedBox(width: 10),
    const Text(
      'Transport',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E3192),
      ),
    ),
  ],
)
,
              const SizedBox(height: 20),

              // Full-width white containers
              buildInfoRow("Bus ID", "002"),
              buildInfoRow("Bus Number", "TN38 B 1234"),
              buildInfoRow("Driver", "Divakar", value2: "+91 894 012 3456"),
              buildInfoRow("Attendant   Staff", "Kimi",
                  value2: "+91 895 012 3456"),

              // Pick-up / Drop Time (two full-width containers stacked)
              buildInfoRow("Pick-up Time", "8.30 AM"),
              buildInfoRow("Drop Time", "4.30 PM"),

              // Pick-up / Drop Location
              buildInfoRow("Pick-up Location", "Gandhipuram"),
              buildInfoRow("Drop Location", "Hopes"),
            ],
          ),
        ),
      ),
    );
  }
}
