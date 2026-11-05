import '../models/meal.dart';
import '../services/meal_api_service.dart';

/// MealRepository – logika bisnis seputar data resep.
/// Menjembatani MealProvider dengan MealApiService.
/// Alur: Provider -> Repository (file ini) -> MealApiService -> HTTP
///
/// Tanggung jawab:
///   - Memanggil MealApiService
///   - Mengkonversi JSON ke model Dart (Meal)
///   - Memfilter resep agar hanya yang bertema kue/dessert yang tampil
class MealRepository {
  final MealApiService _apiService;

  MealRepository(this._apiService);

  /// Kata kunci filter resep bertema kue.
  /// Dipakai untuk menyaring hasil search yang bukan dessert.
  static const _cakeKeywords = [
    'cake', 'cupcake', 'brownie', 'pie', 'tart', 'pudding',
    'pastry', 'muffin', 'cookie', 'biscuit', 'donut', 'crepe',
    'waffle', 'cheesecake',
  ];

  /// Cek apakah nama resep mengandung keyword bertema kue
  bool _isCakeRelated(String name) {
    final lower = name.toLowerCase();
    return _cakeKeywords.any((k) => lower.contains(k));
  }

  // ── Ambil semua dessert (untuk RecipeListScreen + HomeScreen featured) ─────
  /// Memanggil filter.php?c=Dessert → konversi ke List<Meal> (summary)
  Future<List<Meal>> getDesserts() async {
    final jsonList = await _apiService.fetchDesserts();
    return jsonList
        .map((json) => Meal.fromSummaryJson(json))
        .toList();
  }

  // ── Cari resep (untuk search di RecipeListScreen) ─────────────────────────
  /// Memanggil search.php?s={query} → filter hanya Dessert / cake keywords
  Future<List<Meal>> searchMeals(String query) async {
    final jsonList = await _apiService.searchMeals(query);

    return jsonList
        .map((json) => Meal.fromDetailJson(json))
        // Filter: hanya tampilkan yang kategori Dessert ATAU namanya bertema kue
        .where((meal) =>
            meal.category == 'Dessert' || _isCakeRelated(meal.name))
        .toList();
  }

  // ── Ambil detail satu resep (untuk RecipeDetailScreen) ───────────────────
  /// Memanggil lookup.php?i={id} → konversi ke Meal lengkap dengan bahan
  Future<Meal?> getMealDetail(String id) async {
    final json = await _apiService.fetchMealDetail(id);
    if (json == null) return null;
    return Meal.fromDetailJson(json);
  }
}
