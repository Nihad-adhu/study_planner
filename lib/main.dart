import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'google_fonts.dart';
import 'providers/app_state_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  // MUST be called before any plugin usage (SharedPreferences, etc.)
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-initialize SharedPreferences BEFORE runApp so it's available
  // synchronously when StudyAppState is constructed by Riverpod.
  final prefs = await SharedPreferences.getInstance();
  debugPrint('[main] SharedPreferences initialized successfully.');

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const StudyPlannerApp(),
    ),
  );
}

class StudyPlannerApp extends ConsumerWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyAppStateProvider);
    final themeMode = state.themeMode;

    // Design-System aligned themes
    const primaryColor = Color(0xFF6366F1); // Modern Indigo
    const secondaryColor = Color(0xFF8B5CF6); // Vibrant Purple

    // Light Theme Definition
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
        outline: Colors.grey.shade300,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF0B1C30),
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF0B1C30),
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // Dark Theme Definition
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
        primary: Color(0xFF8B5CF6), // Accent Purple in Dark Mode
        secondary: Color(0xFF6366F1),
        surface: Color(0xFF213145),
        surfaceContainer: Color(0xFF0B1C30),
        onSurface: Colors.white,
        outline: Colors.white10,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return AppStateProvider(
      notifier: state,
      child: MaterialApp(
        title: 'Lumina Study Planner',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: const LoginScreen(),
      ),
    );
  }
}
