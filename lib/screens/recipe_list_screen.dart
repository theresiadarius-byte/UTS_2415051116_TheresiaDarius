import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

/// RecipeListScreen – menampilkan daftar resep dalam grid.
/// Data dummy sementara; akan diganti data API nyata di Tahap 8.
/// Grid responsif: 2 kolom di layar sempit, 4 kolom di layar lebar (Tahap 4).
class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  // Controller untuk TextField pencarian
  final _searchController = TextEditingController();

  // Query pencarian aktif
  String _query = '';

  // Data dummy resep – akan diganti response API di Tahap 8
  static const _allMeals = <Map<String, String>>[
    {
      'id':    'dummy_1',
      'name':  'Chocolate Gateau',
      'thumb': 'https://www.themealdb.com/images/media/meals/tqrsvv1511555086.jpg',
      'category': 'Dessert',
    },
    {
      'id':    'dummy_2',
      'name':  'Victoria Sponge',
      'thumb': 'https://www.themealdb.com/images/media/meals/wyrqqq1468233628.jpg',
      'category': 'Dessert',
    },
    {
      'id':    'dummy_3',
      'name':  'Carrot Cake',
      'thumb': 'https://www.themealdb.com/images/media/meals/vrspxv1511722107.jpg',
      'category': 'Dessert',
    },
    {
      'id':    'dummy_4',
      'name':  'Bakewell Tart',
      'thumb': 'https://www.themealdb.com/images/media/meals/vqpwrv1511723001.jpg',
      'category': 'Dessert',
    },
    {
      'id':    'dummy_5',
      'name':  'Banana Pancakes',
      'thumb': 'https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg',
      'category': 'Dessert',
    },
    {
      'id':    'dummy_6',
      'name':  'Christmas Pudding',
      'thumb': 'https://www.themealdb.com/images/media/meals/vvusxs1483907034.jpg',
      'category': 'Dessert',
    },
    {
      'id':    'dummy_7',
      'name':  'Treacle Tart',
      'thumb': 'https://www.themealdb.com/images/media/meals/qxuqtt1511724269.jpg',
      'category': 'Dessert',
    },
    {
      'id':    'dummy_8',
      'name':  'Jam Roly-Poly',
      'thumb': 'https://www.themealdb.com/images/media/meals/ysqupp1511796653.jpg',
      'category': 'Dessert',
    },
  ];

  // Filter daftar berdasarkan query pencarian
  List<Map<String, String>> get _filteredMeals {
    if (_query.isEmpty) return _allMeals;
    return _allMeals
        .where((m) =>
            m['name']!.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose(); // bebaskan memori saat widget dibuang
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        title: Text(
          'Cake Recipes',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBrown,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search bar ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search cake recipes...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.primaryPink,
                ),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        color: AppTheme.medBrown,
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // ── Info jumlah hasil ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              '${_filteredMeals.length} recipes found',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppTheme.medBrown,
              ),
            ),
          ),

          // ── Grid resep ────────────────────────────────────────────────
          Expanded(
            child: _filteredMeals.isEmpty
                ? _buildEmptyState()
                : _buildGrid(context),
          ),
        ],
      ),
    );
  }

  // Grid responsif: jumlah kolom berubah sesuai lebar layar
  //   < 600px   → 2 kolom (ponsel)
  //   600–900px → 3 kolom (tablet kecil)
  //   > 900px   → 4 kolom (tablet besar / web)
  Widget _buildGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Hitung jumlah kolom berdasarkan lebar yang tersedia
        final width = constraints.maxWidth;
        final int columns = switch (width) {
          > 900 => 4,
          > 600 => 3,
          _     => 2,
        };

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:   columns, // responsif berdasarkan LayoutBuilder
            crossAxisSpacing: 14,
            mainAxisSpacing:  14,
            childAspectRatio: 0.75,
          ),
          itemCount: _filteredMeals.length,
          itemBuilder: (context, index) {
            final meal = _filteredMeals[index];
            return RecipeCard(
              mealId:    meal['id']!,
              mealName:  meal['name']!,
              mealThumb: meal['thumb']!,
              category:  meal['category'],
              // Navigasi ke detail dengan passing data
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
            );
          },
        );
      },
    );
  }

  // Tampilan saat tidak ada hasil pencarian
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 60,
            color: AppTheme.lightPink,
          ),
          const SizedBox(height: 12),
          Text(
            'No recipes found',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              color: AppTheme.darkBrown,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try a different keyword',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppTheme.medBrown,
            ),
          ),
        ],
      ),
    );
  }
}
