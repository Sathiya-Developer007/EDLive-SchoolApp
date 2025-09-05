import 'package:flutter/material.dart';
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

class _StudentLibraryPageState extends State<StudentLibraryPage> {
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
      body: FutureBuilder<List<StudentLibraryBook>>(
        future: _allBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final books = snapshot.data ?? [];
          if (books.isEmpty) {
            return const Center(child: Text("No books found."));
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
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.menu_book, color: Colors.green),
                  title: Text(
                    book.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Author: ${book.author}\n"
                    "Genre: ${book.genre}\n"
                    "Location: ${book.location}",
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            StudentBookDetailPage(bookId: book.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
