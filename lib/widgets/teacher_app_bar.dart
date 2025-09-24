import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/screens/teachers/teacher_notifiction_page.dart';


class TeacherAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onProfileTap;

  const TeacherAppBar({
    Key? key,
    this.onMenuPressed,
    this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
        height: 63,
        child: Column(
          children: [
            
            // ⬜ Main AppBar content
            Expanded(
              child: AppBar(
                backgroundColor: Colors.white,
                elevation: 4, // optional shadow below
                automaticallyImplyLeading: false,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                title: Row(
  children: [
    const Text(
      'Ed',
      style: TextStyle(
        color: Colors.indigo,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),
    const Text(
      'Live',
      style: TextStyle(
        color: Colors.lightBlue,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),
    const Spacer(),

    // ✅ Notification icon with navigation
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NotificationPage()),
        );
      },
      child: SvgPicture.asset(
        'assets/icons/notification.svg',
        height: 24,
        width: 24,
        color: Colors.black,
      ),
    ),

    const SizedBox(width: 16),

    GestureDetector(
      onTap: onProfileTap ?? () {
        Navigator.pushNamed(context, '/profile');
      },
      child: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
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
  

  @override
  Size get preferredSize => const Size.fromHeight(100); // 30 (top bar) + 70 (AppBar)
}
