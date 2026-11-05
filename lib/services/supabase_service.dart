// SERVICE: SupabaseService
// Bertanggung jawab untuk komunikasi langsung ke Supabase.
// Menangani operasi CRUD pada tabel `comments` dan `favorites`.
// Alur: Screen -> Provider -> Repository -> Service (file ini) -> Supabase
//
// Tahap ini hanya placeholder – implementasi lengkap ada di Tahap 9.

class SupabaseService {
  // Tabel yang digunakan:
  // - comments(id, meal_id, user_id, author_name, content, created_at)
  // - favorites(id, user_id, meal_id, meal_name, meal_thumb, created_at)
  //
  // RLS (Row Level Security) aktif: user hanya bisa edit/hapus data miliknya.
  // Anonymous Sign-In dipakai agar tiap pengguna punya user_id unik.

  // Implementasi akan ditambahkan di Tahap 9
}
