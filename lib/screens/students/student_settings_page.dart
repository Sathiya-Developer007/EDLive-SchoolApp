import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:school_app/providers/student_settings_provider.dart';
import 'student_menu_drawer.dart';
import 'package:school_app/widgets/student_app_bar.dart';

class StudentSettingsPage extends StatefulWidget {
  const StudentSettingsPage({super.key});

  @override
  State<StudentSettingsPage> createState() => _StudentSettingsPageState();
}

class _StudentSettingsPageState extends State<StudentSettingsPage> {
  int _selectedTab = 0;

  final List<String> settingsKeys = [
    'Achievements',
    'My to-do list',
    'PTA',
    'Library',
    'Syllabus',
    'Message', // ✅ Added
    'School bus', // ✅ Optional
    'Special care',
    'Co curricular activities',
    'Quick notes',
    'Resources',
  ];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<StudentSettingsProvider>(context);

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
          drawer: const StudentMenuDrawer(),
          body: Column(
            children: [
              const StudentAppBar(),
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
                            case 'Message':
                              value = settings.showMessage;
                              break; // ✅ Added
                            case 'School bus':
                              value = settings.showSchoolBus;
                              break; // ✅ Optional

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
                                    thumbColor:
                                        MaterialStateProperty.resolveWith<
                                          Color
                                        >(
                                          (states) =>
                                              states.contains(
                                                MaterialState.selected,
                                              )
                                              ? Colors.white
                                              : Colors.grey.shade400,
                                        ),
                                    trackColor:
                                        MaterialStateProperty.resolveWith<
                                          Color
                                        >(
                                          (states) =>
                                              states.contains(
                                                MaterialState.selected,
                                              )
                                              ? const Color(0xFF77FF00)
                                              : Colors.grey.shade300,
                                        ),
                                  ),
                                ),
                                child: SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
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
