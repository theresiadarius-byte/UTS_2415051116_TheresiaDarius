import 'dart:convert';

import 'package:http/http.dart' as http;

/// MealApiService – komunikasi langsung ke TheMealDB REST API.
/// Alur: Provider -> Repository -> Service (file ini) -> HTTP
///
/// Endpoint yang digunakan:
///   GET /filter.php?c=Dessert  → list semua dessert (summary: id, name, thumb)
///   GET /search.php?s={q}      → cari resep by nama (full detail)
///   GET /lookup.php?i={id}     → detail satu resep by ID (full detail)
class MealApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  final http.Client _client;

  // Inject http.Client supaya bisa di-mock saat testing
  MealApiService({http.Client? client}) : _client = client ?? http.Client();

  // ── GET /filter.php?c=Dessert ─────────────────────────────────────────────
  /// Ambil semua resep kategori Dessert (hanya summary: id, name, thumb)
  Future<List<Map<String, dynamic>>> fetchDesserts() async {
    final uri = Uri.parse('$_baseUrl/filter.php?c=Dessert');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = body['meals'] as List<dynamic>?;
    if (meals == null) return [];

    return meals.cast<Map<String, dynamic>>();
  }

  // ── GET /search.php?s={query} ─────────────────────────────────────────────
  /// Cari resep berdasarkan nama – mengembalikan detail lengkap
  Future<List<Map<String, dynamic>>> searchMeals(String query) async {
    final uri = Uri.parse(
      '$_baseUrl/search.php?s=${Uri.encodeComponent(query)}',
    );
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal mencari resep (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = body['meals'] as List<dynamic>?;
    if (meals == null) return []; // null artinya tidak ada hasil

    return meals.cast<Map<String, dynamic>>();
  }

  // ── GET /lookup.php?i={id} ────────────────────────────────────────────────
  /// Ambil detail lengkap satu resep berdasarkan ID
  Future<Map<String, dynamic>?> fetchMealDetail(String id) async {
    final uri = Uri.parse('$_baseUrl/lookup.php?i=$id');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail resep (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = body['meals'] as List<dynamic>?;
    if (meals == null || meals.isEmpty) return null;

    return meals.first as Map<String, dynamic>;
  }
}
