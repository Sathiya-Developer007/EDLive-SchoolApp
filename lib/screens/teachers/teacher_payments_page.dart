import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';

import 'package:school_app/models/teacher_payment_model.dart';
import 'package:school_app/services/teacher_payment_service.dart';

class TeacherPaymentsPage extends StatefulWidget {
  const TeacherPaymentsPage({super.key});

  @override
  State<TeacherPaymentsPage> createState() => _TeacherPaymentsPageState();
}

class _TeacherPaymentsPageState extends State<TeacherPaymentsPage> {
 List<PaymentAssignment> payments = [];
  bool isLoading = true;

 @override
void initState() {
  super.initState();
  loadData();
}

Future<void> loadData() async {
  setState(() => isLoading = true);

  final classIds = await fetchAssignedClasses();
  if (classIds.isEmpty) {
    setState(() {
      payments = [];
      isLoading = false;
    });
    return;
  }

  await fetchPayments();
}


  // List<PaymentAssignment> payments = [];

  Future<List<int>> fetchAssignedClasses() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token'); // assuming you store auth token

    final response = await http.get(
      Uri.parse('http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/staff/staff/teacher/class'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token', // if auth required
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<int>((item) => item['class_id'] as int).toList();
    } else {
      throw Exception('Failed to load classes');
    }
  } catch (e) {
    print("Error fetching classes: $e");
    return [];
  }
}


Future<void> fetchPayments() async {
  try {
    // Step 1: Get teacher's assigned classes
    final teacherClasses = await TeacherClassService.fetchTeacherClasses();
    final classIds = teacherClasses.map((c) => c.classId).toList();

    // Step 2: Call payment API for these classes
    final data = await PaymentService.fetchPaymentAssignments(
      classIds: classIds,
      academicYear: '2025-2026',
    );

    setState(() {
      payments = data;
      isLoading = false;
    });
  } catch (e) {
    setState(() => isLoading = false);
    print("Error: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7E59E),
      appBar: TeacherAppBar(),
      drawer: const MenuDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : payments.isEmpty
                          ? const Center(child: Text("No payment data found."))
                          : ListView.separated(
                              itemCount: payments.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final item = payments[index];
                                return _buildPaymentTile(item);
                              },
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: const Text(
              '< Back',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3192),
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
                  color: Color(0xFF2E3192),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

 Widget _buildPaymentTile(PaymentAssignment item) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Fee Name & Class
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.feeName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Class ${item.className}-${item.section}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color(0xFF2E3192),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Amount and Due Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Amount: ₹${item.baseAmount}",
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                "Due: ${item.dueDate.split('T')[0]}",
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Pending Students
          if (item.pendingCount > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pending Students (${item.pendingCount}):",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                ...item.pendingStudents.map((s) => Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 2),
                      child: Text(
                        "- ${s.fullName} (${s.admissionNo})",
                        style: const TextStyle(fontSize: 13),
                      ),
                    )),
              ],
            ),

          /// Pay Button
          // const SizedBox(height: 10),
          // if (item.upiLink != null && item.upiLink!.isNotEmpty)
          //   Align(
          //     alignment: Alignment.centerRight,
          //     child: ElevatedButton.icon(
          //       onPressed: () {
          //         // Add functionality to launch UPI URL
          //       },
          //       icon: const Icon(Icons.payment),
          //       label: const Text("Pay Now"),
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: const Color(0xFF2E3192),
          //         foregroundColor: Colors.white,
          //         padding: const EdgeInsets.symmetric(
          //             horizontal: 20, vertical: 12),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    ),
  );
}
}