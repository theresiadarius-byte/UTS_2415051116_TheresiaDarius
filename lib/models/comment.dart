/// Model Comment – satu komentar pengguna di tabel Supabase `comments`.
/// RLS aktif: hanya pemilik (user_id sama) yang bisa edit/hapus komentarnya.
class Comment {
  final String id;         // uuid primary key
  final String mealId;     // ID resep dari TheMealDB
  final String userId;     // anonymous user id dari Supabase Auth
  final String authorName; // nama yang diisi pengguna saat komentar
  final String content;    // isi komentar
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.mealId,
    required this.userId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  // Konversi dari Map Supabase ke objek Comment
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id:         map['id']          as String,
      mealId:     map['meal_id']     as String,
      userId:     map['user_id']     as String,
      authorName: map['author_name'] as String,
      content:    map['content']     as String,
      createdAt:  DateTime.parse(map['created_at'] as String),
    );
  }

  // Konversi ke Map untuk INSERT ke Supabase (tanpa id & created_at, diisi DB)
  Map<String, dynamic> toInsertMap() {
    return {
      'meal_id':     mealId,
      'user_id':     userId,
      'author_name': authorName,
      'content':     content,
    };
  }

  // Buat salinan Comment dengan field yang diubah (untuk UPDATE)
  Comment copyWith({String? content, String? authorName}) {
    return Comment(
      id:         id,
      mealId:     mealId,
      userId:     userId,
      authorName: authorName ?? this.authorName,
      content:    content    ?? this.content,
      createdAt:  createdAt,
    );
  }
}
