import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';

import 'package:school_app/models/class_section.dart';
import 'package:school_app/services/class_section_service.dart';
import 'package:school_app/models/teacher_payment_model.dart';
import 'package:school_app/services/teacher_payment_service.dart';

class TeacherPaymentsPage extends StatefulWidget {
  const TeacherPaymentsPage({super.key});

  @override
  State<TeacherPaymentsPage> createState() => _TeacherPaymentsPageState();
}

class _TeacherPaymentsPageState extends State<TeacherPaymentsPage> {
  List<ClassSection> classSections = [];
  int? selectedClassId;
  bool isLoading = true;

  String selectedAcademicYear = '2025-2026';
  List<PaymentAssignment> payments = [];

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      final fetchedClasses = await ClassService().fetchClassSections();
      setState(() {
        classSections = fetchedClasses;
        selectedClassId = fetchedClasses.isNotEmpty ? fetchedClasses[0].id : null;
      });

      if (selectedClassId != null) {
        await fetchPayments();
      }
    } catch (e) {
      print("Error fetching class sections: $e");
    }
  }

  Future<void> fetchPayments() async {
    if (selectedClassId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token'); // saved during login

    if (token == null) {
      print("Auth token not found.");
      return;
    }

    final url = Uri.parse(
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/payments/assignments?class_ids=$selectedClassId&academic_year=$selectedAcademicYear',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
       final Map<String, dynamic> result = json.decode(response.body);
final List<dynamic> data = result['data'];
final parsedPayments = data.map((json) => PaymentAssignment.fromJson(json)).toList();

        print("Parsed payment count: ${parsedPayments.length}");

        setState(() {
          payments = parsedPayments;
          isLoading = false;
        });
      } else {
        print("Failed to load payments: ${response.statusCode} - ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching payments: $e");
      setState(() {
        isLoading = false;
      });
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Select Class:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E3192),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                DropdownButton<int>(
                                  value: selectedClassId,
                                  items: classSections.map((classItem) {
                                    return DropdownMenuItem<int>(
                                      value: classItem.id,
                                      child: Text(classItem.fullName),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedClassId = value;
                                      isLoading = true;
                                    });
                                    fetchPayments();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            Expanded(
                              child: payments.isEmpty
                                  ?Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 8),
      const Text("No payment data found."),
    ],
  ),
)

                                  : ListView.builder(
                                      itemCount: payments.length,
                                      itemBuilder: (context, index) =>
                                          _buildPaymentTile(payments[index]),
                                    ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  ...item.pendingStudents.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 2),
                      child: Text(
                        "- ${s.fullName} (${s.admissionNo})",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
