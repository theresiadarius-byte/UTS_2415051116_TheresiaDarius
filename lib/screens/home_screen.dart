import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/recipe_detail_screen.dart';
import '../screens/recipe_list_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/category_card.dart';
import '../widgets/recipe_card.dart';
import '../widgets/section_heading.dart';

/// HomeScreen – halaman utama Sweet Bliss.
/// Menampilkan banner, kategori, dan best sellers (data dummy sementara).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Kategori kue yang tampil di bagian "Explore Our Cakes"
  static const _categories = <Map<String, Object>>[
    {
      'title': 'Birthday\nCakes',
      'icon': Icons.cake_outlined,
      'color': Color(0xFFF8DDE2),
    },
    {
      'title': 'Anniversary',
      'icon': Icons.favorite_border,
      'color': Color(0xFFF5E4E5),
    },
    {
      'title': 'Theme\nCakes',
      'icon': Icons.celebration_outlined,
      'color': Color(0xFFECE3F5),
    },
    {
      'title': 'Cupcakes',
      'icon': Icons.bakery_dining_outlined,
      'color': Color(0xFFF8EBD9),
    },
  ];

  // Data dummy best sellers – akan diganti data API di Tahap 8
  static const _bestSellers = <Map<String, String>>[
    {
      'id':    'dummy_home_1',
      'name':  'Chocolate Gateau',
      'thumb': 'https://www.themealdb.com/images/media/meals/tqrsvv1511555086.jpg',
    },
    {
      'id':    'dummy_home_2',
      'name':  'Victoria Sponge',
      'thumb': 'https://www.themealdb.com/images/media/meals/wyrqqq1468233628.jpg',
    },
    {
      'id':    'dummy_home_3',
      'name':  'Carrot Cake',
      'thumb': 'https://www.themealdb.com/images/media/meals/vrspxv1511722107.jpg',
    },
    {
      'id':    'dummy_home_4',
      'name':  'Bakewell Tart',
      'thumb': 'https://www.themealdb.com/images/media/meals/vqpwrv1511723001.jpg',
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
            // ── Header ────────────────────────────────────────────────────
            _buildHeader(context),

            const SizedBox(height: 20),

            // ── Search bar (tap navigasi ke RecipeListScreen) ─────────────
            _SearchBar(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RecipeListScreen(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Hero banner ───────────────────────────────────────────────
            const _HeroBanner(),

            const SizedBox(height: 28),

            // ── Benefit bar (3 keunggulan) ────────────────────────────────
            const _BenefitBar(),

            const SizedBox(height: 30),

            // ── Kategori ──────────────────────────────────────────────────
            const SectionHeading(
              subtitle: 'OUR SPECIALITY',
              title: 'Explore Our Cakes',
            ),
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
                    // Tap kategori buka RecipeListScreen (filter nanti di Tahap 8)
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecipeListScreen(),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // ── Best Sellers ──────────────────────────────────────────────
            const SectionHeading(
              subtitle: 'MOST LOVED',
              title: 'Our Best Sellers',
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _bestSellers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, i) {
                  final meal = _bestSellers[i];
                  return SizedBox(
                    width: 155,
                    // Reusable widget RecipeCard
                    child: RecipeCard(
                      mealId:    meal['id']!,
                      mealName:  meal['name']!,
                      mealThumb: meal['thumb']!,
                      category:  'Dessert',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(
                            mealId:    meal['id']!,
                            mealName:  meal['name']!,
                            mealThumb: meal['thumb']!,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            // ── Banner promosi custom cake ────────────────────────────────
            _buildPromoCard(),

            const SizedBox(height: 20),

            // Footer
            Center(
              child: Text(
                'Sweet Bliss  •  Baked With Love ♥',
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

  // ── Header (logo + ikon aksi) ─────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Logo ikon kue
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppTheme.palePink,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.cake_outlined,
            color: AppTheme.primaryPink,
            size: 28,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sweet Bliss',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBrown,
              ),
            ),
            Text(
              'CAKES  •  BAKES  •  HAPPINESS',
              style: GoogleFonts.poppins(
                fontSize: 8,
                letterSpacing: 1.2,
                color: AppTheme.medBrown,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Tombol favorit di header
        IconButton(
          icon: const Icon(Icons.favorite_border, color: AppTheme.darkBrown),
          onPressed: () {},
        ),
      ],
    );
  }

  // ── Banner promosi cokelat tua ────────────────────────────────────────────
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
                Text(
                  'CUSTOM CAKES',
                  style: GoogleFonts.poppins(
                    color: AppTheme.lightPink,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Made Specially\nFor Your Moments',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A little sweetness for every celebration.',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFE9D8D1),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.local_florist_outlined,
            color: Color(0xFFF3C8D1),
            size: 65,
          ),
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
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFFF4DADD), Color(0xFFFFEEE7)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Ikon kue dekoratif di kanan bawah
          const Positioned(
            right: -15,
            bottom: -8,
            child: Icon(
              Icons.cake_rounded,
              size: 180,
              color: Color(0x33C2185B),
            ),
          ),
          // Teks hero
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FRESHLY BAKED  •  MADE WITH LOVE',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        letterSpacing: 1,
                        color: const Color(0xFF8D505C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Life is Better\nwith Cake',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Every sweet moment deserves\na delicious little celebration.',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFF775B54),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPink,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'Explore Our Cakes  →',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── BENEFIT BAR (3 keunggulan) ────────────────────────────────────────────────
class _BenefitBar extends StatelessWidget {
  const _BenefitBar();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _BenefitItem(
            icon: Icons.eco_outlined,
            title: 'Premium\nIngredients',
          ),
        ),
        Expanded(
          child: _BenefitItem(
            icon: Icons.cake_outlined,
            title: 'Freshly Baked\nDaily',
          ),
        ),
        Expanded(
          child: _BenefitItem(
            icon: Icons.favorite_border,
            title: 'Made With\nLove',
          ),
        ),
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
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppTheme.medBrown,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ── SEARCH BAR (hanya tampilan, tap navigasi ke RecipeListScreen) ─────────────
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
          color: const Color(0xFFF9EEF2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppTheme.primaryPink, size: 20),
            const SizedBox(width: 10),
            Text(
              'Search cake recipes...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.medBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
