import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';
import 'package:school_app/models/teacher_class_student.dart';
import 'package:school_app/services/teacher_class_student_list.dart';

class TeacherMessagePage extends StatefulWidget {
  const TeacherMessagePage({super.key});

  @override
  State<TeacherMessagePage> createState() => _TeacherMessagePageState();
}

class _TeacherMessagePageState extends State<TeacherMessagePage> {
  String? selectedTo;
  bool showAccordion = false;
  bool sendSMS = false;
  bool sendWhatsApp = false;
  bool sendEmail = false;

  final TextEditingController studentSearchController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

// Example student data
// List<Map<String, String>> allStudents = [
//   {"name": "John Doe", "id": "1234", "class": "2A", "mobile": "9734567892"},
//   {"name": "Jane Smith", "id": "5678", "class": "3B", "mobile": "9876543210"},
// ];

// List<Map<String, String>> searchResults = [];
// List<Map<String, String>> selectedStudents = [];
// // Add this above `searchResults`:
// List<Student> allStudents = [];
List<Student> allStudents = [];
List<Student> searchResults = [];
List<Map<String, dynamic>> selectedStudents = [];




void onSearch(String value) {
  final query = value.toLowerCase();

  setState(() {
    searchResults = allStudents.where((s) {
      return s.studentName.toLowerCase().contains(query) ||
             s.id.toString().contains(query) ;
            //  (s.mobile ?? '').contains(query);
    }).toList();
  });
}

void toggleStudentSelection(Map<String, String> student) {
  setState(() {
    if (selectedStudents.contains(student)) {
      selectedStudents.remove(student);
    } else {
      selectedStudents.add(student);
    }
  });
}

Widget buildStudentTile(Student student) {
  final isSelected = selectedStudents.any((s) => s["id"] == student.id);

  return ListTile(
    onTap: () {
      setState(() {
        if (isSelected) {
          selectedStudents.removeWhere((s) => s["id"] == student.id);
        } else {
          selectedStudents.add({
            "id": student.id,
            "name": student.studentName,
            "class": student.className,
            // "mobile": student.mobile,
          });
        }
      });
    },
    title: Text(student.studentName),
    subtitle: Text("ID: ${student.id}, Class: ${student.className}"),
    trailing: Checkbox(
      value: isSelected,
      onChanged: (_) {
        if (isSelected) {
          selectedStudents.removeWhere((s) => s["id"] == student.id);
        } else {
          selectedStudents.add({
            "id": student.id,
            "name": student.studentName,
            "class": student.className,
            // "mobile": student.mobile,
          });
        }
      },
    ),
  );
}


void showStudentDetails(Student student) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(student.studentName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ID: ${student.id}"),
          Text("Class: ${student.className}"),
          // If you have mobile or parent's contact in Student model, add it here
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}

  // Class & division selection state
  final Map<String, List<bool>> classSelections = {
    "LKG": List.generate(7, (_) => false),
    "UKG": List.generate(7, (_) => false),
    for (int i = 1; i <= 12; i++) "$i": List.generate(7, (_) => false),
  };

  void toggleDivision(String className, int index) {
    setState(() {
      classSelections[className]![index] = !classSelections[className]![index];
    });
  }

  void toggleWholeClass(String className) {
    setState(() {
      bool allSelected = classSelections[className]!.every((s) => s);
      for (int i = 0; i < 7; i++) {
        classSelections[className]![i] = !allSelected;
      }
    });
  }

  bool isClassChecked(String className) {
    return classSelections[className]!.contains(true);
  }

  void closeAccordion() {
    if (showAccordion) {
      setState(() {
        showAccordion = false;
      });
    }
  }

@override
void initState() {
  super.initState();
  fetchAllStudents();
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token'); // key used when saving login token
}

Future<void> fetchAllStudents() async {
  try {
    final token = await getToken(); // get token from SharedPreferences
    if (token == null) return;

    final students = await StudentService.fetchStudents(token);
    setState(() {
      allStudents = students;
      searchResults = []; // start empty
    });
  } catch (e) {
    debugPrint("Error fetching students: $e");
  }
}

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: closeAccordion,
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: Colors.pink[100],
        appBar: TeacherAppBar(),
        drawer: MenuDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back and Title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button row
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "< Back",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Icon + Title row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              6,
                            ), // space inside background

                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF2E3192,
                              ), // background color
                              // borderRadius: BorderRadius.circular(6),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/message.svg',
                              width: 20,
                              height: 20,
                              color: Colors.white, // make icon white
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Message',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3192),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Card Section
                 Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
child:Container(
  height: MediaQuery.of(context).size.height - 200, // fixed height for container
  margin: const EdgeInsets.only(bottom: 20), // exactly 20px bottom space
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
  ),
  child: Scrollbar( // optional, for better UX
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your data
          Text(
            "Write message History",
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

                          // To Dropdown
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'To',
                              border: OutlineInputBorder(),
                            ),
                            value: selectedTo,
                            items: const [
                              DropdownMenuItem(
                                value: 'Specific Classes',
                                child: Text('Specific Classes'),
                              ),
                              DropdownMenuItem(
                                value: 'Select a group',
                                child: Text('Select a group'),
                              ),
                            ],
                            onChanged: (val) {
                              setState(() {
                                selectedTo = val;
                                showAccordion = val == "Specific Classes";
                              });
                            },
                          ),
                          const SizedBox(height: 12),

                          // Select Classes Accordion
                          if (showAccordion) _buildAccordion(),

                          const SizedBox(height: 15),

                          const Divider(thickness: 1),
                          const SizedBox(height: 10),
                          const Center(
                            child: Text(
                              "OR",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Student Search
                          // Student Search (only show when 'Select a group' is chosen)
                       if (selectedTo == 'Select a group')
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    TextFormField(
      controller: studentSearchController,
      decoration: const InputDecoration(
        labelText: "Student's name, ID No, or parent's mobile number",
        border: OutlineInputBorder(),
      ),
      onChanged: onSearch,
    ),
    const SizedBox(height: 10),

    // Show matching results
    ...searchResults.map(buildStudentTile).toList(),

    const SizedBox(height: 10),

    // Show selected students list
    if (selectedStudents.isNotEmpty)
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: selectedStudents.map((student) {
          return Chip(
            label: Text(student["name"] ?? ""),
            deleteIcon: const Icon(Icons.close),
            onDeleted: () {
              setState(() {
                selectedStudents.remove(student);
              });
            },
          );
        }).toList(),
      ),
  ],
)
,
                          // Compose
                          TextFormField(
                            controller: messageController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: "Type your message here",
                              border: OutlineInputBorder(),
                            ),
                            onTap: closeAccordion,
                          ),
                          const SizedBox(height: 15),

                          // Send options
                          Row(
                            children: [
                              Checkbox(
                                value: sendSMS,
                                onChanged: (val) =>
                                    setState(() => sendSMS = val!),
                              ),
                              const Text("SMS"),
                              const SizedBox(width: 8),
                              Checkbox(
                                value: sendWhatsApp,
                                onChanged: (val) =>
                                    setState(() => sendWhatsApp = val!),
                              ),
                              const Text("Whatsapp"),
                              const SizedBox(width: 8),
                              Checkbox(
                                value: sendEmail,
                                onChanged: (val) =>
                                    setState(() => sendEmail = val!),
                              ),
                              const Text("Email"),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // File Upload
                          // File Upload
                          // File Upload
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text("Select file"),
                          ),
                          const SizedBox(height: 8),
                          const Text("Document.pdf"),
                          const Text("Image.jpg"),
                          const SizedBox(height: 20),

                          // Buttons moved inside white container
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[400],
                                  ),
                                  onPressed: () {},
                                  child: const Text("Cancel"),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {},
                                  child: const Text("Send"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
               ) )],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccordion() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Classes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          ...classSelections.keys
              .map((className) => _buildClassCheckboxRow(className))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildClassCheckboxRow(String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: isClassChecked(label),
          onChanged: (_) => toggleWholeClass(label),
        ),
        SizedBox(width: 30, child: Text(label)),
        Expanded(
          child: Wrap(
            spacing: 6,
            children: List.generate(7, (index) {
              return GestureDetector(
                onTap: () => toggleDivision(label, index),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: classSelections[label]![index]
                        ? Colors.blue
                        : Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: TextStyle(
                      color: classSelections[label]![index]
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
