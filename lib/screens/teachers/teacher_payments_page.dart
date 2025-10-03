import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';

import 'package:school_app/models/teacher_payment_model.dart';
import 'package:school_app/services/teacher_payment_service.dart';
import 'package:school_app/providers/teacher_dashboard_provider.dart';

class TeacherPaymentsPage extends StatefulWidget {
  const TeacherPaymentsPage({super.key});

  @override
  State<TeacherPaymentsPage> createState() => _TeacherPaymentsPageState();
}

class _TeacherPaymentsPageState extends State<TeacherPaymentsPage> {
  List<PaymentAssignment> payments = [];
  bool isLoading = true;

  late PageController _pageController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTab);
    loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    try {
      final teacherClasses = await TeacherClassService.fetchTeacherClasses();
      final classIds = teacherClasses.map((c) => c.classId).toList();

      final data = await PaymentService.fetchPaymentAssignments(
        classIds: classIds,
        academicYear: '2025-2026',
      );

      setState(() {
        payments = data;
        isLoading = false;
      });

      // Mark dashboard items as viewed
      final dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      for (var payment in data) {
        dashboardProvider.markDashboardItemViewed(payment.id);
      }
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
      // Header: back button + icon + title
      _buildHeader(),

      const SizedBox(height: 16),

      // White container with tab bar + payment content
      Expanded(
  child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        // Tab Bar (Payment fees)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(payments.length, (index) {
              final item = payments[index];
              return GestureDetector(
                onTap: () => _onTabTapped(index),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _selectedTab == index ? Colors.blue.shade50 : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.feeName, // Tab title
                    style: TextStyle(
                      color: _selectedTab == index ? Colors.blue : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 12),

        // PageView content for selected payment
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _selectedTab = index),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final item = payments[index];
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab Title inside container
                    Text(
                      item.feeName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3192),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Payment tile content
                    _buildPaymentTile(item),
                  ],
                ),
              );
            },
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
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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

  Widget _buildPaymentList(PaymentAssignment item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        itemCount: 1, // only this fee
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => _buildPaymentTile(item),
      ),
    );
  }

  Widget _buildPaymentTile(PaymentAssignment item) {
    return Card(
  color: Colors.white, // ✅ ensures the container is white
  elevation: 3,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            /// Fee Name & Class
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                //   child: Text(
                //     item.feeName,
                //     style: const TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //       color: Color(0xFF2E3192),
                //     ),
                //   ),
                // ),
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
                      fontSize: 15,
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
                Text("Amount: ₹${item.baseAmount}",
                    style: const TextStyle(fontSize: 15)),
                Text(
                  "Due: ${item.dueDate.split('T')[0]}",
                  style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.redAccent),
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
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  ...item.pendingStudents.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 2),
                      child: Text("- ${s.fullName} (${s.admissionNo})",
                          style: const TextStyle(fontSize: 13)),
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
