import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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

  bool get _isAnySelected {
    final dateKey = DateFormat("yyyy-MM-dd").format(_selectedDate);
    final selections = _foodSelectionsByDate[dateKey] ?? {};

    final weekdayIndex = _selectedDate.weekday % 7; // Sunday=0
    final dayMenu = _weeklyMenu?["$weekdayIndex"];

    // ❌ if no menu at all, return false
    if (dayMenu == null ||
        (dayMenu["breakfast"] == null &&
            dayMenu["lunch"] == null &&
            dayMenu["snacks"] == null)) {
      return false;
    }

    // ✅ at least one food checkbox selected
    return selections.containsValue(true);
  }

  Map<String, Map<String, bool>> _foodSelectionsByDate = {};

  late ScrollController _scroll;
  late DateTime _centerDate;
  late DateTime _startDate;
  List<DateTime> _visibleDates = [];

  @override
  void initState() {
    super.initState();
    _centerDate = DateTime.now();
    _startDate = _centerDate.subtract(Duration(days: _centerDate.weekday - 1));
    _generateVisibleDates();
    _scroll = ScrollController();
    _fetchMenu();
    _loadData();
    _fetchScheduleForDate(_selectedDate);
  }

  void _generateVisibleDates() {
    _visibleDates = List.generate(30, (i) => _startDate.add(Duration(days: i)));
  }

  void _centerCurrentDate() {
    final index = _visibleDates.indexWhere(
      (d) =>
          d.day == _centerDate.day &&
          d.month == _centerDate.month &&
          d.year == _centerDate.year,
    );

    if (index != -1) {
      final itemWidth =
          (MediaQuery.of(context).size.width - 3 * 30) /
          8; // same as in _dateScroller
      _scroll.animateTo(
        index * itemWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _fetchScheduleForDate(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token") ?? "";
      final studentId = prefs.getInt("student_id") ?? 0;

      final dateKey = DateFormat("yyyy-MM-dd").format(date);
      final apiDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final url =
          "http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/food/schedule/$studentId/$apiDate";

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
          _foodSelectionsByDate[dateKey] = {
            "Breakfast": (data["breakfast_menu_id"] ?? 0) != 0,
            "Lunch": (data["lunch_menu_id"] ?? 0) != 0,
            "Snacks": (data["snacks_menu_id"] ?? 0) != 0,
          };
        });
      } else {
        setState(() {
          _foodSelectionsByDate[dateKey] = {
            "Breakfast": false,
            "Lunch": false,
            "Snacks": false,
          };
        });
      }
    } catch (e) {
      print("Fetch schedule error: $e");
    }
  }

  Future<void> _submitFoodForWeek() async {
    // Filter only days with at least one selected meal
    final selectedDays = _foodSelectionsByDate.entries
        .where((e) => e.value.containsValue(true))
        .toList();

    if (selectedDays.isEmpty) return;

    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token") ?? "";
      final studentId = prefs.getInt("student_id") ?? 0;

      for (final entry in selectedDays) {
        final dateKey = entry.key;
        final selections = entry.value;

        // Map dateKey to weekdayIndex to get menu
        final date = DateTime.parse(dateKey);
        final weekdayIndex = date.weekday % 7;
        final dayMenu = _weeklyMenu?["$weekdayIndex"];

        final body = {
          "student_id": studentId,
          "date": dateKey,
          "end_date": dateKey,
          "breakfast_menu_id":
              (selections["Breakfast"]! &&
                  dayMenu?["breakfast"]?["items"]?.isNotEmpty == true)
              ? dayMenu!["breakfast"]["items"][0]["id"]
              : null,
          "lunch_menu_id":
              (selections["Lunch"]! &&
                  dayMenu?["lunch"]?["items"]?.isNotEmpty == true)
              ? dayMenu["lunch"]["items"][0]["id"]
              : null,
          "snacks_menu_id":
              (selections["Snacks"]! &&
                  dayMenu?["snacks"]?["items"]?.isNotEmpty == true)
              ? dayMenu["snacks"]["items"][0]["id"]
              : null,
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
          print("✅ Food schedule Booked for $dateKey");
        } else {
          print("❌ Failed for $dateKey => ${response.body}");
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Food schedule Booked for all selected days!"),
        ),
      );
    } catch (e) {
      print("Submit Week API Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error submitting weekly schedule")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _submitFoodForSelectedDate() async {
    final dateKey = DateFormat("yyyy-MM-dd").format(_selectedDate);
    final selections = _foodSelectionsByDate[dateKey];

    if (selections == null || !selections.containsValue(true)) return;

    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token") ?? "";
      final studentId = prefs.getInt("student_id") ?? 0;

      final weekdayIndex = _selectedDate.weekday % 7; // ✅
      final dayMenu = _weeklyMenu?["$weekdayIndex"];

      final body = {
        "student_id": studentId,
        "date": dateKey,
        "end_date": dateKey, // ✅ added
        "breakfast_menu_id":
            (selections["Breakfast"]! &&
                dayMenu?["breakfast"]?["items"]?.isNotEmpty == true)
            ? dayMenu!["breakfast"]["items"][0]["id"]
            : null,
        "lunch_menu_id":
            (selections["Lunch"]! &&
                dayMenu?["lunch"]?["items"]?.isNotEmpty == true)
            ? dayMenu["lunch"]["items"][0]["id"]
            : null,
        "snacks_menu_id":
            (selections["Snacks"]! &&
                dayMenu?["snacks"]?["items"]?.isNotEmpty == true)
            ? dayMenu["snacks"]["items"][0]["id"]
            : null,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Order Booked for $dateKey")),
        );
      } else {
        print("❌ Error ${response.statusCode}: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to Book order")),
        );
      }
    } catch (e) {
      print("Submit API Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error submitting order")));
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
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("API Error: $e");
    }

    setState(() => _loading = false);
  }

  void _toggleFood(String key, bool value) {
    final dateKey = DateFormat("yyyy-MM-dd").format(_selectedDate);

    setState(() {
      // Ensure map exists for the date
      _foodSelectionsByDate.putIfAbsent(
        dateKey,
        () => {"Breakfast": false, "Lunch": false, "Snacks": false},
      );

      _foodSelectionsByDate[dateKey]![key] = value;
    });
  }

  Future<List<String>> fetchWeekdays() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(
        'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000/api/weekdays',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((day) => day['day'] as String).toList();
    } else {
      throw Exception('Failed to load weekdays');
    }
  }

  List<String> _weekdays = [];
  bool _isLoading = true;

  Future<void> _loadData() async {
    try {
      final days = await fetchWeekdays();
      setState(() {
        _weekdays = days;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
        1,
      );

      // ✅ Reset week section to first week of month
      _selectedDate = _selectedMonth;
      _centerDate = _selectedDate;
      _startDate = _centerDate.subtract(
        Duration(days: _centerDate.weekday - 1),
      );
      _generateVisibleDates();
      _fetchMenu();
      _fetchScheduleForDate(_selectedDate);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + 1,
        1,
      );

      // ✅ Reset week section to first week of month
      _selectedDate = _selectedMonth;
      _centerDate = _selectedDate;
      _startDate = _centerDate.subtract(
        Duration(days: _centerDate.weekday - 1),
      );
      _generateVisibleDates();
      _fetchMenu();
      _fetchScheduleForDate(_selectedDate);
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
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Day, Week, Month
      child: Scaffold(
        backgroundColor: const Color(0xFFFDC87D),
        appBar: StudentAppBar(),
        drawer: StudentMenuDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header (Back + Icon + Title)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "< Back",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
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
                      const Text(
                        "Food",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3192),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔹 White container with TabBar
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color(0xFF2E3192),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFF2E3192),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(text: "Day"),
                        Tab(text: "Week"),
                        Tab(text: "Month"),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 🔹 Tab Views
                    Expanded(
                      child: TabBarView(
                        children: [
                          // ✅ Day tab = your existing UI
                          _buildDayTabUI(),
                          _buildWeekTabUI(),
                          _buildMonthTabUI(), // 📌 Week placeholder
                          // const Center(
                          //   child: Text(
                          //     "Weekly food schedule will appear here",
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       color: Colors.black54,
                          //     ),
                          //   ),
                          // ),

                          // // 📌 Month placeholder
                          // const Center(
                          //   child: Text(
                          //     "Monthly food schedule will appear here",
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       color: Colors.black54,
                          //     ),
                          //   ),
                          // ),
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
    );
  }

  // 🔹 moved your full day UI here unchanged
  Widget _buildDayTabUI() {
    return Column(
      children: [
        _dateScroller(),
        _buildWeekdaysSection(),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _weeklyMenu == null
              ? const Center(child: Text("No menu available"))
              : Builder(
                  builder: (context) {
                    final weekdayIndex = _selectedDate.weekday % 7;
                    final dayMenu = _weeklyMenu?["$weekdayIndex"];

                    if (dayMenu == null ||
                        (dayMenu["breakfast"] == null &&
                            dayMenu["lunch"] == null &&
                            dayMenu["snacks"] == null)) {
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: const [
                                  Icon(
                                    Icons.fastfood,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "No menu available for this day",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (dayMenu["breakfast"] != null)
                          FoodTile(
                            keyName: "Breakfast-$weekdayIndex",
                            title:
                                "Breakfast (${dayMenu["breakfast"]["price"]}₹)",
                            time: "8 : 30 am - 09 : 30 am",
                            items: dayMenu["breakfast"]["items"],
                            checked:
                                _foodSelectionsByDate[DateFormat(
                                  "yyyy-MM-dd",
                                ).format(_selectedDate)]?["Breakfast"] ??
                                false,
                            onChanged: (v) => _toggleFood("Breakfast", v),
                          ),
                        if (dayMenu["lunch"] != null)
                          FoodTile(
                            keyName: "Lunch-$weekdayIndex",
                            title: "Lunch (${dayMenu["lunch"]["price"]}₹)",
                            time: "12 : 30 pm - 01 : 30 pm",
                            items: dayMenu["lunch"]["items"],
                            checked:
                                _foodSelectionsByDate[DateFormat(
                                  "yyyy-MM-dd",
                                ).format(_selectedDate)]?["Lunch"] ??
                                false,
                            onChanged: (v) => _toggleFood("Lunch", v),
                          ),
                        if (dayMenu["snacks"] != null)
                          FoodTile(
                            keyName: "Snacks-$weekdayIndex",
                            title: "Snacks (${dayMenu["snacks"]["price"]}₹)",
                            time: "3 : 30 pm - 4 : 00 pm",
                            items: dayMenu["snacks"]["items"],
                            checked:
                                _foodSelectionsByDate[DateFormat(
                                  "yyyy-MM-dd",
                                ).format(_selectedDate)]?["Snacks"] ??
                                false,
                            onChanged: (v) => _toggleFood("Snacks", v),
                          ),
                      ],
                    );
                  },
                ),
        ),
        // Book Button
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isAnySelected ? _submitFoodForSelectedDate : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAnySelected
                  ? Colors.blue
                  : const Color(0xFFCCCCCC),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              "Book",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateScroller() {
    final screenWidth = MediaQuery.of(context).size.width;
    final arrowWidth = 30.0;
    final itemWidth = (screenWidth - 3 * arrowWidth) / 7;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 🔹 Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.black),
                onPressed: _previousMonth,
              ),
              Text(
                _monthYear,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3192),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.black),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 🔹 Week scroll
          SizedBox(
            height: 70,
            child: Stack(
              children: [
                // Scrollable dates
                Positioned(
                  left: arrowWidth,
                  right: arrowWidth,
                  top: 0,
                  bottom: 0,
                  child: ListView.builder(
                    controller: _scroll,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _visibleDates.length,
                    itemBuilder: (context, index) {
                      final date = _visibleDates[index];
                      final selected =
                          date.day == _centerDate.day &&
                          date.month == _centerDate.month &&
                          date.year == _centerDate.year;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _centerDate = date;
                            _selectedDate = date;
                          });

                          // initialize default selections
                          _foodSelectionsByDate.putIfAbsent(
                            DateFormat("yyyy-MM-dd").format(date),
                            () => {
                              "Breakfast": false,
                              "Lunch": false,
                              "Snacks": false,
                            },
                          );

                          _fetchMenu();
                          _fetchScheduleForDate(
                            date,
                          ); // ✅ also fetch schedule status
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _centerCurrentDate(),
                          );
                        },

                        child: Container(
                          width: itemWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: selected ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              if (selected)
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('EEE').format(date),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                date.day.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: selected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Left arrow
                // Left arrow
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        _centerDate = _centerDate.subtract(
                          const Duration(days: 7),
                        );
                        _selectedDate = _centerDate; // ✅ update selected date
                        _startDate = _centerDate.subtract(
                          Duration(days: _centerDate.weekday - 1),
                        );
                        _generateVisibleDates();
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _centerCurrentDate();
                        _fetchMenu();
                        _fetchScheduleForDate(
                          _selectedDate,
                        ); // ✅ update weekdays section
                      });
                    },
                    child: const SizedBox(
                      width: 30,
                      height: 70,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                // Right arrow
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        _centerDate = _centerDate.add(const Duration(days: 7));
                        _selectedDate = _centerDate; // ✅ update selected date
                        _startDate = _centerDate.subtract(
                          Duration(days: _centerDate.weekday - 1),
                        );
                        _generateVisibleDates();
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _centerCurrentDate();
                        _fetchMenu();
                        _fetchScheduleForDate(
                          _selectedDate,
                        ); // ✅ update weekdays section
                      });
                    },
                    child: const SizedBox(
                      width: 30,
                      height: 70,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildWeekTabUI() {
  if (_loading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (_weeklyMenu == null) {
    return const Center(child: Text("No menu available"));
  }

  // Generate week dates (Mon–Sun)
  final weekDates = List.generate(7, (i) => _startDate.add(Duration(days: i)));

  return Column(
    children: [
      // 🔹 Week navigation with arrows
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () {
                setState(() {
                  _startDate = _startDate.subtract(const Duration(days: 7));
                  _selectedDate = _startDate; // reset selection to first day
                });
              },
            ),
            Text(
              "${DateFormat('dd MMM').format(weekDates.first)} - ${DateFormat('dd MMM').format(weekDates.last)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 20),
              onPressed: () {
                setState(() {
                  _startDate = _startDate.add(const Duration(days: 7));
                  _selectedDate = _startDate; // reset selection to first day
                });
              },
            ),
          ],
        ),
      ),

      // 🔹 Horizontal week date selector
    // 🔹 Horizontal week date selector
SizedBox(
  height: 70,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: weekDates.length,
    itemBuilder: (context, index) {
      final date = weekDates[index];
      final dateKey = DateFormat("yyyy-MM-dd").format(date);

      final isSelected = _selectedDate.year == date.year &&
          _selectedDate.month == date.month &&
          _selectedDate.day == date.day;

      final hasSelection =
          _foodSelectionsByDate[dateKey]?.containsValue(true) ?? false;

      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedDate = date;
          });
        },
        child: Container(
          width: 50, // ✅ same as month tab
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasSelection ? Colors.green : Colors.grey.shade300,
              width: hasSelection ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('EEE').format(date),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date.day.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
),

      const SizedBox(height: 12),

      // 🔹 Show only selected day’s menu
      Expanded(
        child: Builder(
          builder: (context) {
            final weekdayIndex = _selectedDate.weekday % 7;
            final dayMenu = _weeklyMenu?["$weekdayIndex"];
            final dateKey = DateFormat("yyyy-MM-dd").format(_selectedDate);

            _foodSelectionsByDate.putIfAbsent(
              dateKey,
              () => {"Breakfast": false, "Lunch": false, "Snacks": false},
            );

            if (dayMenu == null ||
                (dayMenu["breakfast"] == null &&
                    dayMenu["lunch"] == null &&
                    dayMenu["snacks"] == null)) {
             return ListView(
  padding: const EdgeInsets.all(16),
  children: [
    Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Icon(Icons.fastfood, size: 40, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              "No menu available for this day",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
);

            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (dayMenu["breakfast"] != null)
                  FoodTile(
                    keyName: "Breakfast-$weekdayIndex",
                    title: "Breakfast (${dayMenu["breakfast"]["price"]}₹)",
                    time: "8 : 30 am - 09 : 30 am",
                    items: dayMenu["breakfast"]["items"],
                    checked:
                        _foodSelectionsByDate[dateKey]?["Breakfast"] ?? false,
                    onChanged: (v) => setState(() {
                      _foodSelectionsByDate[dateKey]!["Breakfast"] = v;
                    }),
                  ),
                if (dayMenu["lunch"] != null)
                  FoodTile(
                    keyName: "Lunch-$weekdayIndex",
                    title: "Lunch (${dayMenu["lunch"]["price"]}₹)",
                    time: "12 : 30 pm - 01 : 30 pm",
                    items: dayMenu["lunch"]["items"],
                    checked:
                        _foodSelectionsByDate[dateKey]?["Lunch"] ?? false,
                    onChanged: (v) => setState(() {
                      _foodSelectionsByDate[dateKey]!["Lunch"] = v;
                    }),
                  ),
                if (dayMenu["snacks"] != null)
                  FoodTile(
                    keyName: "Snacks-$weekdayIndex",
                    title: "Snacks (${dayMenu["snacks"]["price"]}₹)",
                    time: "3 : 30 pm - 4 : 00 pm",
                    items: dayMenu["snacks"]["items"],
                    checked:
                        _foodSelectionsByDate[dateKey]?["Snacks"] ?? false,
                    onChanged: (v) => setState(() {
                      _foodSelectionsByDate[dateKey]!["Snacks"] = v;
                    }),
                  ),
              ],
            );
          },
        ),
      ),

      // 🔹 Book button
      Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _foodSelectionsByDate.values.any(
            (day) => day.containsValue(true),
          )
              ? _submitFoodForWeek
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _foodSelectionsByDate.values.any(
              (day) => day.containsValue(true),
            )
                ? Colors.blue
                : const Color(0xFFCCCCCC),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            "Book All Selected Days",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildWeekdaysSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_weekdays.isEmpty) {
      return const Center(child: Text(""));
    }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekdays",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3192),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _weekdays.asMap().entries.map((entry) {
              final index = entry.key;
              final day = entry.value;
              final isSelected = _selectedDate.weekday - 1 == index;

              return ChoiceChip(
                label: Text(day),
                selected: isSelected,
                selectedColor: const Color(0xFF2E3192),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF2E3192),
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      // pick correct date for that weekday in current week
                      _selectedDate = _startDate.add(Duration(days: index));
                      _centerDate = _selectedDate;
                      _fetchMenu();
                    });
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

Widget _buildMonthTabUI() {
  final firstDayOfMonth = DateTime(
    _selectedMonth.year,
    _selectedMonth.month,
    1,
  );
  final lastDayOfMonth = DateTime(
    _selectedMonth.year,
    _selectedMonth.month + 1,
    0,
  );
  final totalDays = lastDayOfMonth.day;

  final monthDates = List.generate(
    totalDays,
    (i) => firstDayOfMonth.add(Duration(days: i)),
  );

  return Column(
    children: [
      // 🔹 Month header with arrows
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left, size: 32),
              onPressed: () {
                setState(() {
                  _selectedMonth = DateTime(
                    _selectedMonth.year,
                    _selectedMonth.month - 1,
                  );
                  _selectedDate = DateTime(
                    _selectedMonth.year,
                    _selectedMonth.month,
                    1,
                  );
                });
              },
            ),
            Text(
              DateFormat('MMMM yyyy').format(_selectedMonth),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right, size: 32),
              onPressed: () {
                setState(() {
                  _selectedMonth = DateTime(
                    _selectedMonth.year,
                    _selectedMonth.month + 1,
                  );
                  _selectedDate = DateTime(
                    _selectedMonth.year,
                    _selectedMonth.month,
                    1,
                  );
                });
              },
            ),
          ],
        ),
      ),

      // 🔹 Horizontal scrollable month days
      SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: monthDates.length,
          itemBuilder: (context, index) {
            final date = monthDates[index];
            final dateKey = DateFormat("yyyy-MM-dd").format(date);
            final isSelected =
                _selectedDate.year == date.year &&
                _selectedDate.month == date.month &&
                _selectedDate.day == date.day;

            final hasSelection =
                _foodSelectionsByDate[dateKey]?.containsValue(true) ?? false;

            return GestureDetector(
              onTap: () async {
                setState(() {
                  _selectedDate = date;
                });
                _foodSelectionsByDate.putIfAbsent(
                  dateKey,
                  () => {"Breakfast": false, "Lunch": false, "Snacks": false},
                );
                await _fetchMenu();
                await _fetchScheduleForDate(date);
              },
              child: Container(
                width: 50,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: hasSelection ? Colors.green : Colors.grey.shade300,
                    width: hasSelection ? 2 : 1,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEE').format(date),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      const SizedBox(height: 12),

      // 🔹 Menu list
      Expanded(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _weeklyMenu == null
                ? _buildNoMenuCard()
                : Builder(
                    builder: (context) {
                      final weekdayIndex = _selectedDate.weekday % 7;
                      final dayMenu = _weeklyMenu?["$weekdayIndex"];
                      final dateKey = DateFormat("yyyy-MM-dd").format(_selectedDate);

                      if (dayMenu == null ||
                          (dayMenu["breakfast"] == null &&
                              dayMenu["lunch"] == null &&
                              dayMenu["snacks"] == null)) {
                        return _buildNoMenuCard();
                      }

                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (dayMenu["breakfast"] != null)
                            FoodTile(
                              keyName: "Breakfast-$weekdayIndex",
                              title:
                                  "Breakfast (${dayMenu["breakfast"]["price"]}₹)",
                              time: "8 : 30 am - 09 : 30 am",
                              items: dayMenu["breakfast"]["items"],
                              checked:
                                  _foodSelectionsByDate[dateKey]?["Breakfast"] ??
                                      false,
                              onChanged: (v) => _toggleFood("Breakfast", v),
                            ),
                          if (dayMenu["lunch"] != null)
                            FoodTile(
                              keyName: "Lunch-$weekdayIndex",
                              title:
                                  "Lunch (${dayMenu["lunch"]["price"]}₹)",
                              time: "12 : 30 pm - 01 : 30 pm",
                              items: dayMenu["lunch"]["items"],
                              checked:
                                  _foodSelectionsByDate[dateKey]?["Lunch"] ??
                                      false,
                              onChanged: (v) => _toggleFood("Lunch", v),
                            ),
                          if (dayMenu["snacks"] != null)
                            FoodTile(
                              keyName: "Snacks-$weekdayIndex",
                              title:
                                  "Snacks (${dayMenu["snacks"]["price"]}₹)",
                              time: "3 : 30 pm - 4 : 00 pm",
                              items: dayMenu["snacks"]["items"],
                              checked:
                                  _foodSelectionsByDate[dateKey]?["Snacks"] ??
                                      false,
                              onChanged: (v) => _toggleFood("Snacks", v),
                            ),
                        ],
                      );
                    },
                  ),
      ),

      // 🔹 Book button
      Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _foodSelectionsByDate.values
                  .any((day) => day.containsValue(true))
              ? _submitFoodForWeek
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _foodSelectionsByDate.values.any((day) => day.containsValue(true))
                    ? Colors.blue
                    : const Color(0xFFCCCCCC),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            "Book All Selected Days",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    ],
  );
}

// 🔹 Common card for "No menu"
Widget _buildNoMenuCard() {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: const [
              Icon(Icons.fastfood, size: 40, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                "No menu available for this day",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
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
          Text(
            day,
            style: TextStyle(
              fontSize: 10,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
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
  final List<dynamic> items;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const FoodTile({
    // <- NOT const
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
            fillColor: MaterialStateProperty.all(Colors.white), // white box
            checkColor: const Color(0xFF29ABE2), // blue tick
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
                            color:
                                Colors.black, // ✅ this should make name black
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
