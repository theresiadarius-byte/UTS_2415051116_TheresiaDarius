import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Kartu resep – widget reusable yang dipakai di HomeScreen,
/// RecipeListScreen, dan FavoriteScreen.
/// Menampilkan thumbnail, nama resep, dan kategori.
class RecipeCard extends StatelessWidget {
  final String mealId;
  final String mealName;
  final String mealThumb;
  final String? category;   // opsional (tidak semua tampilan perlu)
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.mealId,
    required this.mealName,
    required this.mealThumb,
    this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardSurface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPink.withValues(alpha: 0.1),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Gambar thumbnail ─────────────────────────────────────────
            Expanded(
              flex: 3,
              child: CachedNetworkImage(
                imageUrl: mealThumb,
                fit: BoxFit.cover,
                width: double.infinity,
                // Tampilan saat gambar sedang dimuat
                placeholder: (_, __) => Container(
                  color: AppTheme.palePink,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryPink,
                    ),
                  ),
                ),
                // Tampilan jika gambar gagal dimuat
                errorWidget: (_, __, ___) => Container(
                  color: AppTheme.palePink,
                  child: const Center(
                    child: Icon(
                      Icons.cake_outlined,
                      size: 42,
                      color: AppTheme.primaryPink,
                    ),
                  ),
                ),
              ),
            ),

            // ── Info resep ───────────────────────────────────────────────
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label kategori (jika ada)
                    if (category != null) ...[
                      Text(
                        category!.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          letterSpacing: 0.8,
                          color: AppTheme.primaryPink,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                    ],
                    // Nama resep
                    Text(
                      mealName,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkBrown,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
