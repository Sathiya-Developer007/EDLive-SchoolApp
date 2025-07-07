import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/students/student_profile_page.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onProfileTap;
  final int? studentId;                         // 👈 add this

  const CustomAppBar({
    super.key,
    this.onMenuPressed,
    this.onProfileTap,
    this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Column(
        children: [
          Container(height: 30, width: double.infinity, color: Colors.black),
          Expanded(
            child: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed:
                      onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: Row(
                children: [
                  const Text('Ed',
                      style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 24)),
                  const Text('Live',
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 24)),
                  const Spacer(),
                  SvgPicture.asset('assets/icons/notification.svg',
                      height: 24, width: 24, color: Colors.black),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onProfileTap ??
                        () {
                          if (studentId == null) return;          // safety
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudentProfilePage(studentId: studentId!), // ✅
                            ),
                          );
                        },
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF2E99EF),
                      backgroundImage: AssetImage('assets/images/child1.jpg'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
