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
  List<Meal> _meals = [];      // resep yang tampil saat ini (bisa hasil search)
  ProviderStatus _listStatus = ProviderStatus.idle;
  String _listError = '';

  List<Meal> get meals => _meals;
  ProviderStatus get listStatus => _listStatus;
  String get listError => _listError;

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
      _meals = meals;       // tampilkan semua
      _listStatus = ProviderStatus.loaded;
    } catch (e) {
      _listError = e.toString().replaceAll('Exception: ', '');
      _listStatus = ProviderStatus.error;
    }

    notifyListeners();
  }

  /// Cari resep berdasarkan query.
  /// Jika query kosong → kembalikan semua dessert dari cache.
  /// Jika ada query → panggil API search, filter hasil bertema kue.
  Future<void> searchMeals(String query) async {
    final trimmed = query.trim();

    // Query kosong → reset ke cache semua dessert
    if (trimmed.isEmpty) {
      _meals = List.from(_allDesserts);
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
