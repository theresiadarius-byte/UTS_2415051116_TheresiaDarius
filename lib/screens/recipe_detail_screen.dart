import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// RecipeDetailScreen – detail satu resep.
/// Data dasar (nama, thumb) di-pass dari layar sebelumnya.
/// Detail lengkap (instruksi, bahan) akan dimuat dari API di Tahap 8.
/// Komentar akan ditambahkan di Tahap 9–12.
class RecipeDetailScreen extends StatelessWidget {
  final String mealId;
  final String mealName;
  final String mealThumb;

  const RecipeDetailScreen({
    super.key,
    required this.mealId,
    this.mealName  = '',
    this.mealThumb = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: CustomScrollView(
        slivers: [
          // ── App bar dengan gambar hero ───────────────────────────────
          SliverAppBar(
            expandedHeight: 290,
            pinned: true,                // app bar tetap terlihat saat scroll
            backgroundColor: AppTheme.warmCream,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              // Judul hanya tampil saat di-collapse
              title: Text(
                mealName,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar hero
                  CachedNetworkImage(
                    imageUrl: mealThumb,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppTheme.palePink,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryPink,
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppTheme.palePink,
                      child: const Center(
                        child: Icon(
                          Icons.cake_outlined,
                          size: 80,
                          color: AppTheme.primaryPink,
                        ),
                      ),
                    ),
                  ),
                  // Gradient gelap di bawah supaya teks judul terbaca
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Konten detail ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama resep (judul besar)
                  Text(
                    mealName,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Label kategori + area
                  Wrap(
                    spacing: 8,
                    children: [
                      const _Chip(label: 'Dessert'),
                      _Chip(label: 'ID: $mealId'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Placeholder bahan – diisi dari API Tahap 8
                  const _SectionTitle(title: 'Ingredients'),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.palePink.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Ingredients will be loaded from API in Stage 8.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppTheme.medBrown,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Placeholder instruksi – diisi dari API Tahap 8
                  const _SectionTitle(title: 'Instructions'),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.palePink.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Step-by-step instructions will be loaded from TheMealDB API in Stage 8.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppTheme.medBrown,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Placeholder komentar – diisi dari Supabase Tahap 9
                  const _SectionTitle(title: 'Comments'),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.palePink.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Comments will be connected to Supabase in Stage 9.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppTheme.medBrown,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── HELPER WIDGETS ─────────────────────────────────────────────────────────────
/// Judul dalam seksi (Ingredients, Instructions, dsb.)
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.darkBrown,
      ),
    );
  }
}

/// Label chip kecil (Dessert, ID, dsb.)
class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.lightPink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: AppTheme.primaryPink,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
