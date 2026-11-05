import 'package:flutter/foundation.dart';

import '../models/favorite.dart';
import '../repositories/favorite_repository.dart';

/// FavoriteProvider – state management favorit.
/// Shared state → dipakai di banyak screen (Detail, FavoriteScreen, RecipeCard).
/// Alur: Screen -> Provider (file ini) -> FavoriteRepository -> Supabase
///
/// _favoriteMealIds  – Set<String> untuk isFavorite() O(1)
/// _favoriteIdMap    – Map mealId→favoriteId untuk delete tanpa search
class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository _repository;

  FavoriteProvider(this._repository);

  List<Favorite> _favorites = [];
  bool _isLoading = false;
  String? _error;

  // Lookup cepat O(1)
  final Set<String> _favoriteMealIds = {};
  final Map<String, String> _favoriteIdMap = {}; // mealId → favoriteId

  // Getters
  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Cek apakah resep sudah difavoritkan oleh pengguna ini
  bool isFavorite(String mealId) => _favoriteMealIds.contains(mealId);

  // ── READ (Tahap 9) ────────────────────────────────────────────────────────

  /// Load semua favorit milik pengguna.
  /// Dipanggil saat Provider dibuat di main.dart.
  Future<void> loadFavorites(String userId) async {
    if (userId.isEmpty) return; // belum login

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _favorites = await _repository.getFavorites(userId);

      // Rebuild Set & Map untuk lookup cepat
      _favoriteMealIds.clear();
      _favoriteIdMap.clear();
      for (final fav in _favorites) {
        _favoriteMealIds.add(fav.mealId);
        _favoriteIdMap[fav.mealId] = fav.id;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
    }

    notifyListeners();
  }

  // ── TOGGLE (Tahap 9) ──────────────────────────────────────────────────────

  /// Toggle favorit: jika sudah favorit → hapus, jika belum → tambah.
  /// Menyimpan snapshot mealName & mealThumb agar FavoriteScreen
  /// bisa tampil bahkan saat offline.
  Future<void> toggleFavorite({
    required String userId,
    required String mealId,
    required String mealName,
    required String mealThumb,
  }) async {
    _error = null;

    if (isFavorite(mealId)) {
      // ── HAPUS FAVORIT ────────────────────────────────────────────────────
      final favId = _favoriteIdMap[mealId]!;
      try {
        await _repository.removeFavorite(favId);
        _favorites.removeWhere((f) => f.mealId == mealId);
        _favoriteMealIds.remove(mealId);
        _favoriteIdMap.remove(mealId);
      } catch (e) {
        _error = e.toString().replaceAll('Exception: ', '');
      }
    } else {
      // ── TAMBAH FAVORIT ───────────────────────────────────────────────────
      try {
        final fav = await _repository.addFavorite(
          userId:    userId,
          mealId:    mealId,
          mealName:  mealName,
          mealThumb: mealThumb,
        );
        _favorites.insert(0, fav);
        _favoriteMealIds.add(mealId);
        _favoriteIdMap[mealId] = fav.id;
      } catch (e) {
        _error = e.toString().replaceAll('Exception: ', '');
      }
    }

    notifyListeners();
  }
}
