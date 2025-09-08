import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
import '../../../widgets/teacher_app_bar.dart';
import '../teachers/teacher_menu_drawer.dart';

class AddLibraryBookPage extends StatefulWidget {
  const AddLibraryBookPage({super.key});

  @override
  State<AddLibraryBookPage> createState() => _AddLibraryBookPageState();
}

class _AddLibraryBookPageState extends State<AddLibraryBookPage> {
  int? selectedBookId;
  List<dynamic> searchResults = [];

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
  void dispose() {
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
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: TeacherAppBar(),
        drawer: const MenuDrawer(),
      body: Container(
  color: const Color(0xFFACCFE2),
  child: Padding(        // <-- Add this padding
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: [
        const SizedBox(height: 12),
        // Back Button
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text("< Back", style: TextStyle(fontSize: 16, color: Colors.black)),
          ),
        ),
        const SizedBox(height: 8),
        // Title Row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Color(0xFF2E3192)),
              child: SvgPicture.asset(
                "assets/icons/library.svg",
                height: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Library",
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold, color: Color(0xFF2E3192)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const TabBar(
                  isScrollable: true,
                  labelColor: Color(0xFF2E3192),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(0xFF2E3192),
                  tabs: [
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
),
 ),
    );
  }

// ----------------- Helper widgets (paste inside _AddLibraryBookPageState) -----------------



Widget _buildSearchForm() {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(_searchTitleController, "Title"),
          _buildTextField(_searchAuthorController, "Author"),
          _buildTextField(_searchIsbnController, "ISBN"),
          _buildTextField(_searchGenreController, "Genre"),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E3192),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                final books = await LibraryApiService.searchBooks(
                  title: _searchTitleController.text,
                  author: _searchAuthorController.text,
                  isbn: _searchIsbnController.text,
                  genre: _searchGenreController.text,
                );

                setState(() {
                  searchResults = books;
                });

                if (books.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No books found ❌")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Found ${books.length} books ✅")),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text("Search"),
          ),
        ],
      ),
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
          _buildTextField(_yearController, "Publication Year", keyboard: TextInputType.number),
          _buildTextField(_genreController, "Genre"),
          _buildTextField(_quantityController, "Quantity", keyboard: TextInputType.number),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
        ],
      ),
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
          const Text("Copies:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...((detail['copies'] ?? []) as List<dynamic>).map((copy) {
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.qr_code, color: Color(0xFF2E3192)),
              title: Text("Barcode: ${copy['barcode'] ?? '-'}"),
              subtitle: Text("Condition: ${copy['condition'] ?? '-'}"),
              trailing: Text(copy['status'] ?? '-'),
            );
          }).toList(),
        ] else
          const Text("No book details available"),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            if (selectedBookId != null) {
              provider.fetchBook(selectedBookId!);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select a book first")),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E3192),
            foregroundColor: Colors.white,
          ),
          child: const Text("Fetch Book Details"),
        ),
      ],
    );
  }
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
                leading: const Icon(Icons.book_outlined, color: Color(0xFF2E3192)),
                title: Text(book["title"] ?? '-'),
                subtitle: Text("Author: ${book["author"] ?? '-'}"),
                trailing: Text("Qty: ${book["available_quantity"] ?? 0}"),
                onTap: () {
                  setState(() {
                    selectedBookId = book["id"];
                  });
                  Provider.of<LibraryBookDetailProvider>(context, listen: false)
                      .fetchBook(book["id"]);
                },
              ))
        else
          const Text("No books available"),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => provider.fetchBooks(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E3192),
            foregroundColor: Colors.white,
          ),
          child: const Text("Fetch Books"),
        ),
      ],
    );
  }
  Widget _buildMemberStatus() {
    final provider = Provider.of<LibraryStatusProvider>(context);
    final d = provider.statusData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (provider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (provider.error != null)
          Text("Error: ${provider.error}")
        else if (d != null) ...[
          Text("Member: ${d['member']?['student_name'] ?? '-'}"),
          Text("Membership #: ${d['member']?['membership_number'] ?? '-'}"),
          Text("Checkouts: ${d['checkoutCount'] ?? 0}"),
          Text("Reservations: ${d['reservationCount'] ?? 0}"),
          Text("Fines: ₹${d['fineAmount'] ?? 0}"),
        ] else
          const Text("No status data available"),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => provider.fetchStatus(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E3192),
            foregroundColor: Colors.white,
          ),
          child: const Text("Fetch Status"),
        ),
      ],
    );
}

  Widget _buildAddCopyForm() {
    final provider = Provider.of<LibraryCopyProvider>(context);
    return Form(
      key: _formKeyCopy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(_bookIdController, "Book ID", keyboard: TextInputType.number),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
        ],
      ),
    );
  }
 Widget _buildAddMemberForm() {
    final provider = Provider.of<LibraryMemberProvider>(context);
    return Form(
      key: _formKeyMember,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(_userIdController, "User ID", keyboard: TextInputType.number),
          _buildTextField(_userTypeController, "User Type"),
          _buildTextField(_membershipNumberController, "Membership Number"),
          _buildTextField(_membershipStartController, "Membership Start (YYYY-MM-DD)"),
          _buildTextField(_membershipEndController, "Membership End (YYYY-MM-DD)"),
          _buildTextField(_maxBooksController, "Max Books", keyboard: TextInputType.number),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
        ],
      ),
    );
  }
// ----------------- end of helper widgets -----------------


Widget _buildSearchResults() {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Column(
      children: searchResults.map((book) {
       return ListTile(
  leading: const Icon(Icons.book, color: Color(0xFF2E3192)),
  title: Text(book["title"] ?? "Untitled"),
  subtitle: Text("Author: ${book["author"] ?? "Unknown"}"),
  trailing: Text("Qty: ${book["available_quantity"] ?? 0}"),
  onTap: () {
    setState(() {
      selectedBookId = book["id"];
    });
  },
);
 }).toList(),
    ),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (val) {
          if (required && (val == null || val.isEmpty)) return "Please enter $label";
          return null;
        },
      ),
    );
  }}

