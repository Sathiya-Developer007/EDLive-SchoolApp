import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/student_library_book.dart';
import '/models/student_library_copy.dart';
import '/services/student_library_checkout_service.dart';
import '/widgets/student_app_bar.dart';

class StudentBookDetailPage extends StatefulWidget {
  final int bookId;
  const StudentBookDetailPage({super.key, required this.bookId});

  @override
  State<StudentBookDetailPage> createState() => _StudentBookDetailPageState();
}

class _StudentBookDetailPageState extends State<StudentBookDetailPage> {
  final StudentLibraryCheckoutService _service = StudentLibraryCheckoutService();
  late Future<Map<String, dynamic>> _bookDetails;

  @override
  void initState() {
    super.initState();
    _bookDetails = _service.fetchBookDetails(widget.bookId);
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> _checkoutCopy(StudentLibraryCopy copy) async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getInt('student_id');

    if (studentId == null) {
      _showMessage("Student not logged in");
      return;
    }

    final now = DateTime.now();
    final dueDate = now.add(const Duration(days: 7));

    final success = await _service.checkoutBook(
      bookCopyId: copy.id,
      memberId: studentId,
      checkoutDate: now.toIso8601String(),
      dueDate: dueDate.toIso8601String(),
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book checked out successfully")),
      );
      setState(() {
        _bookDetails = _service.fetchBookDetails(widget.bookId); // refresh
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Checkout failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  StudentAppBar(),
      drawer: StudentMenuDrawer(),
      body: Container(
       color: Color(0xFFACCFE2),

        child: Stack(
          children: [
            // 🔹 Back Button
            Positioned(
              top: 12,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  "< Back",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),

            // 🔹 Title Row (icon + Library)
            Positioned(
              top: 45,
              left: 16,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E3192),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/library.svg",
                      height: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Library",
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3192),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 White Content Container
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                margin: const EdgeInsets.only(top: 90),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _bookDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    final book = snapshot.data!["book"] as StudentLibraryBook;
                    final copies =
                        snapshot.data!["copies"] as List<StudentLibraryCopy>;

                    return DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          // TabBar
                         Material(
  color: Colors.white, // keep background white inside container
  child: const TabBar(
    labelColor: Colors.blue,        // 🔹 active tab text blue
    unselectedLabelColor: Colors.grey,   // 🔹 inactive tab grey
    indicatorColor: Colors.blue,   // 🔹 indicator line blue
    tabs: [
      Tab(text: "Info"),
      Tab(text: "Copies"),
    ],
  ),
),

                          // TabBarView
                          Expanded(
                            child: TabBarView(
                              children: [
                                // 🔹 Info Tab
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(book.title,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                          const SizedBox(height: 8),
                                          Text("Author: ${book.author}"),
                                          Text("Publisher: ${book.publisher}"),
                                          Text("Year: ${book.publicationYear}"),
                                          Text("Genre: ${book.genre}"),
                                          Text("Location: ${book.location}"),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Available: ${book.availableQuantity}/${book.quantity}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // 🔹 Copies Tab
                              copies.isEmpty
    ? const Center(
        child: Text(
          'No Copies in this Book',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            // color: Colors.grey,
          ),
        ),
      )
    : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: copies.length,
        itemBuilder: (context, index) {
          final copy = copies[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.qr_code, color: Colors.blue),
              title: Text("Barcode: ${copy.barcode}"),
              subtitle: Text("Condition: ${copy.condition}"),
              trailing: copy.status == "Available"
                  ? ElevatedButton(
                      onPressed: () => _checkoutCopy(copy),
                      child: const Text("Checkout"),
                    )
                  : Text(
                      copy.status,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
            ),
          );
        },
      )
  ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
