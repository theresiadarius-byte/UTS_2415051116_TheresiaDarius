import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// FavoriteScreen – menampilkan resep favorit pengguna.
/// Data favorit akan diambil dari Supabase di Tahap 9.
/// Saat ini menampilkan placeholder yang menjelaskan fitur ini.
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        title: Text(
          'My Favorites',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBrown,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false, // tidak ada tombol back (ini tab)
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ikon favorit dekoratif
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppTheme.palePink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 50,
                  color: AppTheme.primaryPink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Your Favorites',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Save your favorite cake recipes here.\nThey will be stored in your personal collection.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppTheme.medBrown,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '(Supabase integration coming in Stage 9)',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppTheme.medBrown,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
