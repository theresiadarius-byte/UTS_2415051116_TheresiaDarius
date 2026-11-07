import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/meal_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/category_card.dart';
import '../widgets/recipe_card.dart';
import '../widgets/section_heading.dart';
import '../widgets/state_view.dart';
import 'favorite_screen.dart';
import 'recipe_detail_screen.dart';
import 'recipe_list_screen.dart';

/// HomeScreen – halaman utama Sweet Bliss.
/// Membaca featured meals dari MealProvider (sudah di-load di main.dart).
/// Screen TIDAK memanggil API secara langsung.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categories = <Map<String, Object>>[
    {
      'key': 'cakes',
      'title': 'Aneka\nCake & Bolu',
      'label': 'Aneka Cake & Bolu',
      'icon': Icons.cake_outlined,
      'color': Color(0xFFF8DDE2),
    },
    {
      'key': 'tarts',
      'title': 'Pai &\nTart Manis',
      'label': 'Pai & Tart Manis',
      'icon': Icons.pie_chart_outline_rounded,
      'color': Color(0xFFF5E4E5),
    },
    {
      'key': 'puddings',
      'title': 'Puding &\nMousse',
      'label': 'Puding & Mousse',
      'icon': Icons.icecream_outlined,
      'color': Color(0xFFECE3F5),
    },
    {
      'key': 'cookies',
      'title': 'Kukis &\nRoti Manis',
      'label': 'Kukis & Roti Manis',
      'icon': Icons.cookie_outlined,
      'color': Color(0xFFF8EBD9),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _SearchBar(
              onTap: () {
                context.read<MealProvider>().filterByCategory('all');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecipeListScreen(showBackButton: true),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const _HeroBanner(),
            const SizedBox(height: 28),
            const _BenefitBar(),
            const SizedBox(height: 30),

            // ── Kategori ─────────────────────────────────────────────────
            const SectionHeading(subtitle: 'SPESIALIS KAMI', title: 'Kategori Kue Pilihan'),
            const SizedBox(height: 16),
            SizedBox(
              height: 128,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  return CategoryCard(
                    title: cat['title'] as String,
                    icon:  cat['icon']  as IconData,
                    color: cat['color'] as Color,
                    onTap: () {
                      final categoryKey = cat['key'] as String;
                      final categoryLabel = cat['label'] as String;
                      context.read<MealProvider>().filterByCategory(categoryKey);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeListScreen(
                            showBackButton: true,
                            categoryTitle: categoryLabel,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // ── Best Sellers – dari MealProvider ─────────────────────────
            const SectionHeading(subtitle: 'PALING DISUKAI', title: 'Resep Terpopuler'),
            const SizedBox(height: 16),

            // Consumer mendengarkan perubahan MealProvider
            Consumer<MealProvider>(
              builder: (context, provider, _) {
                return switch (provider.listStatus) {
                  // Sedang loading → spinner kecil
                  ProviderStatus.loading => const SizedBox(
                    height: 220,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryPink,
                        strokeWidth: 3,
                      ),
                    ),
                  ),

                  // Error → StateView dengan tombol retry
                  ProviderStatus.error => SizedBox(
                    height: 180,
                    child: StateView(
                      status: ViewStatus.error,
                      message: provider.listError,
                      onRetry: () => provider.loadDesserts(),
                    ),
                  ),

                  // Data tersedia → horizontal scroll RecipeCard
                  ProviderStatus.loaded => SizedBox(
                    height: 220,
                    child: provider.featuredMeals.isEmpty
                        ? const StateView(
                            status: ViewStatus.empty,
                            message: 'Belum ada resep pilihan',
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.featuredMeals.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 14),
                            itemBuilder: (context, i) {
                              final meal = provider.featuredMeals[i];
                              final cardWidth =
                                  (MediaQuery.of(context).size.width * 0.4)
                                      .clamp(140.0, 200.0);
                              return SizedBox(
                                width: cardWidth,
                                child: RecipeCard(
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
                                ),
                              );
                            },
                          ),
                  ),

                  _ => const SizedBox(height: 10),
                };
              },
            ),

            const SizedBox(height: 28),
            _buildPromoCard(),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Sweet Bliss  •  Dibuat dengan Sepenuh Hati ♥',
                style: GoogleFonts.poppins(
                  color: AppTheme.medBrown.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppTheme.palePink,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.cake_outlined, color: AppTheme.primaryPink, size: 28),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sweet Bliss',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkBrown,
              ),
            ),
            Text(
              'KUE  •  ROTI  •  KEBAHAGIAAN',
              style: GoogleFonts.poppins(fontSize: 8, letterSpacing: 1.2, color: AppTheme.medBrown),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.favorite_border, color: AppTheme.darkBrown),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoriteScreen(showBackButton: true)),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF57362F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PESANAN KHUSUS',
                    style: GoogleFonts.poppins(
                        color: AppTheme.lightPink, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('Dibuat Khusus\nUntuk Momen Anda',
                    style: GoogleFonts.playfairDisplay(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Sedikit manis untuk setiap perayaan berharga.',
                    style: GoogleFonts.poppins(color: const Color(0xFFE9D8D1), fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.local_florist_outlined, color: Color(0xFFF3C8D1), size: 65),
        ],
      ),
    );
  }
}

// ── HERO BANNER ───────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(colors: [Color(0xFFF4DADD), Color(0xFFFFEEE7)]),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(
            right: -15, bottom: -8,
            child: Icon(Icons.cake_rounded, size: 180, color: Color(0x33C2185B)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SEGAR DARI OVEN  •  DIBUAT DENGAN CINTA',
                    style: GoogleFonts.poppins(
                        fontSize: 9, letterSpacing: 1, color: const Color(0xFF8D505C), fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text('Hidup Lebih Manis\ndengan Kue',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 26, height: 1.2, fontWeight: FontWeight.bold, color: AppTheme.darkBrown)),
                const SizedBox(height: 8),
                Text('Setiap momen manis layak dirayakan\ndengan kelezatan penuh cinta.',
                    style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF775B54))),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    context.read<MealProvider>().filterByCategory('all');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecipeListScreen(showBackButton: true),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: AppTheme.primaryPink, borderRadius: BorderRadius.circular(25)),
                    child: Text('Jelajahi Aneka Kue  →',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
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

// ── BENEFIT BAR ───────────────────────────────────────────────────────────────
class _BenefitBar extends StatelessWidget {
  const _BenefitBar();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _BenefitItem(icon: Icons.eco_outlined,       title: 'Bahan\nBerkualitas')),
        Expanded(child: _BenefitItem(icon: Icons.cake_outlined,      title: 'Dipanggang\nSetiap Hari')),
        Expanded(child: _BenefitItem(icon: Icons.favorite_border,    title: 'Dibuat dengan\nCinta')),
      ],
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  const _BenefitItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryPink, size: 27),
        const SizedBox(height: 6),
        Text(title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 10, color: AppTheme.medBrown, height: 1.4)),
      ],
    );
  }
}

// ── SEARCH BAR (tap → navigasi ke RecipeListScreen) ──────────────────────────
class _SearchBar extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
            color: const Color(0xFFF9EEF2), borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppTheme.primaryPink, size: 20),
            const SizedBox(width: 10),
            Text('Cari resep kue lezat...',
                style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.medBrown)),
          ],
        ),
      ),
    );
  }
}
