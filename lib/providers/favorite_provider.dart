import 'package:flutter/foundation.dart';

import '../models/favorite.dart';

/// FavoriteProvider – mengelola shared state favorit.
/// Shared state artinya data ini diakses dari BANYAK screen sekaligus:
///   - RecipeDetailScreen (tombol ♥ add/remove favorit)
///   - FavoriteScreen (daftar semua favorit)
///   - RecipeCard (ikon ♥ di kartu)
///
/// Karena dipakai di banyak tempat, WAJIB pakai Provider (bukan setState lokal).
/// Alur: Screen -> Provider (file ini) -> FavoriteRepository -> SupabaseService
///
/// Implementasi penuh di Tahap 9–12.
class FavoriteProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<Favorite> _favorites = [];
  // ignore: prefer_final_fields
  bool _isLoading = false;
  String? _error;

  // Set meal ID yang difavoritkan – O(1) lookup saat cek isFavorite
  final Set<String> _favoriteMealIds = {};

  // Getters
  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Cek apakah sebuah resep sudah difavoritkan oleh pengguna ini
  bool isFavorite(String mealId) => _favoriteMealIds.contains(mealId);

  // ── Methods – implementasi penuh di Tahap 9–12 ───────────────────────────

  /// Load semua favorit milik pengguna dari Supabase
  Future<void> loadFavorites(String userId) async {
    // Implementasi di Tahap 9
    notifyListeners();
  }

  /// Tambah resep ke favorit
  Future<void> addFavorite({
    required String userId,
    required String mealId,
    required String mealName,
    required String mealThumb,
  }) async {
    // Implementasi di Tahap 10
  }

  /// Hapus resep dari favorit
  Future<void> removeFavorite(String favoriteId, String mealId) async {
    // Implementasi di Tahap 12
  }
}
