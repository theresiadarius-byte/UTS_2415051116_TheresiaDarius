import '../models/comment.dart';
import '../services/supabase_service.dart';

/// CommentRepository – operasi CRUD ke tabel `comments` di Supabase.
/// RLS aktif: INSERT/UPDATE/DELETE hanya bisa dilakukan pemilik komentar.
/// Alur: CommentProvider -> Repository (file ini) -> SupabaseService -> Supabase
class CommentRepository {
  static const _table = 'comments';

  // ── READ ──────────────────────────────────────────────────────────────────

  /// Ambil semua komentar untuk satu resep, diurutkan terbaru dulu.
  Future<List<Comment>> getComments(String mealId) async {
    final response = await SupabaseService.client
        .from(_table)
        .select()
        .eq('meal_id', mealId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => Comment.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ── CREATE (Tahap 10) ─────────────────────────────────────────────────────

  /// Tambah komentar baru. Mengembalikan Comment lengkap dengan id dari DB.
  Future<Comment> addComment({
    required String mealId,
    required String userId,
    required String authorName,
    required String content,
  }) async {
    final response = await SupabaseService.client
        .from(_table)
        .insert({
          'meal_id':     mealId,
          'user_id':     userId,
          'author_name': authorName,
          'content':     content,
        })
        .select()
        .single();

    return Comment.fromMap(response);
  }

  // ── UPDATE (Tahap 11) ─────────────────────────────────────────────────────

  /// Edit isi komentar. RLS di Supabase memastikan hanya pemilik yang bisa.
  Future<void> updateComment({
    required String id,
    required String content,
  }) async {
    await SupabaseService.client
        .from(_table)
        .update({'content': content})
        .eq('id', id)
        .eq('user_id', SupabaseService.currentUserId);
  }

  // ── DELETE (Tahap 12) ─────────────────────────────────────────────────────

  /// Hapus komentar berdasarkan id. RLS memastikan hanya pemilik yang bisa.
  Future<void> deleteComment(String id) async {
    await SupabaseService.client
        .from(_table)
        .delete()
        .eq('id', id)
        .eq('user_id', SupabaseService.currentUserId);
  }
}
