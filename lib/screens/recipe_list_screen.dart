import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/meal_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/recipe_card.dart';
import '../widgets/state_view.dart';
import 'recipe_detail_screen.dart';

/// RecipeListScreen – daftar resep dalam grid responsif.
/// Data dari MealProvider (TheMealDB API). Search memanggil provider.searchMeals().
/// Grid responsif: 2 kolom ponsel, 3 tablet kecil, 4 tablet besar/web.
class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce; // timer untuk debounce pencarian (hindari API call tiap ketik)

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// Dipanggil tiap kali teks search berubah.
  /// Debounce 500ms agar tidak memanggil API setiap satu huruf.
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<MealProvider>().searchMeals(query);
    });
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
        automaticallyImplyLeading: false, // ini tab, bukan pushed screen
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
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        color: AppTheme.medBrown,
                        onPressed: () {
                          _searchController.clear();
                          context.read<MealProvider>().searchMeals('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // ── Info jumlah + status ───────────────────────────────────────
          Consumer<MealProvider>(
            builder: (_, provider, __) {
              final count = provider.meals.length;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  provider.listStatus == ProviderStatus.loaded
                      ? '$count recipe${count == 1 ? '' : 's'} found'
                      : '',
                  style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.medBrown),
                ),
              );
            },
          ),

          // ── Grid resep ────────────────────────────────────────────────
          Expanded(
            child: Consumer<MealProvider>(
              builder: (context, provider, _) {
                return switch (provider.listStatus) {
                  // Loading
                  ProviderStatus.loading => const StateView(status: ViewStatus.loading),

                  // Error
                  ProviderStatus.error => StateView(
                    status: ViewStatus.error,
                    message: provider.listError,
                    onRetry: () => provider.loadDesserts(),
                  ),

                  // Data tersedia
                  ProviderStatus.loaded => provider.meals.isEmpty
                      ? const StateView(
                          status: ViewStatus.empty,
                          message: 'No cake recipes found',
                        )
                      : _buildResponsiveGrid(context, provider),

                  // Idle (belum pernah load) – biasanya singkat
                  _ => const StateView(status: ViewStatus.loading),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Grid responsif dengan LayoutBuilder:
  ///   < 600px   → 2 kolom (ponsel)
  ///   600–900px → 3 kolom (tablet kecil)
  ///   > 900px   → 4 kolom (tablet besar / web)
  Widget _buildResponsiveGrid(BuildContext context, MealProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int columns = switch (constraints.maxWidth) {
          > 900 => 4,
          > 600 => 3,
          _     => 2,
        };

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
        );
      },
    );
  }
}
