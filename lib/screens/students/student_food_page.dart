import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StudentFoodPage(),
  ));
}

class StudentFoodPage extends StatelessWidget {
  const StudentFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDC87D), // background same as screenshot
      appBar:StudentAppBar(),
      drawer: StudentMenuDrawer(),
         body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back + Title
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
              shape: BoxShape.circle,
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
              color: Colors.black,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.chevron_left),
                    Text("Aug. 2019",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Icon(Icons.chevron_right),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dayTile("Mon.", "15", false),
                    _dayTile("Tue.", "16", true),
                    _dayTile("Wed.", "17", false),
                    _dayTile("Thu.", "18", false),
                    _dayTile("Fri.", "19", false),
                    _dayTile("Sat.", "20", false),
                    _dayTile("Sun.", "21", false),
                  ],
                )
              ],
            ),
          ),

          // Food items list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                FoodTile(
                  title: "Breakfast (50₹)",
                  time: "8 : 30 am - 09 : 30 am",
                  description: "Dosa Varities, Boiled Egg/ Omlette, Sambar, Vada",
                  checked: true,
                ),
                SizedBox(height: 10),
                FoodTile(
                  title: "Lunch (100₹)",
                  time: "12 : 30 pm - 01 : 30 pm",
                  description:
                      "Steamed Rice, Sambar, Rasam, Curd (Yogurt), Poriyal (stir-fried vegetables), Kootu (vegetable + lentil curry), Appalam (papad), Pickle, Buttermilk",
                  checked: true,
                ),
                SizedBox(height: 10),
                FoodTile(
                  title: "Snacks (20₹)",
                  time: "3 : 30 pm - 4 : 00 pm",
                  description: "Fruit Salad, Milk",
                  checked: false,
                ),
              ],
            ),
          ),

          // Pay button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
              onPressed: () {},
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          Text(day,
              style: TextStyle(
                  fontSize: 12,
                  color: selected ? Colors.white : Colors.black)),
          Text(date,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : Colors.black)),
        ],
      ),
    );
  }
}

// Food Item Widget
class FoodTile extends StatelessWidget {
  final String title;
  final String time;
  final String description;
  final bool checked;

  const FoodTile({
    super.key,
    required this.title,
    required this.time,
    required this.description,
    this.checked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(value: checked, onChanged: (_) {}),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Text(time, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          const Text("Item Description",
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Text(description,
              style: const TextStyle(color: Colors.black, fontSize: 14)),
        ],
      ),
    );
  }
}
