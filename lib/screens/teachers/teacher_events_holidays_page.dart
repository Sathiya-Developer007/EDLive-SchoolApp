import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:school_app/widgets/teacher_app_bar.dart';
import 'teacher_menu_drawer.dart';

class TeacherEventsHolidaysPage extends StatefulWidget {
  final bool startInMonthView;

  const TeacherEventsHolidaysPage({Key? key, this.startInMonthView = false}) : super(key: key);

  @override
  State<TeacherEventsHolidaysPage> createState() => _EventsHolidaysPageState();
}


class _EventsHolidaysPageState extends State<TeacherEventsHolidaysPage> {
  int selectedYear = 2019;
  bool isMonthSelected = false;
  int currentMonthIndex = 0;
  String currentMonth = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentMonthIndex = now.month - 1;
    currentMonth = months[currentMonthIndex];

    isMonthSelected = widget.startInMonthView; // ✅ set based on constructor param
  }





  bool isHolidayChecked = true;
bool isEventChecked = true;


final List<String> months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];


final Map<String, List<Map<String, String>>> yearlyEvents = {
  'January': [
    {'day': '1', 'weekday': 'Tue.', 'type': 'Holiday', 'label': 'New Year'},
    {'day': '14', 'weekday': 'Mon.', 'type': 'Holiday', 'label': 'Pongal'},
    {'day': '26', 'weekday': 'Sat.', 'type': 'Holiday', 'label': 'Republic Day'},
    {'day': '31', 'weekday': 'Thu.', 'type': 'Event', 'label': 'School Fest'},
  ],
  'February': [
    {'day': '8', 'weekday': 'Fri.', 'type': 'Event', 'label': 'Art Day'},
    {'day': '14', 'weekday': 'Thu.', 'type': 'Event', 'label': 'Valentines Program'},
    {'day': '18', 'weekday': 'Mon.', 'type': 'Holiday', 'label': 'School Holiday'},
    {'day': '19', 'weekday': 'Tue.', 'type': 'Holiday', 'label': 'School Holiday'},
  ],
  'March': [
    {'day': '5', 'weekday': 'Tue.', 'type': 'Holiday', 'label': 'Spring Break'},
    {'day': '15', 'weekday': 'Fri.', 'type': 'Event', 'label': 'Science Fair'},
    {'day': '22', 'weekday': 'Fri.', 'type': 'Holiday', 'label': 'Holi'},
  ],
  'April': [
    {'day': '14', 'weekday': 'Sun.', 'type': 'Holiday', 'label': 'Ambedkar Jayanti'},
    {'day': '22', 'weekday': 'Mon.', 'type': 'Event', 'label': 'Earth Day'},
  ],
  'May': [
    {'day': '1', 'weekday': 'Wed.', 'type': 'Holiday', 'label': 'Labor Day'},
    {'day': '10', 'weekday': 'Fri.', 'type': 'Event', 'label': 'Summer Camp Starts'},
    {'day': '25', 'weekday': 'Sat.', 'type': 'Holiday', 'label': 'Summer Vacation'},
  ],
  'June': [
    {'day': '5', 'weekday': 'Wed.', 'type': 'Holiday', 'label': 'Ramzan'},
    {'day': '15', 'weekday': 'Sat.', 'type': 'Event', 'label': 'School Reopens'},
  ],
  'July': [
    {'day': '4', 'weekday': 'Thu.', 'type': 'Event', 'label': 'PTA Meeting'},
    {'day': '20', 'weekday': 'Sat.', 'type': 'Holiday', 'label': 'Mid Term Break'},
  ],
  'August': [
    {'day': '15', 'weekday': 'Thu.', 'type': 'Holiday', 'label': 'Independence Day'},
    {'day': '29', 'weekday': 'Thu.', 'type': 'Event', 'label': 'Sports Day'},
  ],
  'September': [
    {'day': '5', 'weekday': 'Thu.', 'type': 'Event', 'label': 'Teacher\'s Day'},
    {'day': '10', 'weekday': 'Tue.', 'type': 'Holiday', 'label': 'Ganesh Chaturthi'},
  ],
  'October': [
    {'day': '2', 'weekday': 'Wed.', 'type': 'Holiday', 'label': 'Gandhi Jayanti'},
    {'day': '27', 'weekday': 'Sun.', 'type': 'Event', 'label': 'Diwali Celebration'},
  ],
  'November': [
    {'day': '1', 'weekday': 'Fri.', 'type': 'Holiday', 'label': 'Kannada Rajyotsava'},
    {'day': '14', 'weekday': 'Thu.', 'type': 'Event', 'label': 'Children\'s Day'},
  ],
  'December': [
    {'day': '25', 'weekday': 'Wed.', 'type': 'Holiday', 'label': 'Christmas'},
    {'day': '31', 'weekday': 'Tue.', 'type': 'Event', 'label': 'New Year Eve Program'},
  ],
};




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: TeacherAppBar(),
      drawer: MenuDrawer(),
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
        Expanded(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16), // ← Horizontal space outside the white box
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16), // ← Inner space
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      child: Column(
        children: [
          Text(
            'Month',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isMonthSelected ? FontWeight.bold : FontWeight.normal,
              color: isMonthSelected ? Color(0xFF29ABE2) : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          if (isMonthSelected)
            Container(
              height: 3, // ← underline thickness
              width: 40,
              color: Color(0xFF29ABE2),
            ),
        ],
      ),
    ),
    GestureDetector(
      onTap: () {
        setState(() {
          isMonthSelected = false;
        });
      },
      child: Column(
        children: [
          Text(
            'Year',
            style: TextStyle(
              fontSize: 16,
              fontWeight: !isMonthSelected ? FontWeight.bold : FontWeight.normal,
              color: !isMonthSelected ? Color(0xFF29ABE2) : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          if (!isMonthSelected)
            Container(
              height: 3, // ← underline thickness
              width: 40,
              color: Color(0xFF29ABE2),
            ),
        ],
      ),
    ),
  ],
),
       const SizedBox(height: 8),

                  // Year selector
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Left Arrow (Black)
    IconButton(
      icon: const Icon(Icons.chevron_left),
      color: Colors.black, // ← Black color
      onPressed: () {
        setState(() {
          if (isMonthSelected) {
            currentMonthIndex = (currentMonthIndex - 1 + 12) % 12;
            currentMonth = months[currentMonthIndex];
          } else {
            selectedYear--;
          }
        });
      },
    ),

    // Month or Year Text
    Text(
      isMonthSelected ? currentMonth : '$selectedYear',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Right Arrow (#E6E6E6)
    IconButton(
      icon: const Icon(Icons.chevron_right),
      color: Color(0xFFE6E6E6), // ← Light gray color
      onPressed: () {
        setState(() {
          if (isMonthSelected) {
            currentMonthIndex = (currentMonthIndex + 1) % 12;
            currentMonth = months[currentMonthIndex];
          } else {
            selectedYear++;
          }
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
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Holiday
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
        const CircleAvatar(
          radius: 6,
          backgroundColor: Colors.red,
        ),
        const SizedBox(width: 4),
        const Text('Holiday'),
      ],
    ),
    const SizedBox(width: 16),

    // Event
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
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(3), // Rounded box shape
          ),
        ),
        const SizedBox(width: 4),
        const Text('Event'),
      ],
    ),
  ],
),
  ],
),
                  const SizedBox(height: 16),

                  // Month-wise Events
               for (var month in (isMonthSelected
    ? [currentMonth] // Only current month if 'Month' tab is selected
    : yearlyEvents.keys)) // All months if 'Year' tab is selected

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Center(
  child: Text(
    month,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Color(0xFF2E3192), // converted #2E3192
    ),
  ),
),

                        const SizedBox(height: 8),
                      Wrap(
  spacing: 16,
  runSpacing: 16,
  children: yearlyEvents[month]!
      .where((event) {
        if (event['type'] == 'Holiday' && !isHolidayChecked) return false;
        if (event['type'] == 'Event' && !isEventChecked) return false;
        return true;
      })
      .map((event) {
        final isHoliday = event['type'] == 'Holiday';
        final color = isHoliday ? Colors.red : Colors.orange;

        return Column(
  children: [
    isHoliday
        ? CircleAvatar(
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
          )
        : Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
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

    // ✅ Match label width with icon width & wrap text
    SizedBox(
      width: 56, // Match with circle/box width
      child: Text(
        event['label']!,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
        overflow: TextOverflow.visible,
        softWrap: true,
        maxLines: 2, // optional: allow 2 lines
      ),
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
        ),
        ),
       ) ] ),
    ));
  }
}
