// screens/student/student_exams_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/widgets/student_app_bar.dart';
import 'student_menu_drawer.dart';
import '../../models/student_exam_model.dart';
import '../../services/exam_service.dart';
import 'package:intl/intl.dart';

class StudentExamsScreen extends StatefulWidget {

  final String studentId;

const StudentExamsScreen({super.key,required this.studentId});

  @override
  State<StudentExamsScreen> createState() => _StudentExamsScreenState();
}


class _StudentExamsScreenState extends State<StudentExamsScreen> {
  List<StudentExam> examList = [];
  bool isLoading = true;
  String errorMsg = '';

@override
void initState() {
  super.initState();
  loadExams();
}

Future<void> loadExams() async {
  try {
   final data = await ExamService.fetchExams(widget.studentId);

    setState(() {
      examList = data;
      isLoading = false;
    });
  } catch (e) {
    print('❌ Error fetching student exams: $e'); // 👈 Add this
    setState(() {
      errorMsg = 'Error loading exams';
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCDBB1),
      drawer: const StudentMenuDrawer(),
      appBar: const StudentAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  '< Back',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 16),

              // 📘 Title and Icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFF2E3192),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/exams.svg',
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Exams',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3192),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 📋 Exam List
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMsg.isNotEmpty
                    ? Center(child: Text(errorMsg))
                    : examList.isEmpty
                    ? const Center(child: Text('No exams found'))
                    : ListView.builder(
                        itemCount: examList.length,
                        itemBuilder: (context, index) {
                          final exam = examList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    exam.title,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2E3192),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
  ' ${DateFormat('d, MMM yyyy, h:mm a').format(exam.examDate.toLocal())}',
  style: const TextStyle(
    fontSize: 14,
    color: Colors.black87,
  ),
),
const SizedBox(height: 4),
Text(
  'Subject: ${exam.subject}',
  style: const TextStyle(
    fontSize: 14,
    color: Color(0xFF2E3192),
  ),
),

                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
