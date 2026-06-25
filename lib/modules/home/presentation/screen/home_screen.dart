import 'package:flutter/material.dart';
import '../../../location/presentation/screen/work_location_screen.dart';
import '../../../attendance/presentation/screen/attendance_screen.dart';

import '../widgets/home_app_bar.dart';
import '../widgets/home_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AttendanceScreen(),
    const WorkLocationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
