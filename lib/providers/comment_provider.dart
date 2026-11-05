import 'package:flutter/foundation.dart';

import '../models/comment.dart';
import '../repositories/comment_repository.dart';
import '../services/supabase_service.dart';

/// CommentProvider – state management komentar.
/// Alur: Screen -> Provider (file ini) -> CommentRepository -> Supabase
///
/// State:
///   _comments      – daftar komentar yang tampil
///   _isLoading     – apakah sedang proses
///   _error         – pesan error jika ada
///   _currentMealId – ID resep yang sedang ditampilkan
class CommentProvider extends ChangeNotifier {
  final CommentRepository _repository;

  CommentProvider(this._repository);

  List<Comment> _comments = [];
  bool _isLoading = false;
  String? _error;
  String _currentMealId = '';

  // Getters
  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentMealId => _currentMealId;

  /// ID user yang sedang login (dari Supabase Auth).
  /// Dipakai di UI untuk menentukan apakah komentar milik sendiri.
  String get currentUserId => SupabaseService.currentUserId;

  // ── READ (Tahap 9) ────────────────────────────────────────────────────────

  /// Load semua komentar untuk satu resep.
  /// Dipanggil di RecipeDetailScreen.initState().
  Future<void> loadComments(String mealId) async {
    _currentMealId = mealId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _comments = await _repository.getComments(mealId);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
    }

    notifyListeners();
  }

  // ── CREATE (Tahap 10) ─────────────────────────────────────────────────────

  /// Tambah komentar baru dan reload daftar.
  Future<bool> addComment({
    required String authorName,
    required String content,
  }) async {
    _error = null;
    try {
      final comment = await _repository.addComment(
        mealId:     _currentMealId,
        userId:     currentUserId,
        authorName: authorName,
        content:    content,
      );
      // Tambah di awal list (terbaru di atas) tanpa reload penuh
      _comments.insert(0, comment);
      notifyListeners();
      return true; // sukses
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false; // gagal
    }
  }

  // ── UPDATE (Tahap 11) ─────────────────────────────────────────────────────

  /// Edit isi komentar berdasarkan id.
  Future<bool> updateComment({
    required String commentId,
    required String content,
  }) async {
    _error = null;
    try {
      await _repository.updateComment(id: commentId, content: content);

      // Update lokal agar UI langsung berubah tanpa reload
      final idx = _comments.indexWhere((c) => c.id == commentId);
      if (idx != -1) {
        _comments[idx] = _comments[idx].copyWith(content: content);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ── DELETE (Tahap 12) ─────────────────────────────────────────────────────

  /// Hapus komentar berdasarkan id.
  Future<bool> deleteComment(String commentId) async {
    _error = null;
    try {
      await _repository.deleteComment(commentId);
      _comments.removeWhere((c) => c.id == commentId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
