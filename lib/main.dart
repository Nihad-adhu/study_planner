import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'google_fonts.dart';
import 'providers/app_state_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (_) => StudyAppState(prefs),
      child: StudyPlannerApp(),
    ),
  );
}

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudyAppState>();
    final themeMode = state.themeMode;

    const primaryColor = Color(0xFF6366F1);
    const secondaryColor = Color(0xFF8B5CF6);

    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8F9FF),
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF0B1C30),
        elevation: 0,
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
        surfaceContainer: const Color(0xFFE5EEFF),
        onSurface: const Color(0xFF0B1C30),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B1C30),
      cardColor: const Color(0xFF213145),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF8B5CF6),
        secondary: Color(0xFF6366F1),
        surface: Color(0xFF213145),
        surfaceContainer: Color(0xFF0B1C30),
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );

    return MaterialApp(
      title: 'Lumina Study Planner',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const LoginScreen(),
    );
  }
}
