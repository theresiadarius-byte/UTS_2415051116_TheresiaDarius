/// Satu bahan resep dari TheMealDB.
/// Dibuat dari pasangan strIngredientN + strMeasureN.
class Ingredient {
  final String name;    // nama bahan, misal "Flour"
  final String measure; // takaran, misal "2 cups"

  const Ingredient({required this.name, required this.measure});
}

/// Model Meal dari TheMealDB API.
/// TheMealDB mengembalikan dua jenis response:
///  1. Summary (dari filter.php / search.php awal) – hanya id, name, thumb
///  2. Detail  (dari lookup.php)                   – semua field + 20 bahan
class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String? category;
  final String? area;
  final String? instructions;
  final String? youtubeUrl;
  final String? tags;
  final List<Ingredient> ingredients; // daftar bahan (dari detail response)

  const Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category,
    this.area,
    this.instructions,
    this.youtubeUrl,
    this.tags,
    this.ingredients = const [],
  });

  // ── Factory: dari response SUMMARY (filter.php / search awal) ─────────────
  factory Meal.fromSummaryJson(Map<String, dynamic> json) {
    return Meal(
      id:        json['idMeal']       as String,
      name:      json['strMeal']      as String,
      thumbnail: json['strMealThumb'] as String,
    );
  }

  // ── Factory: dari response DETAIL (lookup.php) ────────────────────────────
  factory Meal.fromDetailJson(Map<String, dynamic> json) {
    // TheMealDB menyimpan bahan di strIngredient1..20 dan strMeasure1..20
    final ingredients = <Ingredient>[];
    for (int i = 1; i <= 20; i++) {
      final ingredientName = (json['strIngredient$i'] as String? ?? '').trim();
      final measure        = (json['strMeasure$i']    as String? ?? '').trim();
      // Hanya tambahkan jika nama bahan tidak kosong
      if (ingredientName.isNotEmpty) {
        ingredients.add(Ingredient(name: ingredientName, measure: measure));
      }
    }

    return Meal(
      id:           json['idMeal']          as String,
      name:         json['strMeal']         as String,
      thumbnail:    json['strMealThumb']    as String,
      category:     json['strCategory']     as String?,
      area:         json['strArea']         as String?,
      instructions: json['strInstructions'] as String?,
      youtubeUrl:   json['strYoutube']      as String?,
      tags:         json['strTags']         as String?,
      ingredients:  ingredients,
    );
  }

  // ── Helper: apakah resep ini bertema kue? ────────────────────────────────
  bool get isCakeRelated {
    const keywords = [
      'cake', 'cupcake', 'brownie', 'pie', 'tart', 'pudding',
      'pastry', 'muffin', 'cookie', 'biscuit', 'donut', 'crepe',
      'waffle', 'cheesecake', 'dessert', 'sweet',
    ];
    final lower = name.toLowerCase();
    return keywords.any((k) => lower.contains(k));
  }
}
