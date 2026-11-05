// MODEL: Favorite
// Mewakili resep yang disimpan pengguna di tabel Supabase `favorites`.
//
// Tahap ini hanya placeholder – implementasi lengkap ada di Tahap 6.

class Favorite {
  final String id;
  final String userId;
  final String mealId;
  final String mealName;
  final String mealThumb;
  final DateTime createdAt;

  const Favorite({
    required this.id,
    required this.userId,
    required this.mealId,
    required this.mealName,
    required this.mealThumb,
    required this.createdAt,
  });

  // Konversi dari Map Supabase ke objek Favorite
  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      mealId: map['meal_id'] as String,
      mealName: map['meal_name'] as String,
      mealThumb: map['meal_thumb'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Konversi ke Map untuk insert ke Supabase
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'meal_id': mealId,
      'meal_name': mealName,
      'meal_thumb': mealThumb,
    };
  }
}
