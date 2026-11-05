import 'package:flutter/foundation.dart';

import '../models/comment.dart';

/// CommentProvider – mengelola state komentar untuk satu resep.
/// Alur: Screen -> Provider (file ini) -> CommentRepository -> SupabaseService
///
/// CRUD lengkap akan diimplementasikan di Tahap 9–12.
/// Tahap ini hanya menyiapkan struktur state dan skeleton method.
class CommentProvider extends ChangeNotifier {
  List<Comment> _comments = [];
  // ignore: prefer_final_fields
  bool _isLoading = false;
  // ignore: prefer_final_fields
  String? _error;

  // Getters
  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  /// ID resep yang sedang ditampilkan komentarnya
  String? _currentMealId;
  String? get currentMealId => _currentMealId;

  // ── Methods – implementasi penuh di Tahap 9–12 ───────────────────────────

  /// Load komentar untuk satu resep dari Supabase
  Future<void> loadComments(String mealId) async {
    // Implementasi di Tahap 9
    _currentMealId = mealId;
    _comments = [];
    notifyListeners();
  }

  /// Tambah komentar baru
  Future<void> addComment({
    required String mealId,
    required String userId,
    required String authorName,
    required String content,
  }) async {
    // Implementasi di Tahap 10
  }

  /// Edit komentar (hanya milik sendiri)
  Future<void> updateComment({
    required String commentId,
    required String content,
  }) async {
    // Implementasi di Tahap 11
  }

  /// Hapus komentar (hanya milik sendiri)
  Future<void> deleteComment(String commentId) async {
    // Implementasi di Tahap 12
  }
}
