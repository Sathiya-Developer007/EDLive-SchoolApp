import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:school_app/widgets/teacher_app_bar.dart';

class TeacherSyllabusPage extends StatefulWidget {
  const TeacherSyllabusPage({super.key});

  @override
  State<TeacherSyllabusPage> createState() => _TeacherSyllabusPageState();
}

class _TeacherSyllabusPageState extends State<TeacherSyllabusPage> {
  String selectedClass = '10';

  List<String> subjects = [
    "English 1",
    "English 2",
    "Hindi",
    "Kannada",
    "Maths 1"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7D7A7),
      appBar: TeacherAppBar(),
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Padding(
  padding: const EdgeInsets.only(left: 16.0, top: 12),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Text(
          "< Back",
          style: TextStyle(fontSize: 16),
        ),
      ),
    ),
  ),
),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Container(
  padding: const EdgeInsets.all(6),
  decoration: BoxDecoration(
    color: const Color(0xFF2E3192), // background color
    borderRadius: BorderRadius.circular(6), // optional: make it rounded
  ),
  child: SvgPicture.asset(
    'assets/icons/syllabus.svg',
    height: 26,
    width: 26,
    color: Colors.white, // icon color becomes white for contrast
  ),
)
,
                const SizedBox(width: 8),
                const Text(
                  'Syllabus',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
              ],
            ),
          ),
        Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Text(
          'Class',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF4D4D4D)), // border color
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              isDense: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF808080), // dropdown arrow color
              ),
              value: selectedClass,
              items: List.generate(10, (index) {
                String cls = (index + 1).toString();
                return DropdownMenuItem(
                  value: cls,
                  child: Text(
                    cls,
                    style: const TextStyle(
                      color: Color(0xFF666666), // class number color
                    ),
                  ),
                );
              }),
              onChanged: (val) {
                setState(() {
                  selectedClass = val!;
                });
              },
            ),
          ),
        ),
      ],
    ),
  ),
),

          const SizedBox(height: 12),
     Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Add Subject Row
        Row(
          children: [
            const SizedBox(width: 8),

            // ⭕ Rounded + icon (larger)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF29ABE2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 13,
              ),
            ),

            const SizedBox(width: 8),
            const Text(
              "Add a subject",
              style: TextStyle(
                color: Color(0xFF29ABE2),
                fontSize: 16,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),

        const Divider(height: 1),

        // 🔹 Subject List
       Column(
  children: subjects.map((subject) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF999999),
            width: 0.3,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subject,
            style: const TextStyle(
              color: Color(0xFF2E3192),
              fontWeight: FontWeight.w500,
            ),
          ),
          SvgPicture.asset(
            'assets/icons/arrow_right.svg',
            height: 18,
            width: 18,
            color: Colors.black,
          ),
        ],
      ),
    );
  }).toList(),
),


        const SizedBox(height: 100), // 🔽 Extra space at bottom of white container
      ],
    ),
  ),
),
 
        ],
      ),
    );
  }
}
