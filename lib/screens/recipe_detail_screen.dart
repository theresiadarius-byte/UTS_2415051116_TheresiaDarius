import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/state_view.dart';

/// RecipeDetailScreen – detail lengkap satu resep.
///
/// Data awal (mealName, mealThumb) di-pass dari layar sebelumnya
/// supaya AppBar bisa langsung tampil. Detail lengkap (bahan + instruksi)
/// dimuat dari API melalui MealProvider di initState.
class RecipeDetailScreen extends StatefulWidget {
  final String mealId;
  final String mealName;  // data awal dari navigasi (AppBar langsung tampil)
  final String mealThumb; // data awal dari navigasi (gambar langsung tampil)

  const RecipeDetailScreen({
    super.key,
    required this.mealId,
    this.mealName  = '',
    this.mealThumb = '',
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Muat detail setelah frame pertama (context sudah tersedia)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealProvider>().loadMealDetail(widget.mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, provider, _) {
        // Gunakan data yang di-pass sebagai fallback saat loading
        final meal  = provider.selectedMeal;
        final name  = meal?.name      ?? widget.mealName;
        final thumb = meal?.thumbnail ?? widget.mealThumb;

        return Scaffold(
          backgroundColor: AppTheme.warmCream,
          body: CustomScrollView(
            slivers: [
              // ── SliverAppBar dengan gambar hero ──────────────────────
              SliverAppBar(
                expandedHeight: 290,
                pinned: true,
                backgroundColor: AppTheme.darkBrown,
                foregroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gambar thumbnail dari API
                      CachedNetworkImage(
                        imageUrl: thumb,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: AppTheme.palePink,
                          child: const Center(
                            child: CircularProgressIndicator(color: AppTheme.primaryPink),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppTheme.palePink,
                          child: const Center(
                            child: Icon(Icons.cake_outlined, size: 80, color: AppTheme.primaryPink),
                          ),
                        ),
                      ),
                      // Gradient gelap supaya teks judul terbaca
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end:   Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Konten berubah sesuai status ─────────────────────────
              SliverToBoxAdapter(
                child: switch (provider.detailStatus) {
                  ProviderStatus.loading => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: StateView(status: ViewStatus.loading),
                  ),

                  ProviderStatus.error => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: StateView(
                      status: ViewStatus.error,
                      message: provider.detailError,
                      onRetry: () =>
                          context.read<MealProvider>().loadMealDetail(widget.mealId),
                    ),
                  ),

                  ProviderStatus.loaded when meal != null =>
                      _buildDetail(context, meal),

                  _ => const SizedBox(height: 20),
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Detail konten setelah loaded ──────────────────────────────────────────
  Widget _buildDetail(BuildContext context, Meal meal) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul besar
          Text(
            meal.name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.darkBrown,
            ),
          ),
          const SizedBox(height: 10),

          // Chip kategori & area
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (meal.category != null) _Chip(label: meal.category!),
              if (meal.area     != null) _Chip(label: '🌍 ${meal.area!}'),
              if (meal.tags     != null && meal.tags!.isNotEmpty)
                ...meal.tags!
                    .split(',')
                    .take(3)
                    .map((t) => _Chip(label: t.trim())),
            ],
          ),

          const SizedBox(height: 28),

          // ── Daftar Bahan ────────────────────────────────────────────
          const _SectionTitle(title: 'Ingredients'),
          const SizedBox(height: 12),

          meal.ingredients.isEmpty
              ? _placeholder('No ingredients available')
              : Column(
                  children: meal.ingredients
                      .map((ing) => _IngredientRow(ingredient: ing))
                      .toList(),
                ),

          const SizedBox(height: 28),

          // ── Instruksi ───────────────────────────────────────────────
          const _SectionTitle(title: 'Instructions'),
          const SizedBox(height: 12),

          meal.instructions == null
              ? _placeholder('No instructions available')
              : _buildInstructions(meal.instructions!),

          const SizedBox(height: 28),

          // ── Komentar (placeholder) ────────────────────────────────
          const _SectionTitle(title: 'Comments'),
          const SizedBox(height: 12),
          _placeholder('Comments connected to Supabase in Stage 9'),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Tampilkan instruksi yang dipecah per paragraf/baris kosong
  Widget _buildInstructions(String raw) {
    // Pisahkan per paragraf (baris kosong ganda)
    final steps = raw
        .split(RegExp(r'\r?\n(\r?\n)+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.asMap().entries.map((entry) {
        final i    = entry.key + 1;
        final step = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nomor langkah
              Container(
                width: 26,
                height: 26,
                margin: const EdgeInsets.only(right: 10, top: 2),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryPink,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$i',
                  style: GoogleFonts.poppins(
                    color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Teks langkah
              Expanded(
                child: Text(
                  step,
                  style: GoogleFonts.poppins(
                    fontSize: 13, color: AppTheme.darkBrown, height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _placeholder(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.palePink.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        msg,
        style: GoogleFonts.poppins(
          fontSize: 13, color: AppTheme.medBrown, fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

// ── HELPER WIDGETS ─────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkBrown,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.lightPink, borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11, color: AppTheme.primaryPink, fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Satu baris bahan: nama di kiri, takaran di kanan
class _IngredientRow extends StatelessWidget {
  final dynamic ingredient; // Ingredient object dari models/meal.dart

  const _IngredientRow({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: AppTheme.primaryPink),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              ingredient.name as String,
              style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.darkBrown),
            ),
          ),
          Text(
            ingredient.measure as String,
            style: GoogleFonts.poppins(
              fontSize: 12, color: AppTheme.medBrown, fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
