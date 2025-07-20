import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:school_app/providers/teacher_settings_provider.dart';
import 'teacher_menu_drawer.dart';
import 'package:school_app/widgets/teacher_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedTab = 0;

  final List<String> settingsKeys = [
    'Achievements',
    'My to-do list',
    'PTA',
    'Library',
    'Syllabus',
    'Special care',
    'Co curricular activities',
    'Quick notes',
    'Resources'
  ];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: const MenuDrawer(), // ✅ Using your new custom drawer
          body: Column(
            children: [
              const TeacherAppBar(),
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: _selectedTab == 0
                    ? ListView.builder(
                        itemCount: settingsKeys.length,
                        itemBuilder: (context, index) {
                          final key = settingsKeys[index];
                          bool value;
                          switch (key) {
                            case 'Achievements':
                              value = settings.showAchievements;
                              break;
                            case 'My to-do list':
                              value = settings.showTodo;
                              break;
                            case 'PTA':
                              value = settings.showPTA;
                              break;
                            case 'Library':
                              value = settings.showLibrary;
                              break;
                            case 'Syllabus':
                              value = settings.showSyllabus;
                              break;
                            case 'Special care':
                              value = settings.showSpecialCare;
                              break;
                            case 'Co curricular activities':
                              value = settings.showCoCurricular;
                              break;
                            case 'Quick notes':
                              value = settings.showQuickNotes;
                              break;
                            case 'Resources':
                              value = settings.showResources;
                              break;
                            default:
                              value = false;
                          }

                return Column(
  children: [
    Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color>(
            (states) => states.contains(MaterialState.selected)
                ? Colors.white // white thumb when ON
                : Colors.grey.shade400, // default thumb
          ),
          trackColor: MaterialStateProperty.resolveWith<Color>(
            (states) => states.contains(MaterialState.selected)
                ? const Color(0xFF77FF00) // green track when ON
                : Colors.grey.shade300, // default track
          ),
        ),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(key),
        value: value,
        tileColor: Colors.transparent,
        onChanged: (bool newValue) {
          settings.updateVisibility(key, newValue);
        },
      ),
    ),
    if (index < settingsKeys.length - 1)
      const Divider(height: 0, indent: 16),
  ],
);
       },
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          const SizedBox(height: 50),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: const Color(0xFF29ABE2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "Reset password",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _noSplashButton({
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }

  // Widget _buildAppBar() {
  //   return PreferredSize(
  //     preferredSize: const Size.fromHeight(70),
  //     child: Container(
  //       decoration: const BoxDecoration(
  //         color: Colors.white,
  //         border: Border(bottom: BorderSide(color: Colors.black, width: 2.0)),
  //       ),
  //       child: AppBar(
  //         backgroundColor: Colors.transparent,
  //         elevation: 0,
  //         toolbarHeight: 70,
  //         automaticallyImplyLeading: false,
  //         leading: Builder(
  //           builder: (context) => _noSplashButton(
  //             onPressed: () => Scaffold.of(context).openDrawer(),
  //             child: const Icon(Icons.menu, color: Colors.black),
  //           ),
  //         ),
  //         title: Row(
  //           children: [
  //             const Text(
  //               'Ed',
  //               style: TextStyle(
  //                 color: Colors.indigo,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 24,
  //               ),
  //             ),
  //             const Text(
  //               'Live',
  //               style: TextStyle(
  //                 color: Colors.lightBlue,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 24,
  //               ),
  //             ),
  //             const Spacer(),
  //             _noSplashButton(
  //               onPressed: () {},
  //               child: SvgPicture.asset(
  //                 'assets/icons/notification.svg',
  //                 height: 24,
  //                 width: 24,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             _noSplashButton(
  //               onPressed: () => Navigator.pushNamed(context, '/profile'),
  //               child: const CircleAvatar(
  //                 backgroundColor: Colors.grey,
  //                 child: Icon(Icons.person, color: Colors.white),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _noSplashButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "< Back",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                padding: const EdgeInsets.all(9),
                decoration: const BoxDecoration(
                  color: Color(0xFF2E3192),
                  shape: BoxShape.rectangle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/settings.svg',
                  color: Colors.white,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 13),
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 34,
                  color: Color(0xFF292E84),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _noSplashButton(
              onPressed: () => setState(() => _selectedTab = 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "Customize dashboard",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _selectedTab == 0
                            ? const Color(0xFF29ABE2)
                            : Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 2,
                    width: 120,
                    color: _selectedTab == 0
                        ? const Color(0xFF29ABE2)
                        : Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _noSplashButton(
              onPressed: () => setState(() => _selectedTab = 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "Other settings",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _selectedTab == 1
                            ? const Color(0xFF29ABE2)
                            : Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 2,
                    width: 120,
                    color: _selectedTab == 1
                        ? const Color(0xFF29ABE2)
                        : Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
