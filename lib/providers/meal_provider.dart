import 'package:flutter/foundation.dart';

import '../models/meal.dart';
import '../repositories/meal_repository.dart';

/// Enum status untuk state provider.
/// Lebih jelas dibandingkan bool isLoading karena menunjukkan 4 kondisi berbeda.
enum ProviderStatus { idle, loading, loaded, error }

/// MealProvider – mengelola semua state terkait resep.
/// Alur: Screen -> Provider (file ini) -> MealRepository -> MealApiService
///
/// State dibagi tiga bagian:
///   1. listState  → untuk RecipeListScreen (daftar + pencarian)
///   2. detailState → untuk RecipeDetailScreen (satu resep lengkap)
///   3. featuredMeals → getter dari listState, dipakai HomeScreen
class MealProvider extends ChangeNotifier {
  final MealRepository _repository;

  MealProvider(this._repository);

  // ── State: Daftar Resep (RecipeListScreen + HomeScreen featured) ──────────
  List<Meal> _allDesserts = []; // cache semua dessert (tidak berubah saat search)
  List<Meal> _meals = [];      // resep yang tampil saat ini (bisa hasil search/filter)
  ProviderStatus _listStatus = ProviderStatus.idle;
  String _listError = '';
  String _activeCategory = 'all'; // kategori yang sedang aktif

  List<Meal> get meals => _meals;
  ProviderStatus get listStatus => _listStatus;
  String get listError => _listError;
  String get activeCategory => _activeCategory;

  /// Kata kunci filter yang akurat sesuai koleksi resep di TheMealDB
  static const Map<String, List<String>> categoryKeywords = {
    'cakes': ['cake', 'gateau', 'sponge', 'torte'],
    'tarts': ['tart', 'pie', 'crumble'],
    'puddings': ['pudding', 'mousse', 'budyń', 'fudge', 'souffle', 'clafoutis', 'mess'],
    'cookies': ['cookie', 'biscuit', 'bun', 'pancake', 'donut', 'doughnut', 'waffle', 'ghoriba', 'rogaliki', 'roll'],
  };

  /// 6 resep pertama dari dessert cache – untuk tampilan featured di HomeScreen
  List<Meal> get featuredMeals => _allDesserts.take(6).toList();

  // ── State: Detail Resep (RecipeDetailScreen) ──────────────────────────────
  Meal? _selectedMeal;
  ProviderStatus _detailStatus = ProviderStatus.idle;
  String _detailError = '';

  Meal? get selectedMeal => _selectedMeal;
  ProviderStatus get detailStatus => _detailStatus;
  String get detailError => _detailError;

  // ── Methods ───────────────────────────────────────────────────────────────

  /// Load semua dessert dari TheMealDB.
  /// Dipanggil satu kali saat Provider dibuat (di main.dart).
  /// Hasilnya dipakai oleh HomeScreen (featured) dan RecipeListScreen (semua).
  Future<void> loadDesserts() async {
    // Jangan load ulang jika sedang loading
    if (_listStatus == ProviderStatus.loading) return;

    _listStatus = ProviderStatus.loading;
    _listError = '';
    notifyListeners();

    try {
      final meals = await _repository.getDesserts();
      _allDesserts = meals; // simpan cache
      _applyCurrentFilter(); // terapkan filter jika ada
      _listStatus = ProviderStatus.loaded;
    } catch (e) {
      _listError = e.toString().replaceAll('Exception: ', '');
      _listStatus = ProviderStatus.error;
    }

    notifyListeners();
  }

  /// Filter resep berdasarkan kategori terpilih ('all', 'birthday', 'anniversary', 'theme', 'cupcake').
  void filterByCategory(String categoryKey) {
    _activeCategory = categoryKey;
    _applyCurrentFilter();
    _listStatus = ProviderStatus.loaded;
    notifyListeners();
  }

  void _applyCurrentFilter() {
    if (_activeCategory == 'all') {
      _meals = List.from(_allDesserts);
      return;
    }

    final keywords = categoryKeywords[_activeCategory] ?? [];
    final filtered = _allDesserts.where((meal) {
      final name = meal.name.toLowerCase();
      return keywords.any((k) => name.contains(k));
    }).toList();

    // Jika ada hasil, gunakan hasil filter; jika sangat sedikit tetap tampilkan hasil filter
    _meals = filtered.isNotEmpty ? filtered : List.from(_allDesserts);
  }

  /// Cari resep berdasarkan query.
  /// Jika query kosong → kembalikan sesuai kategori aktif.
  /// Jika ada query → panggil API search, filter hasil bertema kue.
  Future<void> searchMeals(String query) async {
    final trimmed = query.trim();

    // Query kosong → reset ke cache sesuai kategori aktif
    if (trimmed.isEmpty) {
      _applyCurrentFilter();
      _listStatus = ProviderStatus.loaded;
      notifyListeners();
      return;
    }

    _listStatus = ProviderStatus.loading;
    _listError = '';
    notifyListeners();

    try {
      final meals = await _repository.searchMeals(trimmed);
      _meals = meals;
      _listStatus = ProviderStatus.loaded;
    } catch (e) {
      _listError = e.toString().replaceAll('Exception: ', '');
      _listStatus = ProviderStatus.error;
    }

    notifyListeners();
  }

  /// Load detail lengkap satu resep (bahan + instruksi).
  /// Dipanggil saat RecipeDetailScreen dibuka.
  Future<void> loadMealDetail(String mealId) async {
    _detailStatus = ProviderStatus.loading;
    _detailError = '';
    _selectedMeal = null;
    notifyListeners();

    try {
      final meal = await _repository.getMealDetail(mealId);
      _selectedMeal = meal;

      if (meal != null) {
        _detailStatus = ProviderStatus.loaded;
      } else {
        _detailError = 'Recipe not found';
        _detailStatus = ProviderStatus.error;
      }
    } catch (e) {
      _detailError = e.toString().replaceAll('Exception: ', '');
      _detailStatus = ProviderStatus.error;
    }

    notifyListeners();
  }
}
