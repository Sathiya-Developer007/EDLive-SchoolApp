import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // 👈 SVG support
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import '/models/student_library_book.dart';
import '/services/student_library_book_service.dart';
import 'student_library_book_detail_page.dart';
import 'package:school_app/services/student_library_checkout_service.dart';

class StudentLibraryPage extends StatefulWidget {
  const StudentLibraryPage({super.key});

  @override
  State<StudentLibraryPage> createState() => _StudentLibraryPageState();
}

class _StudentLibraryPageState extends State<StudentLibraryPage>
    with SingleTickerProviderStateMixin {
  final StudentLibraryCheckoutService _service = StudentLibraryCheckoutService();
  late Future<List<StudentLibraryBook>> _allBooks;

  @override
  void initState() {
    super.initState();
    _allBooks = _service.fetchAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      body: Container(
        color: const Color(0xFFACCFE2),
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

            // 🔹 Title row (icon + text)
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

            // 🔹 White container with Tabs
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                margin: const EdgeInsets.only(top: 90),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      // TabBar
                      TabBar(
                        labelColor: const Color(0xFF2E3192),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color(0xFF2E3192),
                        tabs: const [
                          Tab(text: "All Books"),
                          Tab(text: "My Books"),
                          Tab(text: "History"),
                        ],
                      ),

                      // Tab Views
                      Expanded(
                        child: TabBarView(
                          children: [
                            // 🔹 Tab 1: All Books (API data)
                            FutureBuilder<List<StudentLibraryBook>>(
                              future: _allBooks,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text("Error: ${snapshot.error}"));
                                }
                                final books = snapshot.data ?? [];
                                if (books.isEmpty) {
                                  return const Center(
                                      child: Text("No books found."));
                                }
                                return ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: books.length,
                                  itemBuilder: (context, index) {
                                    final book = books[index];
                                    return Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      margin:
                                          const EdgeInsets.only(bottom: 16),
                                      child: ListTile(
                                        leading: const Icon(Icons.menu_book,
                                            color: Colors.green),
                                        title: Text(
                                          book.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          "Author: ${book.author}\n"
                                          "Genre: ${book.genre}\n"
                                          "Location: ${book.location}",
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "Available: ${book.availableQuantity}/${book.quantity}"),
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  StudentBookDetailPage(
                                                      bookId: book.id),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),

                            // 🔹 Tab 2: My Books (placeholder)
                            const Center(child: Text("My Books list here")),

                            // 🔹 Tab 3: History (placeholder)
                            const Center(child: Text("History list here")),
                          ],
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
}
