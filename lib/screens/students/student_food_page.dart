import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

class StudentFoodPage extends StatefulWidget {
  const StudentFoodPage({super.key});

  @override
  State<StudentFoodPage> createState() => _StudentFoodPageState();
}

class _StudentFoodPageState extends State<StudentFoodPage> {
  DateTime _selectedMonth = DateTime.now(); // ✅ Current month & year
  DateTime _selectedDate = DateTime.now();

  // 🔹 Track food selections
  final Map<String, bool> _foodSelections = {
    "Breakfast": false,
    "Lunch": false,
    "Snacks": false,
  };

  bool get _isAnySelected => _foodSelections.containsValue(true);

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
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
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
      backgroundColor: const Color(0xFFFDC87D), // background same as screenshot
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back + Title in two lines
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back text
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "< Back",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Row with Food icon + title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        // shape: BoxShape.circle,
                        color: Color(0xFF2E3192), // #2E3192
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/food.svg",
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Food",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                         color: Color(0xFF2E3192),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Calendar selector
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.black),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: _previousMonth,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _monthYear,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Color(0xFF2E3192),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.black),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: _nextMonth,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Week navigation with arrows
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: 28,
                      icon: const Icon(Icons.chevron_left, color: Colors.black),
                      onPressed: _previousWeek,
                    ),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (index) {
                          final startOfWeek = _selectedDate.subtract(
                            Duration(days: _selectedDate.weekday - 1),
                          );
                          final date = startOfWeek.add(Duration(days: index));
                          final isSelected = date.day == _selectedDate.day &&
                              date.month == _selectedDate.month &&
                              date.year == _selectedDate.year;

                          return Flexible(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDate = date;
                                });
                              },
                              child: _dayTile(
                                ["Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat.", "Sun."][index],
                                date.day.toString(),
                                isSelected,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: 28,
                      icon: const Icon(Icons.chevron_right, color: Colors.black),
                      onPressed: _nextWeek,
                    ),
                  ],
                )
              ],
            ),
          ),

          // Food items list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                FoodTile(
                  keyName: "Breakfast",
                  title: "Breakfast (50₹)",
                  time: "8 : 30 am - 09 : 30 am",
                  description: "Dosa Varities, Boiled Egg/ Omlette, Sambar, Vada",
                  checked: _foodSelections["Breakfast"]!,
                  onChanged: (v) => _toggleFood("Breakfast", v),
                ),
                const SizedBox(height: 10),
                FoodTile(
                  keyName: "Lunch",
                  title: "Lunch (100₹)",
                  time: "12 : 30 pm - 01 : 30 pm",
                  description:
                      "Steamed Rice, Sambar, Rasam, Curd (Yogurt), Poriyal (stir-fried vegetables), Kootu (vegetable + lentil curry), Appalam (papad), Pickle, Buttermilk",
                  checked: _foodSelections["Lunch"]!,
                  onChanged: (v) => _toggleFood("Lunch", v),
                ),
                const SizedBox(height: 10),
                FoodTile(
                  keyName: "Snacks",
                  title: "Snacks (20₹)",
                  time: "3 : 30 pm - 4 : 00 pm",
                  description: "Fruit Salad, Milk",
                  checked: _foodSelections["Snacks"]!,
                  onChanged: (v) => _toggleFood("Snacks", v),
                ),
              ],
            ),
          ),

          // Pay button
         // Pay button
Container(
  width: double.infinity,
  margin: const EdgeInsets.all(16),
  child: ElevatedButton(
  style: ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (states) {
      if (states.contains(MaterialState.disabled)) {
        return const Color(0xFFCCCCCC); // disabled color
      }
      return Colors.blue; // enabled color
    },
  ),
  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 14)),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  ),
),
   onPressed: _isAnySelected
        ? () {
            // Handle pay action
          }
        : null,
    child: const Text(
      "Pay & Confirm",
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  ),
)
  ],
      ),
    );
  }

  // Day Tile widget
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
          Text(
            day,
            style: TextStyle(
              fontSize: 10,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
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
  final String description;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const FoodTile({
    super.key,
    required this.keyName,
    required this.title,
    required this.time,
    required this.description,
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: checked,
            activeColor: const Color(0xFF29ABE2),
            checkColor: Colors.white,
            onChanged: (value) => onChanged(value ?? false),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(time,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 5),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
