import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard.dart';

// Global Supabase client accessor for easy reference across your app
final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase backend
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_PROJECT_URL', // Replace with your Supabase Project URL
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with your Supabase Anon Key
  );

  runApp(const TabangApp());
}

class TabangApp extends StatefulWidget {
  const TabangApp({super.key});

  @override
  State<TabangApp> createState() => _TabangAppState();
}

class _TabangAppState extends State<TabangApp> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TABANG',

      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFD3D3D3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFF181818),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),

      themeMode: themeMode,

      home: Dashboard(
        themeMode: themeMode,
        onThemeChanged: (mode) {
          setState(() {
            themeMode = mode;
          });
        },
      ),
    );
  }
}