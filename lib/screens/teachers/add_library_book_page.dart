import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/library_book.dart';
import '../../../models/library_book_copy.dart';
import '../../../models/library_member.dart';

import '../../../providers/library_provider.dart';
import '../../../providers/library_copy_provider.dart';
import '../../../providers/library_member_provider.dart';

import '../../../widgets/teacher_app_bar.dart';
import '../teachers/teacher_menu_drawer.dart';

class AddLibraryBookPage extends StatefulWidget {
  const AddLibraryBookPage({super.key});

  @override
  State<AddLibraryBookPage> createState() => _AddLibraryBookPageState();
}

class _AddLibraryBookPageState extends State<AddLibraryBookPage> {
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

  return Scaffold(
    appBar: TeacherAppBar(),
    drawer: const MenuDrawer(),
    body: Container(
      color: const Color(0xFFACCFE2), // background color
      child: Stack(
        children: [
          /// White container with forms
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20), // fixed 20px space around
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// BOOK FORM
                      Form(
                        key: _formKeyBook,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Add New Book",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
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
                            bookProvider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ElevatedButton.icon(
                                    onPressed: _submitBook,
                                    icon: const Icon(Icons.add),
                                    label: const Text("Add Book"),
                                  ),
                          ],
                        ),
                      ),
                      const Divider(height: 40, thickness: 2),

                      /// COPY FORM
                      Form(
                        key: _formKeyCopy,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Add Book Copy",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            _buildTextField(_bookIdController, "Book ID",
                                keyboard: TextInputType.number),
                            _buildTextField(_barcodeController, "Barcode"),
                            _buildTextField(_conditionController,
                                "Condition (e.g., new/good/old)"),
                            const SizedBox(height: 12),
                            copyProvider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ElevatedButton.icon(
                                    onPressed: _submitCopy,
                                    icon: const Icon(Icons.add),
                                    label: const Text("Add Copy"),
                                  ),
                          ],
                        ),
                      ),
                      const Divider(height: 40, thickness: 2),

                      /// MEMBER FORM
                      Form(
                        key: _formKeyMember,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Add Library Member",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            _buildTextField(_userIdController, "User ID",
                                keyboard: TextInputType.number),
                            _buildTextField(_userTypeController,
                                "User Type (student/teacher)"),
                            _buildTextField(_membershipNumberController,
                                "Membership Number"),
                            _buildTextField(_membershipStartController,
                                "Membership Start (YYYY-MM-DD)"),
                            _buildTextField(_membershipEndController,
                                "Membership End (YYYY-MM-DD)"),
                            _buildTextField(_maxBooksController, "Max Books",
                                keyboard: TextInputType.number),
                            const SizedBox(height: 12),
                            memberProvider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ElevatedButton.icon(
                                    onPressed: _submitMember,
                                    icon: const Icon(Icons.person_add),
                                    label: const Text("Add Member"),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// Back Button (top-left outside white box)
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  "< Back",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
              ),
            ),
          ),
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
