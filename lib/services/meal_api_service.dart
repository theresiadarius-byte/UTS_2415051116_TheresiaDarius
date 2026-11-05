import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// MealApiService – komunikasi ke TheMealDB REST API.
/// Menangani error jaringan dengan pesan yang ramah (user-friendly).
class MealApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const Duration _timeout = Duration(seconds: 15);

  final http.Client _client;
  MealApiService({http.Client? client}) : _client = client ?? http.Client();

  // ── GET /filter.php?c=Dessert ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> fetchDesserts() async {
    final uri = Uri.parse('$_baseUrl/filter.php?c=Dessert');
    return _getList(uri);
  }

  // ── GET /search.php?s={query} ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> searchMeals(String query) async {
    final uri = Uri.parse('$_baseUrl/search.php?s=${Uri.encodeComponent(query)}');
    return _getList(uri);
  }

  // ── GET /lookup.php?i={id} ────────────────────────────────────────────────
  Future<Map<String, dynamic>?> fetchMealDetail(String id) async {
    final uri = Uri.parse('$_baseUrl/lookup.php?i=$id');
    final list = await _getList(uri);
    return list.isEmpty ? null : list.first;
  }

  // ── Helper: GET + parse list ──────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> _getList(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception(_httpErrorMessage(response.statusCode));
      }

      final body  = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = body['meals'] as List<dynamic>?;
      if (meals == null) return [];
      return meals.cast<Map<String, dynamic>>();

    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Could not reach the server. Please try again.');
    } on FormatException {
      throw Exception('Received unexpected data. Please try again.');
    } catch (e) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  /// Konversi HTTP status code ke pesan ramah
  String _httpErrorMessage(int statusCode) {
    return switch (statusCode) {
      400 => 'Invalid request. Please try again.',
      403 => 'Access denied.',
      404 => 'Recipe not found.',
      429 => 'Too many requests. Please wait a moment.',
      >= 500 => 'Server error. Please try again later.',
      _ => 'Network error ($statusCode). Please try again.',
    };
  }
}
