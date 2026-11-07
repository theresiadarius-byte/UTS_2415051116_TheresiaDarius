import 'dart:convert';
import 'package:http/http.dart' as http;

/// TranslationService – layanan penerjemah online gratis menggunakan Google Translate (GTX)
/// untuk menerjemahkan teks instruksi resep ke Bahasa Indonesia secara fasih & alami.
class TranslationService {
  TranslationService._();

  // Cache memori agar tidak request berulang kali untuk teks yang sama
  static final Map<String, String> _cache = {};

  /// Menerjemahkan kalimat / paragraf bahasa Inggris ke Bahasa Indonesia.
  static Future<String> toIndonesian(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return trimmed;
    if (_cache.containsKey(trimmed)) return _cache[trimmed]!;

    try {
      final uri = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=id&dt=t&q=${Uri.encodeComponent(trimmed)}',
      );
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final buffer = StringBuffer();
        if (data.isNotEmpty && data[0] is List) {
          for (final item in data[0]) {
            if (item is List && item.isNotEmpty && item[0] != null) {
              buffer.write(item[0]);
            }
          }
        }
        final result = buffer.toString().trim();
        if (result.isNotEmpty) {
          _cache[trimmed] = result;
          return result;
        }
      }
    } catch (_) {
      // Jika offline atau jaringan lambat, fallback aman ke teks aslinya
    }

    return trimmed;
  }
}
