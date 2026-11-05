import '../models/favorite.dart';
import '../services/supabase_service.dart';

/// FavoriteRepository – operasi READ dan TOGGLE ke tabel `favorites` di Supabase.
/// RLS aktif: pengguna hanya bisa melihat dan mengubah favorit milik sendiri.
/// Alur: FavoriteProvider -> Repository (file ini) -> SupabaseService -> Supabase
class FavoriteRepository {
  static const _table = 'favorites';

  // ── READ ──────────────────────────────────────────────────────────────────

  /// Ambil semua favorit milik satu pengguna, diurutkan terbaru dulu.
  Future<List<Favorite>> getFavorites(String userId) async {
    final response = await SupabaseService.client
        .from(_table)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => Favorite.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ── CREATE ────────────────────────────────────────────────────────────────

  /// Tambah resep ke favorit. Mengembalikan Favorite lengkap dengan id dari DB.
  Future<Favorite> addFavorite({
    required String userId,
    required String mealId,
    required String mealName,
    required String mealThumb,
  }) async {
    final response = await SupabaseService.client
        .from(_table)
        .insert({
          'user_id':    userId,
          'meal_id':    mealId,
          'meal_name':  mealName,
          'meal_thumb': mealThumb,
        })
        .select()
        .single();

    return Favorite.fromMap(response);
  }

  // ── DELETE ────────────────────────────────────────────────────────────────

  /// Hapus satu entri favorit berdasarkan id.
  Future<void> removeFavorite(String favoriteId) async {
    await SupabaseService.client
        .from(_table)
        .delete()
        .eq('id', favoriteId);
  }
}
