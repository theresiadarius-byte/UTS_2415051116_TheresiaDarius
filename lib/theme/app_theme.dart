import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema dan konstanta warna Sweet Bliss.
/// Semua nilai dikumpulkan di sini supaya konsisten di seluruh aplikasi.
class AppTheme {
  // ── Palet Warna ──────────────────────────────────────────────────────────
  static const Color primaryPink  = Color(0xFFC2185B); // rose pink utama
  static const Color lightPink    = Color(0xFFF8BBD0); // pink muda
  static const Color palePink     = Color(0xFFFCE4EC); // pink sangat muda
  static const Color darkBrown    = Color(0xFF4E342E); // cokelat tua (teks)
  static const Color medBrown     = Color(0xFF795548); // cokelat sedang
  static const Color warmCream    = Color(0xFFFFFAF7); // latar halaman
  static const Color cardSurface  = Color(0xFFFFFFFF); // latar kartu
  static const Color dividerColor = Color(0xFFF3E0E5); // garis pemisah

  // ── Tema Utama ────────────────────────────────────────────────────────────
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPink,
        primary: primaryPink,
        surface: warmCream,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: warmCream,

      // Poppins sebagai font dasar seluruh aplikasi
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),

      // AppBar tanpa shadow, latar krem
      appBarTheme: AppBarTheme(
        backgroundColor: warmCream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: darkBrown,
        ),
        iconTheme: const IconThemeData(color: darkBrown),
      ),

      // NavigationBar bawah
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black12,
        indicatorColor: lightPink,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryPink, size: 24);
          }
          return const IconThemeData(color: medBrown, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primaryPink,
            );
          }
          return GoogleFonts.poppins(fontSize: 11, color: medBrown);
        }),
      ),

      // Input (TextField, SearchBar)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9EEF2),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryPink, width: 1.5),
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: medBrown,
        ),
      ),

      // Tombol utama pink
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle:
              GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
