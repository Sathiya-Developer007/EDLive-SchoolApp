import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



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

  /// Form keys
  final _formKeyBook = GlobalKey<FormState>();
  final _formKeyCopy = GlobalKey<FormState>();
  final _formKeyMember = GlobalKey<FormState>();

  /// Book Controllers
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _publisherController = TextEditingController();
  final _yearController = TextEditingController();
  final _genreController = TextEditingController();
  final _quantityController = TextEditingController();
  final _locationController = TextEditingController();

  /// Copy Controllers
  final _bookIdController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _conditionController = TextEditingController();

  /// Member Controllers
  final _userIdController = TextEditingController();
  final _userTypeController = TextEditingController();
  final _membershipNumberController = TextEditingController();
  final _membershipStartController = TextEditingController();
  final _membershipEndController = TextEditingController();
  final _maxBooksController = TextEditingController();


  @override
  void dispose() {
    // Book
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _publisherController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    _quantityController.dispose();
    _locationController.dispose();

    // Copy
    _bookIdController.dispose();
    _barcodeController.dispose();
    _conditionController.dispose();

    // Member
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


// static Future<bool> addBook(Map<String, dynamic> bookData) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString("auth_token");
//   // Add at the top of the file or in a constants file
// const String baseUrl = "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api";


//   final response = await http.post(
//     Uri.parse("$baseUrl/books"), // now baseUrl is defined
//     headers: {
//       "accept": "application/json",
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $token",
//     },
//     body: jsonEncode(bookData),
//   );

//   return response.statusCode == 201;
// }



void _showSearchDialog(BuildContext context) {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final isbnController = TextEditingController();
  final genreController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Search Books"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(titleController, "Title"),
              _buildTextField(authorController, "Author"),
              _buildTextField(isbnController, "ISBN"),
              _buildTextField(genreController, "Genre"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E3192),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                final books = await LibraryApiService.searchBooks(
                  title: titleController.text,
                  author: authorController.text,
                  isbn: isbnController.text,
                  genre: genreController.text,
                );

                Navigator.pop(context); // close popup

                if (books.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No books found ❌")),
                  );
                } else {
                  // Store in state to display
                setState(() {
  searchResults = books;
});


                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Found ${books.length} books ✅")),
                  );
                }
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text("Search"),
          ),
        ],
      );
    },
  );
}



  /// Clear Book fields
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

  /// Clear Copy fields
  void _clearCopyFields() {
    _bookIdController.clear();
    _barcodeController.clear();
    _conditionController.clear();
  }

  /// Clear Member fields
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
  final bookProvider = Provider.of<LibraryProvider>(context);
  final copyProvider = Provider.of<LibraryCopyProvider>(context);
  final memberProvider = Provider.of<LibraryMemberProvider>(context);
    final statusProvider = Provider.of<LibraryStatusProvider>(context);
final booksListProvider = Provider.of<LibraryBooksListProvider>(context);
final bookDetailProvider = Provider.of<LibraryBookDetailProvider>(context);


  return Scaffold(
    appBar: TeacherAppBar(),
    drawer: const MenuDrawer(),
   body: Container(
  color: const Color(0xFFACCFE2), // background color
  padding: const EdgeInsets.all(20), // fixed 20px space around
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// BACK BUTTON
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            "< Back",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),

      /// PAGE TITLE
   Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: Row(
    children: [
      /// CIRCULAR BACKGROUND WITH LIBRARY ICON
      Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFF2E3192), // background color
          // shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          'assets/icons/library.svg', // your library icon
          width: 20,
          height: 20,
          color: Colors.white, // make icon white
        ),
      ),
      const SizedBox(width: 8),

      /// TITLE
      const Text(
        "Library",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E3192), // #2E3192
        ),
      ),
    ],
  ),
),

      /// WHITE CONTAINER
    Expanded(
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.grey.shade300,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        ElevatedButton(
  onPressed: () {
    _showSearchDialog(context);
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2E3192),
    foregroundColor: Colors.white,
  ),
  child: const Text("Search Books"),
),

/// 👉 Add search results card here
if (searchResults.isNotEmpty)
  Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.only(top: 16, bottom: 24),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Search Results",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3192),
            ),
          ),
          const SizedBox(height: 12),
          ...searchResults.map((book) {
            return ListTile(
              leading: const Icon(Icons.book, color: Color(0xFF2E3192)),
              title: Text(book["title"] ?? "Untitled"),
              subtitle: Text("Author: ${book["author"] ?? "Unknown"}"),
              trailing: Text("Qty: ${book["available_quantity"] ?? 0}"),
              onTap: () {
                setState(() {
                  selectedBookId = book["id"];
                });

                final bookDetailProvider =
                    Provider.of<LibraryBookDetailProvider>(
                  context,
                  listen: false,
                );
                bookDetailProvider.fetchBook(book["id"]);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selected: ${book["title"]}")),
                );
              },
            );
          }).toList(),
        ],
      ),
    ),
  ),

          /// BOOK FORM CARD
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKeyBook,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.book, color: Color(0xFF2E3192)),
                        SizedBox(width: 8),
                        Text(
                          "Add New Book",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3192),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    bookProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _submitBook,
                              icon: const Icon(Icons.add),
                              label: const Text("Add Book"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E3192),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),

/// BOOK DETAIL CARD
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  margin: const EdgeInsets.only(bottom: 24),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.menu_book, color: Color(0xFF2E3192)),
            SizedBox(width: 8),
            Text(
              "Book Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3192),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (bookDetailProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (bookDetailProvider.error != null)
          Text("Error: ${bookDetailProvider.error}")
        else if (bookDetailProvider.bookDetail != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title: ${bookDetailProvider.bookDetail!['title']}"),
              Text("Author: ${bookDetailProvider.bookDetail!['author']}"),
              Text("ISBN: ${bookDetailProvider.bookDetail!['isbn']}"),
              Text("Publisher: ${bookDetailProvider.bookDetail!['publisher']}"),
              Text("Available Qty: ${bookDetailProvider.bookDetail!['available_quantity']}"),
              const SizedBox(height: 12),
              const Text(
                "Copies:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...((bookDetailProvider.bookDetail!['copies'] as List<dynamic>)
                  .map((copy) => ListTile(
                        leading: const Icon(Icons.qr_code,
                            color: Color(0xFF2E3192)),
                        title: Text("Barcode: ${copy['barcode']}"),
                        subtitle: Text("Condition: ${copy['condition']}"),
                        trailing: Text(copy['status']),
                      ))),
            ],
          )
        else
          const Text("No book details available"),

        const SizedBox(height: 12),
     ElevatedButton(
  onPressed: () {
    if (selectedBookId != null) {
      bookDetailProvider.fetchBook(selectedBookId!);
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
    ),
  ),
),


/// BOOKS LIST CARD
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  margin: const EdgeInsets.only(bottom: 24),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child:Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: const [
        Icon(Icons.library_books, color: Color(0xFF2E3192)),
        SizedBox(width: 8),
        Text(
          "All Active Books",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E3192),
          ),
        ),
      ],
    ),
    const SizedBox(height: 16),

    if (booksListProvider.isLoading)
      const Center(child: CircularProgressIndicator())
    else if (booksListProvider.error != null)
      Text("Error: ${booksListProvider.error}")
    else if (booksListProvider.books.isNotEmpty)
      Column(
        children: booksListProvider.books.map((book) {
          return ListTile(
            leading: const Icon(Icons.book_outlined, color: Color(0xFF2E3192)),
            title: Text(book["title"]),
            subtitle: Text("Author: ${book["author"]}"),
            trailing: Text("Qty: ${book["available_quantity"]}"),
            onTap: () {
              /// store selected bookId
              setState(() {
                selectedBookId = book["id"];
              });

              /// fetch book details
              final bookDetailProvider = Provider.of<LibraryBookDetailProvider>(
                context,
                listen: false,
              );
              bookDetailProvider.fetchBook(book["id"]);
            },
          );
        }).toList(),
      )
    else
      const Text("No books available"),

    const SizedBox(height: 12),
    ElevatedButton(
      onPressed: () {
        booksListProvider.fetchBooks(); // fetch all books
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2E3192),
        foregroundColor: Colors.white,
      ),
      child: const Text("Fetch Books"),
    ),
  ],
)
 ),
),



/// MEMBER STATUS CARD
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  margin: const EdgeInsets.only(bottom: 24),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.info, color: Color(0xFF2E3192)),
            SizedBox(width: 8),
            Text(
              "Member Status",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3192),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Data display
        if (statusProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (statusProvider.error != null)
          Text("Error: ${statusProvider.error}")
        else if (statusProvider.statusData != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Member: ${statusProvider.statusData!['member']['student_name']}"),
              Text("Membership #: ${statusProvider.statusData!['member']['membership_number']}"),
              Text("Checkouts: ${statusProvider.statusData!['checkoutCount']}"),
              Text("Reservations: ${statusProvider.statusData!['reservationCount']}"),
              Text("Fines: ₹${statusProvider.statusData!['fineAmount']}"),
            ],
          )
        else
          const Text("No status data available"),
        
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            statusProvider.fetchStatus(); // fetch latest
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E3192),
            foregroundColor: Colors.white,
          ),
          child: const Text("Fetch Status"),
        ),
      ],
    ),
  ),
),

          /// COPY FORM CARD
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKeyCopy,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.qr_code, color: Color(0xFF2E3192)),
                        SizedBox(width: 8),
                        Text(
                          "Add Book Copy",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3192),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_bookIdController, "Book ID",
                        keyboard: TextInputType.number),
                    _buildTextField(_barcodeController, "Barcode"),
                    _buildTextField(
                        _conditionController, "Condition (e.g., new/good/old)"),
                    const SizedBox(height: 16),
                    copyProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _submitCopy,
                              icon: const Icon(Icons.add),
                              label: const Text("Add Copy"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),

          /// MEMBER FORM CARD
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKeyMember,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.person, color: Color(0xFF2E3192)),
                        SizedBox(width: 8),
                        Text(
                          "Add Library Member",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3192),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_userIdController, "User ID",
                        keyboard: TextInputType.number),
                    _buildTextField(
                        _userTypeController, "User Type (student/teacher)"),
                    _buildTextField(
                        _membershipNumberController, "Membership Number"),
                    _buildTextField(_membershipStartController,
                        "Membership Start (YYYY-MM-DD)"),
                    _buildTextField(_membershipEndController,
                        "Membership End (YYYY-MM-DD)"),
                    _buildTextField(_maxBooksController, "Max Books",
                        keyboard: TextInputType.number),
                    const SizedBox(height: 16),
                    memberProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _submitMember,
                              icon: const Icon(Icons.person_add),
                              label: const Text("Add Member"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
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
  ),
)

 ],
  ),
),
);
}

  /// Reusable TextField Builder
  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboard = TextInputType.text}) {
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
          if (val == null || val.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }
}

