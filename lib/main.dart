import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/comment_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/meal_provider.dart';
import 'repositories/comment_repository.dart';
import 'repositories/favorite_repository.dart';
import 'repositories/meal_repository.dart';
import 'screens/main_screen.dart';
import 'services/meal_api_service.dart';
import 'services/supabase_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Muat variabel dari file .env
  await dotenv.load(fileName: '.env');

  // 2. Inisialisasi Supabase + anonymous sign-in
  //    Dibungkus try-catch agar app tidak stuck jika terjadi error jaringan
  try {
    await SupabaseService.initialize();
  } catch (e) {
    debugPrint('[Supabase] Gagal inisialisasi: $e');
    // App tetap berjalan; fitur komentar & favorit tidak akan bekerja
  }

  runApp(const SweetBlissApp());
}

class SweetBlissApp extends StatelessWidget {
  const SweetBlissApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // MealProvider: load semua dessert langsung saat dibuat
        ChangeNotifierProvider(
          create: (_) => MealProvider(
            MealRepository(MealApiService()),
          )..loadDesserts(),
        ),

        // CommentProvider: inject CommentRepository
        // loadComments() dipanggil dari RecipeDetailScreen.initState()
        ChangeNotifierProvider(
          create: (_) => CommentProvider(CommentRepository()),
        ),

        // FavoriteProvider: inject FavoriteRepository + load langsung
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(FavoriteRepository())
            ..loadFavorites(SupabaseService.currentUserId),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sweet Bliss – Katalog Kue & Roti',
        theme: AppTheme.theme,
        home: const MainScreen(),
      ),
    );
  }
}
