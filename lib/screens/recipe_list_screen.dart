import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/meal_provider.dart';

import '../theme/app_theme.dart';
import '../widgets/recipe_card.dart';
import '../widgets/state_view.dart';
import 'recipe_detail_screen.dart';

/// RecipeListScreen – daftar resep dengan grid responsif.
/// Fitur: pencarian debounce, pull-to-refresh, dan SnackBar error.
class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// Debounce pencarian 500ms agar tidak spam API setiap ketik huruf
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<MealProvider>().searchMeals(query);
    });
  }

  /// Pull-to-refresh: reset search dan reload semua dessert
  Future<void> _onRefresh() async {
    _searchController.clear();
    await context.read<MealProvider>().loadDesserts();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Recipes refreshed!'),
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
          'Cake Recipes',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkBrown,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search bar ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search cake recipes...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.primaryPink),
                suffixIcon: AnimatedOpacity(
                  opacity: _searchController.text.isNotEmpty ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    color: AppTheme.medBrown,
                    onPressed: () {
                      _searchController.clear();
                      context.read<MealProvider>().searchMeals('');
                      setState(() {}); // update animasi suffix
                    },
                  ),
                ),
              ),
            ),
          ),

          // ── Info jumlah + hint pull-to-refresh ────────────────────────
          Consumer<MealProvider>(
            builder: (_, provider, __) {
              final count = provider.meals.length;
              final isSearch = _searchController.text.isNotEmpty;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                child: Row(
                  children: [
                    if (provider.listStatus == ProviderStatus.loaded)
                      Text(
                        isSearch
                            ? '$count result${count == 1 ? '' : 's'} found'
                            : '$count recipes',
                        style: GoogleFonts.poppins(
                          fontSize: 12, color: AppTheme.medBrown,
                        ),
                      ),
                    const Spacer(),
                    if (!isSearch)
                      Row(
                        children: [
                          const Icon(Icons.swipe_down_outlined, size: 13, color: AppTheme.medBrown),
                          const SizedBox(width: 4),
                          Text(
                            'Pull to refresh',
                            style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.medBrown),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),

          // ── Grid resep ────────────────────────────────────────────────
          Expanded(
            child: Consumer<MealProvider>(
              builder: (context, provider, _) {
                // Show error via SnackBar AND StateView
                return switch (provider.listStatus) {
                  ProviderStatus.loading => const StateView(status: ViewStatus.loading),

                  ProviderStatus.error => StateView(
                    status: ViewStatus.error,
                    message: provider.listError,
                    onRetry: () => provider.loadDesserts(),
                  ),

                  ProviderStatus.loaded => provider.meals.isEmpty
                      ? const StateView(
                          status: ViewStatus.empty,
                          message: 'No cake recipes found\nTry a different search term',
                        )
                      : _buildResponsiveGrid(context, provider),

                  _ => const StateView(status: ViewStatus.loading),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Grid responsif dengan pull-to-refresh menggunakan RefreshIndicator.
  Widget _buildResponsiveGrid(BuildContext context, MealProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int columns = switch (constraints.maxWidth) {
          > 900 => 4,
          > 600 => 3,
          _     => 2,
        };

        return RefreshIndicator(
          color: AppTheme.primaryPink,
          onRefresh: _onRefresh,
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            physics: const AlwaysScrollableScrollPhysics(), // wajib untuk pull-to-refresh
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:   columns,
              crossAxisSpacing: 14,
              mainAxisSpacing:  14,
              childAspectRatio: 0.75,
            ),
            itemCount: provider.meals.length,
            itemBuilder: (context, index) {
              final meal = provider.meals[index];
              return RecipeCard(
                mealId:    meal.id,
                mealName:  meal.name,
                mealThumb: meal.thumbnail,
                category:  meal.category ?? 'Dessert',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(
                      mealId:    meal.id,
                      mealName:  meal.name,
                      mealThumb: meal.thumbnail,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
