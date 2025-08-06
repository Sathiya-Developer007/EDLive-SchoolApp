import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

class StudentPaymentsPage extends StatefulWidget {
  const StudentPaymentsPage({Key? key}) : super(key: key);

  @override
  State<StudentPaymentsPage> createState() => _StudentPaymentsPageState();
}

class _StudentPaymentsPageState extends State<StudentPaymentsPage> {
  bool isDueSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7E59E),
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Padding(
  padding: const EdgeInsets.only(top: 1, left: 0, right: 16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Text(
          '< Back',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Container(
           padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
decoration: BoxDecoration(
  color: Color(0xFF2E3192),
  borderRadius: BorderRadius.circular(4),
),
child: SvgPicture.asset(
  'assets/icons/payments.svg',
  width: 20,
  height: 17,
  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
),

          ),
          const SizedBox(width: 8),
          const Text(
            "Payments",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3192), // Updated title color
            ),
          ),
        ],
      ),
    ],
  ),
),

            ),

            // Tab Section
           Expanded(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 30), // Add 20 bottom space
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your tab row (Due / History)
        Row(
  children: [
    GestureDetector(
      onTap: () => setState(() => isDueSelected = true),
      child: Column(
        children: [
          Text(
            "Due",
            style: TextStyle(
              color: isDueSelected ? Color(0xFF29ABE2) : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          if (isDueSelected)
            Container(
              height: 3, // underline thickness
              width: 30, // adjust width as needed
              color: const Color(0xFF29ABE2),
            ),
        ],
      ),
    ),
    const SizedBox(width: 40),
    GestureDetector(
      onTap: () => setState(() => isDueSelected = false),
      child: Column(
        children: [
          Text(
            "History",
            style: TextStyle(
              color: !isDueSelected ? Color(0xFF29ABE2) : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          if (!isDueSelected)
            Container(
              height: 3,
              width: 50,
              color: const Color(0xFF29ABE2),
            ),
        ],
      ),
    ),
  ],
),
   const SizedBox(height: 20),
          // This lets the section below scroll/fill the height
          Expanded(
            child: isDueSelected ? _buildDueSection() : _buildHistorySection(),
          ),
        ],
      ),
    ),
  ),
),
   ],
        ),
      ),
    );
  }

Widget _buildDueSection() {
  return Align(
    alignment: Alignment.topCenter,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30), // ⬅️ Top space increased
        const Text(
          "Due on , Mar. 2018",
          style: TextStyle(
            color: Color(0xFF3D348B),
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          "Fee Rs. 2500",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {},
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Pay", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}

 Widget _buildHistorySection() {
  return SingleChildScrollView(
    child: Table(
      border: TableBorder.all(
        color: Colors.grey,
        width: 1.2,
      ),
      columnWidths: const {
        0: FlexColumnWidth(2), // Payment Info
        1: FlexColumnWidth(1.5), // Amount
        2: FlexColumnWidth(1.5), // Date
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Header row
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
          children: const [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Payment info',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Amount',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        // Data rows
        _buildTableRow('Fee - term 2', 'Rs. 25000', '2-8-2019'),
        _buildTableRow('Fee - term 1', 'Rs. 25000', '2-9-2019'),
        _buildTableRow('Books', 'Rs. 6000', '2-9-2019'),
        _buildTableRow('Uniform', 'Rs. 2000', '2-9-2019'),
      ],
    ),
  );
}

TableRow _buildTableRow(String info, String amount, String date) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(info),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(amount),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(date),
      ),
    ],
  );
}
}
