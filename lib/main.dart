import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'google_fonts.dart';
import 'providers/app_state_provider.dart';
import 'screens/auth_wrapper.dart';

import 'screens/firebase_error_screen.dart';
import 'firebase_options.dart';

bool isFirebaseConfigured = false;
String firebaseInitializationError = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AuthService.isFirebaseInitialized = true;
    isFirebaseConfigured = true;
    debugPrint('[Firebase] Initialized successfully with options.');
  } catch (e) {
    AuthService.isFirebaseInitialized = false;
    isFirebaseConfigured = false;
    firebaseInitializationError = e.toString();
    debugPrint('[Firebase] Initialization failed: $e');
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (_) => StudyAppState(prefs),
      child: const StudyPlannerApp(),
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
      home: isFirebaseConfigured
          ? const AuthWrapper()
          : FirebaseConfigurationErrorScreen(error: firebaseInitializationError),
    );
  }
}
