// MODEL: Meal
// Mewakili satu resep dari TheMealDB API.
// Field disesuaikan dengan response JSON dari endpoint lookup.php dan search.php.
//
// Tahap ini hanya placeholder – implementasi lengkap ada di Tahap 6.

class Meal {
  final String id;
  final String name;
  final String category;
  final String thumbnail;
  final String? instructions;
  final String? area;

  const Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.thumbnail,
    this.instructions,
    this.area,
  });

  // Konversi dari JSON API ke objek Meal
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: json['strCategory'] as String? ?? '',
      thumbnail: json['strMealThumb'] as String? ?? '',
      instructions: json['strInstructions'] as String?,
      area: json['strArea'] as String?,
    );
  }
}
