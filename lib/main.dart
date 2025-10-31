import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/hive_service.dart';
import 'screens/match_setup_screen.dart';

Future<void> main() async {
  // Ensure Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await HiveService.initialize();

  runApp(const PadelPointApp());
}

// --- App Theme and Configuration ---
const Color _darkBackground = Color(0xFF121212);
const Color _darkAccentColor = Color(0xFFDFFF00);
const Color _lightAccentColor = Color(0xFF007BFF);
const Color _lightTextColor = Colors.white;
const Color _darkSurfaceColor = Color(0xFF1E1E1E);


class PadelPointApp extends StatefulWidget {
  const PadelPointApp({super.key});

  @override
  State<PadelPointApp> createState() => _PadelPointAppState();
}

class _PadelPointAppState extends State<PadelPointApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  void dispose() {
    HiveService.close(); // Close all boxes
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Padel Point',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        brightness: Brightness.light,
        primaryColor: _lightAccentColor,
        cardColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFF5F5F5),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black87),
          titleTextStyle: GoogleFonts.inter(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _lightAccentColor,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade200,
          labelStyle: const TextStyle(color: Colors.black54),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _lightAccentColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: _darkBackground,
        brightness: Brightness.dark,
        primaryColor: _darkAccentColor,
        cardColor: _darkSurfaceColor,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
          bodyColor: _lightTextColor,
          displayColor: _lightTextColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _darkBackground,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _darkAccentColor,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _darkSurfaceColor,
          labelStyle: const TextStyle(color: Colors.white70),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _darkAccentColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _darkSurfaceColor.withOpacity(0.5)),
          ),
        ),
      ),
      home: MatchSetupScreen(onThemeChanged: _toggleTheme, currentTheme: _themeMode),
    );
  }
}
