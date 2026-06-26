import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modules/location/data/models/location_model.dart';
import 'modules/location/presentation/cubit/location_cubit.dart';
import 'modules/attendance/presentation/cubit/attendance_cubit.dart';
import 'services/location_service.dart';
import 'modules/home/presentation/screen/home_screen.dart';
import 'modules/login/presentation/cubit/auth_cubit.dart';
import 'modules/login/presentation/screen/login_screen.dart';
import 'modules/report/data/models/log_model.dart';
import 'modules/report/presentation/cubit/log_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(LocationModelAdapter());
  Hive.registerAdapter(LogModelAdapter());

  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => LocationCubit()..init()),
        BlocProvider(create: (context) => AttendanceCubit(LocationService())),
        BlocProvider(create: (context) => LogCubit()..init()),
      ],
      child: MaterialApp(
        title: 'AttendanceApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF0F172A),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0D9488),
            brightness: Brightness.dark,
            surface: const Color(0xFF1E293B),
            primary: const Color(0xFF0D9488),
            secondary: const Color(0xFF334155),
          ),
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            Theme.of(context).textTheme,
          ).apply(bodyColor: Colors.white, displayColor: Colors.white),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state.isAuthenticated) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
