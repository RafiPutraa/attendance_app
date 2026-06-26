import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../location/presentation/screen/work_location_screen.dart';
import '../../../attendance/presentation/screen/attendance_screen.dart';
import '../../../report/presentation/screen/admin_report_screen.dart';
import '../../../login/presentation/cubit/auth_cubit.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AttendanceScreen(),
    const WorkLocationScreen(),
    const AdminReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return HomeBottomNav(
            currentIndex: _currentIndex,
            isAdmin: state.role == UserRole.admin,
            onTap: (index) => setState(() => _currentIndex = index),
          );
        },
      ),
    );
  }
}
