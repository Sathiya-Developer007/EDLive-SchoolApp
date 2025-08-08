import 'package:flutter/material.dart';

class AnnounceMeetingPage extends StatefulWidget {
  const AnnounceMeetingPage({Key? key}) : super(key: key);

  @override
  State<AnnounceMeetingPage> createState() => _AnnounceMeetingPageState();
}

class _AnnounceMeetingPageState extends State<AnnounceMeetingPage> {
  String? selectedClass = '10';
  bool isAllDivision = true;
  DateTime selectedDate = DateTime(2019, 2, 2);
  TimeOfDay selectedTime = const TimeOfDay(hour: 14, minute: 0);

  bool sendSMS = true;
  bool sendWhatsApp = true;
  bool sendEmail = true;

  final TextEditingController divisionController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Announce a meeting",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Select classes dropdown
              DropdownButtonFormField<String>(
                value: selectedClass,
                decoration: const InputDecoration(
                  labelText: "Select classes",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: ["8", "9", "10"]
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedClass = val;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Division selection
        Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    // First option: Division
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Division",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<bool>(
              value: true,
              groupValue: isAllDivision,
              onChanged: (val) {
                setState(() {
                  isAllDivision = val!;
                });
              },
            ),
            const Text("All"),
          ],
        ),
      ],
    ),

    const SizedBox(width: 10), // reduced spacing

    // Second option: Enter Division
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Enter Division",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<bool>(
              value: false,
              groupValue: isAllDivision,
              onChanged: (val) {
                setState(() {
                  isAllDivision = val!;
                });
              },
            ),
        SizedBox(
  width: 60,
  height: 30, // Increased height
  child: TextField(
    controller: divisionController,
    enabled: !isAllDivision,
    textAlign: TextAlign.center,
    decoration: const InputDecoration(
      isDense: false, // allows taller height
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      border: OutlineInputBorder(),
    ),
  ),
)


          ],
        ),
      ],
    ),
  ],
)
,    const SizedBox(height: 16),

              // Date & Time
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.deepPurple),
                          onPressed: _pickDate,
                        ),
                      ),
                      controller: TextEditingController(
                        text:
                            "${selectedDate.day}, ${_monthName(selectedDate.month)} ${selectedDate.year}",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.access_time,
                              color: Colors.deepPurple),
                          onPressed: _pickTime,
                        ),
                      ),
                      controller: TextEditingController(
                        text:
                            "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Subject
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(
                  hintText: "Lesson name, topic etc...",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Type",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Checkboxes
          Row(
  children: [
    Checkbox(
      value: sendSMS,
      onChanged: (val) => setState(() => sendSMS = val!),
      fillColor: WidgetStateProperty.all(Colors.white), // background
      checkColor: Colors.green, // tick color
    ),
    const Text("SMS"),
    const SizedBox(width: 8),
    Checkbox(
      value: sendWhatsApp,
      onChanged: (val) => setState(() => sendWhatsApp = val!),
      fillColor: WidgetStateProperty.all(Colors.white),
      checkColor: Colors.green,
    ),
    const Text("Whats app"),
    const SizedBox(width: 8),
    Checkbox(
      value: sendEmail,
      onChanged: (val) => setState(() => sendEmail = val!),
      fillColor: WidgetStateProperty.all(Colors.white),
      checkColor: Colors.green,
    ),
    const Text("Email"),
  ],
),
const Spacer(),



              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                      onPressed: () {
                        // Send meeting logic here
                      },
                      child: const Text("Send", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "",
      "Jan.",
      "Feb.",
      "Mar.",
      "Apr.",
      "May",
      "Jun.",
      "Jul.",
      "Aug.",
      "Sep.",
      "Oct.",
      "Nov.",
      "Dec."
    ];
    return months[month];
  }

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }
}
