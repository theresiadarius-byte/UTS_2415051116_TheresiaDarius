import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/home_screen.dart';

// Entry point aplikasi – inisialisasi .env sebelum runApp
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Muat file .env (berisi SUPABASE_URL dan SUPABASE_KEY)
  await dotenv.load(fileName: '.env');

  runApp(const SweetBlissApp());
}

class SweetBlissApp extends StatelessWidget {
  const SweetBlissApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sweet Bliss – Cake & Bakery Catalog',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFAF7),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC2185B)),
      ),
      home: const HomeScreen(),
    );
  }
}
