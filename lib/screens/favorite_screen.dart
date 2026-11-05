import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/recipe_card.dart';
import '../widgets/state_view.dart';
import 'recipe_detail_screen.dart';

/// FavoriteScreen – menampilkan resep yang difavoritkan pengguna.
/// Data diambil dari tabel `favorites` Supabase via FavoriteProvider.
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
            fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkBrown,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false, // ini tab, bukan pushed screen
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, _) {
          // ── Loading ──────────────────────────────────────────────────
          if (provider.isLoading) {
            return const StateView(status: ViewStatus.loading);
          }

          // ── Error ────────────────────────────────────────────────────
          if (provider.error != null) {
            return StateView(
              status: ViewStatus.error,
              message: provider.error,
            );
          }

          // ── Kosong ───────────────────────────────────────────────────
          if (provider.favorites.isEmpty) {
            return _buildEmptyState(context);
          }

          // ── Daftar favorit ───────────────────────────────────────────
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    '${provider.favorites.length} saved recipe${provider.favorites.length == 1 ? '' : 's'}',
                    style: GoogleFonts.poppins(
                      fontSize: 12, color: AppTheme.medBrown,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:   2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing:  14,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: provider.favorites.length,
                    itemBuilder: (context, index) {
                      final fav = provider.favorites[index];
                      return RecipeCard(
                        mealId:    fav.mealId,
                        mealName:  fav.mealName,
                        mealThumb: fav.mealThumb,
                        category:  'Favorite',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(
                              mealId:    fav.mealId,
                              mealName:  fav.mealName,
                              mealThumb: fav.mealThumb,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Tampilan saat belum ada favorit ──────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100, height: 100,
              decoration: const BoxDecoration(
                color: AppTheme.palePink, shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded, size: 50, color: AppTheme.primaryPink,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Favorites Yet',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.darkBrown,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap the ♥ button on any recipe\nto save it here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13, color: AppTheme.medBrown, height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
