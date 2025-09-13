import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import '../../models/student_syllabus_detail_model.dart';
import '../../services/student_syllabus_detail_service.dart';

class SyllabusDetailPage extends StatefulWidget {
  final int classId;
  final int subjectId;
  final String academicYear;
  final String subjectName;

  const SyllabusDetailPage({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.academicYear,
    required this.subjectName,
  });

  @override
  State<SyllabusDetailPage> createState() => _SyllabusDetailPageState();
}

class _SyllabusDetailPageState extends State<SyllabusDetailPage> {
  late Future<List<SyllabusDetail>> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = SyllabusService()
        .fetchSyllabusDetail(widget.classId, widget.subjectId, widget.academicYear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF91C1BC), // ✅ same background as syllabus page
      appBar: StudentAppBar(),
      drawer: StudentMenuDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Copy header design
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('< Back',
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E3192),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/syllabus.svg',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.subjectName, // ✅ show subject name here
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3192),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ✅ syllabus detail body
            Expanded(
              child: FutureBuilder<List<SyllabusDetail>>(
                future: _detailFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("Error: ${snapshot.error}",
                            style: const TextStyle(color: Colors.red)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No syllabus details found"));
                  }

                  final details = snapshot.data!;
                  return ListView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: details.length,
  itemBuilder: (context, index) {
    final detail = details[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail.term,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3192),
              ),
            ),
            const SizedBox(height: 8),
            ...detail.items.asMap().entries.map(
              (entry) {
                final itemIndex = entry.key + 1; // numbering starts from 1
                final item = entry.value;

                return ListTile(
  contentPadding: EdgeInsets.zero,
  title: Text(
    "$itemIndex. ${item.title.isNotEmpty ? item.title : 'No title'}",
    style: const TextStyle(fontWeight: FontWeight.w600),
  ),
  subtitle: Text(item.description.isNotEmpty ? item.description : "No description"),
);

              },
            ),
          ],
        ),
      ),
    );
  },
);
 },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
