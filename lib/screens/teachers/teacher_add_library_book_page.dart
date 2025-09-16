import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:school_app/models/teacher_student_classsection.dart';
import '../../models/teacher_library_book.dart';
import '../../models/teacher_library_book_copy.dart';
import '../../models/teacher_library_member.dart';

import '../../providers/teacher_library_provider.dart';
import '../../providers/teacher_library_copy_provider.dart';
import '../../providers/teacher_library_member_provider.dart';
import 'package:school_app/providers/library_status_provider.dart';
import 'package:school_app/providers/library_books_list_provider.dart';
import 'package:school_app/providers/library_book_detail_provider.dart';

import 'package:school_app/services/library_book_search_service.dart';
import 'package:school_app/services/teacher_student_classsection.dart';


import '../../../widgets/teacher_app_bar.dart';
import '../teachers/teacher_menu_drawer.dart';

class AddLibraryBookPage extends StatefulWidget {
  const AddLibraryBookPage({super.key});

  @override
  State<AddLibraryBookPage> createState() => _AddLibraryBookPageState();
}

class _AddLibraryBookPageState extends State<AddLibraryBookPage>
    with SingleTickerProviderStateMixin {
  int? selectedBookId;
  List<dynamic> searchResults = [];

  late TabController _tabController;

    String? _authToken;

  

  // Search controllers
  final _searchTitleController = TextEditingController();
  final _searchAuthorController = TextEditingController();
  final _searchIsbnController = TextEditingController();
  final _searchGenreController = TextEditingController();

  // Form keys
  final _formKeyBook = GlobalKey<FormState>();
  final _formKeyCopy = GlobalKey<FormState>();
  final _formKeyMember = GlobalKey<FormState>();

  // Book controllers
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _publisherController = TextEditingController();
  final _yearController = TextEditingController();
  final _genreController = TextEditingController();
  final _quantityController = TextEditingController();
  final _locationController = TextEditingController();

  // Copy controllers
  final _bookIdController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _conditionController = TextEditingController();

  // Member controllers
  final _userIdController = TextEditingController();
  final _userTypeController = TextEditingController();
  final _membershipNumberController = TextEditingController();
  final _membershipStartController = TextEditingController();
  final _membershipEndController = TextEditingController();
  final _maxBooksController = TextEditingController();
@override
void initState() {
  super.initState();
  _tabController = TabController(length: 6, vsync: this);
  _loadTokenAndData();

  _tabController.addListener(() async {
    if (!_tabController.indexIsChanging) {
      // When All Books tab is selected
      if (_tabController.index == 2) {
        final provider = Provider.of<LibraryBooksListProvider>(context, listen: false);
        await provider.fetchBooks();

        // ✅ Mark each book as viewed only when All Books tab is opened
        for (var book in provider.books) {
          if (book["id"] != null) {
            _markLibraryViewed(book["id"].toString());
          }
        }
      }

      // When Member Status tab is selected
      if (_tabController.index == 3) {
        Provider.of<LibraryStatusProvider>(context, listen: false)
            .fetchStatus();
      }
    }
  });
}

  @override
  void dispose() {
    _tabController.dispose();

    _searchTitleController.dispose();
    _searchAuthorController.dispose();
    _searchIsbnController.dispose();
    _searchGenreController.dispose();

    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _publisherController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    _quantityController.dispose();
    _locationController.dispose();

    _bookIdController.dispose();
    _barcodeController.dispose();
    _conditionController.dispose();

    _userIdController.dispose();
    _userTypeController.dispose();
    _membershipNumberController.dispose();
    _membershipStartController.dispose();
    _membershipEndController.dispose();
    _maxBooksController.dispose();

    super.dispose();
  }


  Future<void> _markLibraryViewed(String bookId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(
        'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/dashboard/viewed',
      ),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "item_type": "library", // 👈 use library
        "item_id": bookId,
      }),
    );

    if (response.statusCode == 200) {
      print("✅ Marked book $bookId as viewed");
    } else {
      print("❌ Failed: ${response.body}");
    }
  } catch (e) {
    print("⚠️ Error: $e");
  }
}


Future<void> _loadTokenAndData() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  setState(() => _authToken = token);

  // ❌ remove auto-marking books here
  // final provider = Provider.of<LibraryBooksListProvider>(context, listen: false);
  // await provider.fetchBooks();
  // for (var book in provider.books) {
  //   if (book["id"] != null) {
  //     _markLibraryViewed(book["id"].toString());
  //   }
  // }
}

  /// Submit Book
  Future<void> _submitBook() async {
    if (!_formKeyBook.currentState!.validate()) return;

    final book = LibraryBook(
      title: _titleController.text,
      author: _authorController.text,
      isbn: _isbnController.text,
      publisher: _publisherController.text,
      publicationYear: int.tryParse(_yearController.text) ?? 0,
      genre: _genreController.text,
      quantity: int.tryParse(_quantityController.text) ?? 0,
      availableQuantity: int.tryParse(_quantityController.text) ?? 0,
      location: _locationController.text,
    );

    final provider = Provider.of<LibraryProvider>(context, listen: false);
    final success = await provider.addBook(book);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book added successfully ✅")),
      );
      _clearBookFields();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${provider.error ?? "Unknown error"}")),
      );
    }
  }

  /// Submit Copy
  Future<void> _submitCopy() async {
    if (!_formKeyCopy.currentState!.validate()) return;

    final copy = LibraryBookCopy(
      bookId: int.tryParse(_bookIdController.text) ?? 0,
      barcode: _barcodeController.text,
      condition: _conditionController.text,
    );

    final provider = Provider.of<LibraryCopyProvider>(context, listen: false);
    final success = await provider.addCopy(copy);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book copy added successfully ✅")),
      );
      _clearCopyFields();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${provider.error ?? "Unknown error"}")),
      );
    }
  }

  /// Submit Member
  Future<void> _submitMember() async {
    if (!_formKeyMember.currentState!.validate()) return;

    final member = LibraryMember(
      userId: int.tryParse(_userIdController.text) ?? 0,
      userType: _userTypeController.text,
      membershipNumber: _membershipNumberController.text,
      membershipStart: _membershipStartController.text,
      membershipEnd: _membershipEndController.text,
      maxBooks: int.tryParse(_maxBooksController.text) ?? 0,
    );

    final provider = Provider.of<LibraryMemberProvider>(context, listen: false);
    final success = await provider.addMember(member);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Member added successfully ✅")),
      );
      _clearMemberFields();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${provider.error ?? "Unknown error"}")),
      );
    }
  }

  // ----------------- Clear fields -----------------
  void _clearBookFields() {
    _titleController.clear();
    _authorController.clear();
    _isbnController.clear();
    _publisherController.clear();
    _yearController.clear();
    _genreController.clear();
    _quantityController.clear();
    _locationController.clear();
  }

  void _clearCopyFields() {
    _bookIdController.clear();
    _barcodeController.clear();
    _conditionController.clear();
  }

  void _clearMemberFields() {
    _userIdController.clear();
    _userTypeController.clear();
    _membershipNumberController.clear();
    _membershipStartController.clear();
    _membershipEndController.clear();
    _maxBooksController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TeacherAppBar(),
      drawer: const MenuDrawer(),
      body: Container(
        color: const Color(0xFFACCFE2),
        child: Stack(
          children: [
            // Back Button
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

            // Search Button
            Positioned(
              top: 35,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.search,
                    color: Color(0xFF2E3192), size: 40),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Search Books"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildTextField(_searchTitleController, "Title"),
                            _buildTextField(_searchAuthorController, "Author"),
                            _buildTextField(_searchIsbnController, "ISBN"),
                            _buildTextField(_searchGenreController, "Genre"),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      ElevatedButton(
  onPressed: () async {
    Navigator.pop(context); // close the search dialog first
    try {
      final books = await LibraryApiService.searchBooks(
        title: _searchTitleController.text,
        author: _searchAuthorController.text,
        isbn: _searchIsbnController.text,
        genre: _searchGenreController.text,
      );

      setState(() => searchResults = books);

      if (books.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No books found")),
        );
        return;
      }

      if (books.length == 1) {
        // Only one book found → directly show details
        final book = books.first;
        selectedBookId = book.id;
        await Provider.of<LibraryBookDetailProvider>(context, listen: false)
            .fetchBook(book.id);
        _tabController.animateTo(1); // go to Book Details tab
      } else {
        // Multiple books → show selection dialog
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Select Book"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: books.length,
                itemBuilder: (_, index) {
                  final book = books[index];
                  return ListTile(
                    title: Text(book.title ?? '-'),
                    subtitle: Text(book.author ?? '-'),
                    onTap: () async {
                      selectedBookId = book.id;
                      await Provider.of<LibraryBookDetailProvider>(context, listen: false)
                          .fetchBook(book.id);
                      _tabController.animateTo(1);
                      Navigator.pop(context); // close selection dialog
                    },
                  );
                },
              ),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2E3192),
    foregroundColor: Colors.white,
  ),
  child: const Text("Search"),
),
 ],
                    ),
                  );
                },
              ),
            ),

            // Title Row
            Positioned(
              top: 45,
              left: 16,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration:
                        const BoxDecoration(color: Color(0xFF2E3192)),
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

            // White Tab Container
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                margin: const EdgeInsets.only(top: 90),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor:  Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor:  Colors.blue,
                      tabs: const [
                        Tab(text: "Add Book"),
                        Tab(text: "Book Details"),
                        Tab(text: "All Books"),
                        Tab(text: "Member Status"),
                        Tab(text: "Add Copy"),
                        Tab(text: "Add Member"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: _buildAddBookForm(),
                          ),
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: _buildBookDetails(),
                          ),
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: _buildBooksList(),
                          ),
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: _buildMemberStatus(),
                          ),
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: _buildAddCopyForm(),
                          ),
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: _buildAddMemberForm(),
                          ),
                        ],
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

  // ----------------- Helper widgets -----------------

Widget _buildBooksList() {
  final provider = Provider.of<LibraryBooksListProvider>(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (provider.isLoading)
        const Center(child: CircularProgressIndicator())
      else if (provider.error != null)
        Text("Error: ${provider.error}")
      else if (provider.books.isNotEmpty)
        ...provider.books.map((book) => ListTile(
              leading:
                  const Icon(Icons.book_outlined, color: Color(0xFF2E3192)),
              title: Text(book["title"] ?? '-'),
              subtitle: Text("Author: ${book["author"] ?? '-'}"),
              trailing: Text("Qty: ${book["available_quantity"] ?? 0}"),
              onTap: () {
                setState(() {
                  selectedBookId = book["id"];
                });
                Provider.of<LibraryBookDetailProvider>(context, listen: false)
                    .fetchBook(book["id"]);
                _tabController.animateTo(1); // 🔥 switch to Book Details
              },
            ))
      else
        const Text("No books available"),
    ],
  );
}

  Widget _buildBookDetails() {
    final provider = Provider.of<LibraryBookDetailProvider>(context);
    final detail = provider.bookDetail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (provider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (provider.error != null)
          Text("Error: ${provider.error}")
        else if (detail != null) ...[
          Text("Title: ${detail['title'] ?? '-'}"),
          Text("Author: ${detail['author'] ?? '-'}"),
          Text("ISBN: ${detail['isbn'] ?? '-'}"),
          Text("Publisher: ${detail['publisher'] ?? '-'}"),
          Text("Available Qty: ${detail['available_quantity'] ?? 0}"),
          const SizedBox(height: 12),
          const Text("Copies:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...((detail['copies'] ?? []) as List<dynamic>).map((copy) {
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading:
                  const Icon(Icons.qr_code, color: Color(0xFF2E3192)),
              title: Text("Barcode: ${copy['barcode'] ?? '-'}"),
              subtitle: Text("Condition: ${copy['condition'] ?? '-'}"),
              trailing: Text(copy['status'] ?? '-'),
            );
          }).toList(),
        ] else
          const Text("No book details available"),
      ],
    );
  }
Widget _buildMemberStatus() {
  final provider = Provider.of<LibraryStatusProvider>(context);
  final data = provider.statusData;

  if (provider.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (provider.error != null) {
    return Center(child: Text("Error: ${provider.error}"));
  }

 if (data == null) {
  return const Center(child: Text("No status data available"));
}

final member = data as Map<String, dynamic>;

return Container(
  margin: const EdgeInsets.all(12),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade300,
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        member['member']?['student_name'] ?? '-',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
      const SizedBox(height: 8),
      Text("Membership #: ${member['member']?['membership_number'] ?? '-'}"),
      Text("Checkouts: ${member['checkoutCount'] ?? 0}"),
      Text("Reservations: ${member['reservationCount'] ?? 0}"),
      Text("Fines: ₹${member['fineAmount'] ?? 0}"),
    ],
  ),
);
}


  Widget _buildAddBookForm() {
    final provider = Provider.of<LibraryProvider>(context);
    return Form(
      key: _formKeyBook,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(_titleController, "Book Title"),
          _buildTextField(_authorController, "Author"),
          _buildTextField(_isbnController, "ISBN"),
          _buildTextField(_publisherController, "Publisher"),
          _buildTextField(_yearController, "Publication Year",
              keyboard: TextInputType.number),
          _buildTextField(_genreController, "Genre"),
          _buildTextField(_quantityController, "Quantity",
              keyboard: TextInputType.number),
          _buildTextField(_locationController, "Location"),
          const SizedBox(height: 12),
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton.icon(
                  onPressed: _submitBook,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Book"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E3192),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
        ],
      ),
    );
  }

Widget _buildAddCopyForm() {
  final provider = Provider.of<LibraryCopyProvider>(context);
  final booksProvider = Provider.of<LibraryBooksListProvider>(context);

  // Ensure books list is fetched
  if (booksProvider.books.isEmpty && !booksProvider.isLoading) {
    booksProvider.fetchBooks();
  }

  return Form(
    key: _formKeyCopy,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        booksProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Select Book",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: booksProvider.books.map((book) {
                  return DropdownMenuItem<int>(
                    value: book["id"],
                    child: Text(book["title"] ?? "Untitled"),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _bookIdController.text = value.toString();
                  }
                },
                validator: (val) {
                  if (val == null) return "Please select a book";
                  return null;
                },
              ),
        const SizedBox(height: 12),
        _buildTextField(_barcodeController, "Barcode"),
        _buildTextField(_conditionController, "Condition"),
        const SizedBox(height: 12),
        provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton.icon(
                onPressed: _submitCopy,
                icon: const Icon(Icons.add),
                label: const Text("Add Copy"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
      ],
    ),
  );
}

Widget _buildAddMemberForm() {
  final provider = Provider.of<LibraryMemberProvider>(context);

  return FutureBuilder<List<StudentClassSection>>(
    future: StudentService().fetchStudents(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      }

      final students = snapshot.data ?? [];

      return Form(
        key: _formKeyMember,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: "Select Student",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: students.map((student) {
                return DropdownMenuItem<int>(
                  value: student.id,
                  child: Text(
                    "${student.name} (${student.admissionNo})",
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _userIdController.text = value.toString();
                  _userTypeController.text = "student"; // default type
                }
              },
              validator: (val) {
                if (val == null) return "Please select a student";
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(_membershipNumberController, "Membership Number"),
            _buildTextField(
                _membershipStartController, "Membership Start (YYYY-MM-DD)"),
            _buildTextField(
                _membershipEndController, "Membership End (YYYY-MM-DD)"),
            _buildTextField(_maxBooksController, "Max Books",
                keyboard: TextInputType.number),
            const SizedBox(height: 12),
            provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: _submitMember,
                    icon: const Icon(Icons.person_add),
                    label: const Text("Add Member"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
          ],
        ),
      );
    },
  );
}

  /// Reusable TextField Builder
  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboard = TextInputType.text, bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (val) {
          if (required && (val == null || val.isEmpty)) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }
}
