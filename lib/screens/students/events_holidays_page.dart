import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:school_app/widgets/student_app_bar.dart';
import 'student_menu_drawer.dart';

class EventsHolidaysPage extends StatefulWidget {
  const EventsHolidaysPage({Key? key}) : super(key: key);

  @override
  State<EventsHolidaysPage> createState() => _EventsHolidaysPageState();
}

class _EventsHolidaysPageState extends State<EventsHolidaysPage> {
  int selectedYear = 2019;
  bool isMonthSelected = false;

  bool isHolidayChecked = true;
bool isEventChecked = true;

  final Map<String, List<Map<String, String>>> yearlyEvents = {
    'January': [
      {
        'day': '26',
        'weekday': 'Sat.',
        'type': 'Holiday',
        'label': 'Republic day',
      },
      {'day': '31', 'weekday': 'Thu.', 'type': 'Event', 'label': 'School fest'},
    ],
    'February': [
      {'day': '8', 'weekday': 'Fri.', 'type': 'Event', 'label': 'Art day'},
      {
        'day': '18',
        'weekday': 'Mon.',
        'type': 'Holiday',
        'label': 'School holiday',
      },
      {
        'day': '19',
        'weekday': 'Mon.',
        'type': 'Holiday',
        'label': 'School holiday',
      },
      {
        'day': '20',
        'weekday': 'Mon.',
        'type': 'Holiday',
        'label': 'School holiday',
      },
      {
        'day': '21',
        'weekday': 'Mon.',
        'type': 'Holiday',
        'label': 'School holiday',
      },
      {
        'day': '22',
        'weekday': 'Mon.',
        'type': 'Holiday',
        'label': 'School holiday',
      },
      {
        'day': '23',
        'weekday': 'Mon.',
        'type': 'Holiday',
        'label': 'School holiday',
      },
    ],
    'March': [
      {
        'day': '5',
        'weekday': 'Tue.',
        'type': 'Holiday',
        'label': 'Spring Break',
      },
      {
        'day': '15',
        'weekday': 'Fri.',
        'type': 'Event',
        'label': 'Science Fair',
      },
    ],
    'April': [
      {
        'day': '14',
        'weekday': 'Sun.',
        'type': 'Holiday',
        'label': 'Ambedkar Jayanti',
      },
      {'day': '22', 'weekday': 'Mon.', 'type': 'Event', 'label': 'Earth Day'},
    ],
    // Add more months similarly...
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      ); // 👈 This goes back to the previous screen
                    },
                    child: const Text('< Back', style: TextStyle(fontSize: 16)),
                  ),
                  const Spacer(),
                  const Text(
                    'Gallery',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF2E3192), // background color for icon
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/events.svg', // ✅ your events icon path
                      width: 24,
                      height: 24,
                      color: Colors.white, // icon color inside
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Events & Holidays',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3192), // ✅ title font color
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Year Navigation
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  // Toggle (Month | Year)
                Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    GestureDetector(
      onTap: () {
        setState(() {
          isMonthSelected = true;
        });
      },
      child: Text(
        'Month',
        style: TextStyle(
          fontSize: 16,
          fontWeight: isMonthSelected ? FontWeight.bold : FontWeight.normal,
          color: isMonthSelected ? Colors.blue : Colors.grey[600],
          decoration: isMonthSelected ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    ),
    GestureDetector(
      onTap: () {
        setState(() {
          isMonthSelected = false;
        });
      },
      child: Text(
        'Year',
        style: TextStyle(
          fontSize: 16,
          fontWeight: !isMonthSelected ? FontWeight.bold : FontWeight.normal,
          color: !isMonthSelected ? Colors.blue : Colors.grey[600],
          decoration: !isMonthSelected ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    ),
  ],
),
                  const SizedBox(height: 8),

                  // Year selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          setState(() {
                            selectedYear--;
                          });
                        },
                      ),
                      Text(
                        '$selectedYear',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          setState(() {
                            selectedYear++;
                          });
                        },
                      ),
                    ],
                  ),

                  const Divider(),

                  // Legend
                Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Row(
      children: [
        Checkbox(
          value: isHolidayChecked,
          onChanged: (value) {
            setState(() {
              isHolidayChecked = value ?? true;
            });
          },
          visualDensity: VisualDensity.compact,
        ),
        const CircleAvatar(radius: 6, backgroundColor: Colors.red),
        const SizedBox(width: 4),
        const Text('Holiday'),
      ],
    ),
    const SizedBox(width: 16),
    Row(
      children: [
        Checkbox(
          value: isEventChecked,
          onChanged: (value) {
            setState(() {
              isEventChecked = value ?? true;
            });
          },
          visualDensity: VisualDensity.compact,
        ),
        const CircleAvatar(radius: 6, backgroundColor: Colors.orange),
        const SizedBox(width: 4),
        const Text('Event'),
      ],
    ),
  ],
),
                  const SizedBox(height: 16),

                  // Month-wise Events
                  for (var month in yearlyEvents.keys)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          month,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: yearlyEvents[month]!.map((event) {
                            Color color = event['type'] == 'Holiday'
                                ? Colors.red
                                : Colors.orange;
                            return Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: color,
                                  radius: 28,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        event['day']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        event['weekday']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event['label']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
