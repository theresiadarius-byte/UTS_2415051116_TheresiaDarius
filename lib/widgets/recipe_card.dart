import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../utils/recipe_translator.dart';

/// RecipeCard – kartu resep reusable untuk grid dan list horizontal.
///
/// Layout: gambar (flex 3) + info teks (flex 2).
/// Semua teks dibatasi maxLines + ellipsis agar tidak overflow.
class RecipeCard extends StatelessWidget {
  final String mealId;
  final String mealName;
  final String mealThumb;
  final String? category;
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
          borderRadius: BorderRadius.circular(16),
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
                placeholder: (_, __) => Container(
                  color: AppTheme.palePink,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppTheme.primaryPink,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppTheme.palePink,
                  child: const Center(
                    child: Icon(
                      Icons.cake_outlined, size: 42, color: AppTheme.primaryPink,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Label kategori
                    if (category != null)
                      Text(
                        (category!.contains('♥')
                                ? category!
                                : RecipeTranslator.translateCategory(category))
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 9, letterSpacing: 0.6,
                          color: AppTheme.primaryPink, fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (category != null) const SizedBox(height: 2),

                    // Nama resep – max 2 baris
                    Flexible(
                      child: Text(
                        mealName,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkBrown,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
