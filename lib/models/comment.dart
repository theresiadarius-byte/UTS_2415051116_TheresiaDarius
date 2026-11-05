// MODEL: Comment
// Mewakili komentar pengguna di tabel Supabase `comments`.
// Setiap komentar terkait dengan meal_id dan user_id (anonymous).
//
// Tahap ini hanya placeholder – implementasi lengkap ada di Tahap 6.

class Comment {
  final String id;
  final String mealId;
  final String userId;
  final String authorName;
  final String content;
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
      id: map['id'] as String,
      mealId: map['meal_id'] as String,
      userId: map['user_id'] as String,
      authorName: map['author_name'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Konversi dari objek Comment ke Map untuk dikirim ke Supabase
  Map<String, dynamic> toMap() {
    return {
      'meal_id': mealId,
      'user_id': userId,
      'author_name': authorName,
      'content': content,
    };
  }
}
