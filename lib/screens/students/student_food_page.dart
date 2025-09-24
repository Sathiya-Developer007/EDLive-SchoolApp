import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

class StudentFoodPage extends StatefulWidget {
  const StudentFoodPage({super.key});

  @override
  State<StudentFoodPage> createState() => _StudentFoodPageState();
}

class _StudentFoodPageState extends State<StudentFoodPage> {

  
  DateTime _selectedMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  Map<String, bool> _foodSelections = {
    "Breakfast": false,
    "Lunch": false,
    "Snacks": false,
  };

 Map<String, dynamic>? _weeklyMenu; // whole week data
 // API data for selected day
  bool _loading = false;

  bool get _isAnySelected => _foodSelections.containsValue(true);

  @override
  void initState() {
    super.initState();
    _fetchMenu();
  }

Future<void> _submitFoodForSelectedDate() async {
  if (!_isAnySelected) return; // nothing selected

  setState(() => _loading = true);

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token") ?? "";
    final studentId = prefs.getInt("student_id") ?? 0;

    final formattedDate =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

    final weekdayIndex = _selectedDate.weekday - 1; // 0 = Monday
    final dayMenu = _weeklyMenu?["$weekdayIndex"];

    // Safely get menu IDs
    int breakfastId = (_foodSelections["Breakfast"]! && dayMenu?["breakfast"] != null)
        ? dayMenu!["breakfast"]["items"][0]["id"]
        : 0;
    int lunchId = (_foodSelections["Lunch"]! && dayMenu?["lunch"] != null)
        ? dayMenu!["lunch"]["items"][0]["id"]
        : 0;
    int snacksId = (_foodSelections["Snacks"]! && dayMenu?["snacks"] != null)
        ? dayMenu!["snacks"]["items"][0]["id"]
        : 0;

    final body = {
      "student_id": studentId,
      "date": formattedDate,
      "breakfast_menu_id": breakfastId,
      "lunch_menu_id": lunchId,
      "snacks_menu_id": snacksId,
    };

    final url =
        "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/food/schedule";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Food schedule confirmed!")),
      );
      print("Schedule saved: $data");
    } else {
      print("Error ${response.statusCode}: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to confirm food: ${response.statusCode}")),
      );
    }
  } catch (e) {
    print("Submit API Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error submitting food selection")),
    );
  } finally {
    setState(() => _loading = false);
  }
}


  Future<void> _fetchMenu() async {
    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token") ?? "";

      final formattedDate =
          "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

      final url =
          "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/food/weekly-menu?date=$formattedDate";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

   if (response.statusCode == 200) {
  final data = json.decode(response.body);

  setState(() {
    _weeklyMenu = data; // store entire week instead of only one day
  });
}
else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("API Error: $e");
    }

    setState(() => _loading = false);
  }

  void _toggleFood(String key, bool value) {
    setState(() {
      _foodSelections[key] = value;
    });
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    });
  }

  void _previousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      _fetchMenu();
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
      _fetchMenu();
    });
  }

  String get _monthYear {
    return "${_monthNames[_selectedMonth.month - 1]}. ${_selectedMonth.year}";
  }

  static const List<String> _monthNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDC87D),
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Back + Title)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text("< Back",
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E3192),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/food.svg",
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text("Food",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3192))),
                  ],
                ),
              ],
            ),
          ),

          // Calendar selector
          _calendarSection(),

          // Food List
       Expanded(
  child: _loading
      ? const Center(child: CircularProgressIndicator())
      : _weeklyMenu == null
          ? const Center(child: Text("No menu available"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 7, // Monday to Sunday
              itemBuilder: (context, index) {
                final dayMenu = _weeklyMenu?["$index"];
                if (dayMenu == null) return const SizedBox();
                

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
               if (dayMenu["breakfast"] != null)
  FoodTile(
    keyName: "Breakfast-$index",
    title: "Breakfast (${dayMenu["breakfast"]["price"]}₹)",
    time: "8 : 30 am - 09 : 30 am",
    items: dayMenu["breakfast"]["items"], // pass array
    checked: _foodSelections["Breakfast"]!,
    onChanged: (v) => _toggleFood("Breakfast", v),
  ),

if (dayMenu["lunch"] != null)
  FoodTile(
    keyName: "Lunch-$index",
    title: "Lunch (${dayMenu["lunch"]["price"]}₹)",
    time: "12 : 30 pm - 01 : 30 pm",
    items: dayMenu["lunch"]["items"],
    checked: _foodSelections["Lunch"]!,
    onChanged: (v) => _toggleFood("Lunch", v),
  ),

if (dayMenu["snacks"] != null)
  FoodTile(
    keyName: "Snacks-$index",
    title: "Snacks (${dayMenu["snacks"]["price"]}₹)",
    time: "3 : 30 pm - 4 : 00 pm",
    items: dayMenu["snacks"]["items"],
    checked: _foodSelections["Snacks"]!,
    onChanged: (v) => _toggleFood("Snacks", v),
  ),
   const SizedBox(height: 20),
                  ],
                );
              },
            ),
),
          // Pay Button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
  onPressed: _isAnySelected ? _submitFoodForSelectedDate : null,
  style: ElevatedButton.styleFrom(
    backgroundColor: _isAnySelected ? Colors.blue : const Color(0xFFCCCCCC),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  ),
  child: const Text("Pay & Confirm", style: TextStyle(color: Colors.white, fontSize: 16)),
)
    ),
        ],
      ),
    );
  }

  // Calendar Section widget
  Widget _calendarSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.black),
                onPressed: _previousMonth,
              ),
              Text(_monthYear,
                  style: const TextStyle(
                      fontSize: 20, color: Color(0xFF2E3192))),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.black),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Week selector
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.black),
                onPressed: _previousWeek,
              ),
           Expanded(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(7, (index) {
      final startOfWeek =
          _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
      final date = startOfWeek.add(Duration(days: index));

      final isSelected = date.day == _selectedDate.day &&
          date.month == _selectedDate.month &&
          date.year == _selectedDate.year;

      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedDate = date;
          });
          _fetchMenu(); // 🔹 Fetch API data for that date
        },
        child: _dayTile(
          ["Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat.", "Sun."][index],
          date.day.toString(),
          isSelected,
        ),
      );
    }),
  ),
),
  IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.black),
                onPressed: _nextWeek,
              ),
            ],
          )
        ],
      ),
    );
  }

  static Widget _dayTile(String day, String date, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(day,
              style: TextStyle(
                  fontSize: 10,
                  color: selected ? Colors.white : Colors.black)),
          Text(date,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Colors.black)),
        ],
      ),
    );
  }
}

// 🔹 Food Item Widget
class FoodTile extends StatelessWidget {
  final String keyName;
  final String title;
  final String time;
  final List<dynamic> items;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const FoodTile({ // <- NOT const
    super.key,
    required this.keyName,
    required this.title,
    required this.time,
    required this.items,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: checked,
            activeColor: const Color(0xFF29ABE2),
            onChanged: (value) => onChanged(value ?? false),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1st line: title + time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3192),
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // 2nd & 3rd lines: each item name + description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items.map<Widget>((item) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Text(
  item["name"],
  style: const TextStyle(
    color: Colors.black,       // ✅ this should make name black
    fontWeight: FontWeight.bold,
    fontSize: 14,
  ),
),
Text(
  item["description"],
  style: const TextStyle(
    color: Colors.grey,
    fontSize: 13,
  ),
),

                        const SizedBox(height: 4),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
