import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

// Entry point – muat .env sebelum runApp
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
      theme: AppTheme.theme,
      // Gunakan MainScreen sebagai home – NavigationBar sudah ada di dalamnya
      home: const MainScreen(),
    );
  }
}
