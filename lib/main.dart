import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/comment_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/meal_provider.dart';
import 'repositories/meal_repository.dart';
import 'screens/main_screen.dart';
import 'services/meal_api_service.dart';
import 'theme/app_theme.dart';

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
    return MultiProvider(
      // Daftarkan semua provider di sini – tersedia di seluruh widget tree
      providers: [
        ChangeNotifierProvider(
          // Buat MealProvider dengan dependency injection:
          // MealProvider ← MealRepository ← MealApiService
          // Langsung panggil loadDesserts() supaya data siap saat screen terbuka
          create: (_) => MealProvider(
            MealRepository(MealApiService()),
          )..loadDesserts(),
        ),
        ChangeNotifierProvider(
          create: (_) => CommentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sweet Bliss – Cake & Bakery Catalog',
        theme: AppTheme.theme,
        home: const MainScreen(),
      ),
    );
  }
}
