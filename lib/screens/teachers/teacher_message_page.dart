import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

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
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          'assets/icons/message.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Message',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Card Section
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                children: [
                                  TextFormField(
                                    controller: studentSearchController,
                                    decoration: const InputDecoration(
                                      labelText:
                                          "Enter student ID No, or parent's mobile number",
                                      border: OutlineInputBorder(),
                                    ),
                                    onTap: closeAccordion,
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),

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
            backgroundColor: Colors.grey[400]),
        onPressed: () {},
        child: const Text("Cancel"),
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue),
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
         ] ),
        ),
      ),
    )));
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
