/// Model Favorite – resep yang disimpan pengguna di tabel Supabase `favorites`.
/// Menyimpan snapshot data resep (name, thumb) supaya bisa ditampilkan
/// bahkan saat offline (tidak perlu panggil API lagi).
class Favorite {
  final String id;        // uuid primary key
  final String userId;    // anonymous user id dari Supabase Auth
  final String mealId;    // ID resep dari TheMealDB
  final String mealName;  // snapshot nama resep
  final String mealThumb; // snapshot URL thumbnail
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
      id:        map['id']         as String,
      userId:    map['user_id']    as String,
      mealId:    map['meal_id']    as String,
      mealName:  map['meal_name']  as String,
      mealThumb: map['meal_thumb'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Konversi ke Map untuk INSERT ke Supabase
  Map<String, dynamic> toInsertMap() {
    return {
      'user_id':    userId,
      'meal_id':    mealId,
      'meal_name':  mealName,
      'meal_thumb': mealThumb,
    };
  }
}
