import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// SupabaseService – satu-satunya titik akses ke Supabase.
/// Alur: Provider -> Repository -> Service (file ini) -> Supabase
///
/// Gunakan [SupabaseService.client] untuk query tabel,
/// dan [SupabaseService.currentUserId] untuk RLS.
class SupabaseService {
  SupabaseService._(); // private constructor – jangan di-instantiate

  /// Client Supabase global
  static SupabaseClient get client => Supabase.instance.client;

  /// ID pengguna anonim yang sedang login
  static String get currentUserId => client.auth.currentUser?.id ?? '';

  /// True jika pengguna sudah login (anonim maupun registered)
  static bool get isAuthenticated => client.auth.currentUser != null;

  /// Inisialisasi Supabase dari .env dan login anonim.
  /// Dipanggil SEKALI di main() sebelum runApp().
  static Future<void> initialize() async {
    final url     = dotenv.env['SUPABASE_URL']     ?? '';
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    if (url.isEmpty || anonKey.isEmpty) {
      // Hentikan jika .env belum diisi – tampilkan pesan jelas
      throw Exception(
        '.env belum dikonfigurasi.\n'
        'Salin .env.example → .env lalu isi SUPABASE_URL dan SUPABASE_ANON_KEY.',
      );
    }

    await Supabase.initialize(url: url, anonKey: anonKey); // ignore: deprecated_member_use

    // Anonymous sign-in: session persisten di storage lokal.
    // Tiap perangkat punya user_id unik, dipakai RLS tabel comments & favorites.
    if (!isAuthenticated) {
      await client.auth.signInAnonymously();
    }
  }
}
