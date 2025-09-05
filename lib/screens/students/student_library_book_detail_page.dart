import 'dart:convert';
import 'package:flutter/material.dart';
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
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
    return DefaultTabController(
      length: 2, // Info + Copies
      child: Scaffold(
        appBar: const StudentAppBar(),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _bookDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final book = snapshot.data!["book"] as StudentLibraryBook;
            final copies = snapshot.data!["copies"] as List<StudentLibraryCopy>;

            return Column(
              children: [
                // TabBar
                Material(
                  color: const Color(0xFF2E3192),
                  child: const TabBar(
                    indicatorColor: Colors.yellow,
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
                      // Info Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        color: Colors.green)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Copies Tab
                      ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: copies.length,
                        itemBuilder: (context, index) {
                          final copy = copies[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading:
                                  const Icon(Icons.qr_code, color: Colors.blue),
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
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
