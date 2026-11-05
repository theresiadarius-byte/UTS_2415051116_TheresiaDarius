import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_provider.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/recipe_card.dart';
import '../widgets/state_view.dart';
import 'recipe_detail_screen.dart';

/// FavoriteScreen – daftar resep favorit dengan pull-to-refresh.
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    await context
        .read<FavoriteProvider>()
        .loadFavorites(SupabaseService.currentUserId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Favorites refreshed!'),
          backgroundColor: AppTheme.primaryPink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

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
        automaticallyImplyLeading: false,
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
              onRetry: () => provider.loadFavorites(SupabaseService.currentUserId),
            );
          }

          // ── Kosong ───────────────────────────────────────────────────
          if (provider.favorites.isEmpty) {
            return _buildEmptyState(context, provider);
          }

          // ── Daftar favorit dengan pull-to-refresh ────────────────────
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${provider.favorites.length} saved recipe${provider.favorites.length == 1 ? '' : 's'}',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.medBrown),
                    ),
                    const Spacer(),
                    const Icon(Icons.swipe_down_outlined, size: 13, color: AppTheme.medBrown),
                    const SizedBox(width: 4),
                    Text(
                      'Pull to refresh',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.medBrown),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: RefreshIndicator(
                    color: AppTheme.primaryPink,
                    onRefresh: () => _onRefresh(context),
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                          category:  'Favorite ♥',
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, FavoriteProvider provider) {
    return RefreshIndicator(
      color: AppTheme.primaryPink,
      onRefresh: () => _onRefresh(context),
      child: ListView(
        // ListView agar pull-to-refresh bisa berjalan di empty state
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
        ],
      ),
    );
  }
}
