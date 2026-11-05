import 'package:flutter/material.dart';

import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import '../widgets/section_heading.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = <Map<String, Object>>[
      {
        'title': 'Birthday Cakes',
        'icon': Icons.cake_outlined,
        'color': Color(0xFFF8DDE2),
      },
      {
        'title': 'Anniversary',
        'icon': Icons.favorite_border,
        'color': Color(0xFFF5E4E5),
      },
      {
        'title': 'Theme Cakes',
        'icon': Icons.celebration_outlined,
        'color': Color(0xFFECE3F5),
      },
      {
        'title': 'Cupcakes',
        'icon': Icons.bakery_dining_outlined,
        'color': Color(0xFFF8EBD9),
      },
    ];

    const products = <Map<String, Object>>[
      {
        'name': 'Chocolate Truffle',
        'category': 'Chocolate Cake',
        'price': 'Rp 120.000',
        'rating': '4.9',
        'icon': Icons.cake,
        'color': Color(0xFFE9D2C2),
      },
      {
        'name': 'Red Velvet Cake',
        'category': 'Classic Cake',
        'price': 'Rp 110.000',
        'rating': '4.8',
        'icon': Icons.cake,
        'color': Color(0xFFF4D9DD),
      },
      {
        'name': 'Strawberry Cake',
        'category': 'Fruit Cake',
        'price': 'Rp 105.000',
        'rating': '4.9',
        'icon': Icons.cake,
        'color': Color(0xFFF5E1E5),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // HEADER
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8E2E6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.cake_outlined,
                    color: Color(0xFFB94E68),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sweet Bliss',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF55342F),
                      ),
                    ),
                    Text(
                      'CAKES • BAKES • HAPPINESS',
                      style: TextStyle(
                        fontSize: 8,
                        letterSpacing: 1.1,
                        color: Color(0xFF95716A),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.search, color: Color(0xFF55342F)),
                const SizedBox(width: 17),
                const Icon(Icons.favorite_border, color: Color(0xFF55342F)),
              ],
            ),

            const SizedBox(height: 24),

            // HERO SECTION
            const _HeroBanner(),

            const SizedBox(height: 25),

            // BAKERY BENEFITS
            const Row(
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
            ),

            const SizedBox(height: 30),

            // CAKE CATEGORIES
            const SectionHeading(
              subtitle: 'OUR SPECIALITY',
              title: 'Explore Our Cakes',
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return CategoryCard(
                    title: category['title'] as String,
                    icon: category['icon'] as IconData,
                    color: category['color'] as Color,
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // BEST SELLERS
            const SectionHeading(
              subtitle: 'MOST LOVED',
              title: 'Our Best Sellers',
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 225,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ProductCard(
                    name: product['name'] as String,
                    category: product['category'] as String,
                    price: product['price'] as String,
                    rating: product['rating'] as String,
                    icon: product['icon'] as IconData,
                    color: product['color'] as Color,
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // CUSTOM CAKE PROMOTION
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF57362F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CUSTOM CAKES',
                          style: TextStyle(
                            color: Color(0xFFF5C6CE),
                            fontSize: 10,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Made Specially\nFor Your Moments',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'A little sweetness for every celebration.',
                          style: TextStyle(
                            color: Color(0xFFE9D8D1),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.local_florist_outlined,
                    color: Color(0xFFF3C8D1),
                    size: 65,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Center(
              child: Text(
                'Sweet Bliss • Baked With Love ♥',
                style: TextStyle(color: Color(0xFF95716A), fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HERO BANNER WIDGET
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFFF4DADD), Color(0xFFFFEEE7)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(
            right: -12,
            bottom: -5,
            child: Icon(
              Icons.cake_rounded,
              size: 175,
              color: Color(0x55B94E68),
            ),
          ),

          // HERO CONTENT
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 235,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FRESHLY BAKED • MADE WITH LOVE',
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 1,
                            color: Color(0xFF8D505C),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Life is Better\nwith Cake',
                          style: TextStyle(
                            fontSize: 29,
                            height: 1.15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF55342F),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Every sweet moment deserves '
                          'a delicious little celebration.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF775B54),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC65370),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text(
                            'Explore Our Cakes  →',
                            style: TextStyle(
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
            ),
          ),
        ],
      ),
    );
  }
}

// BAKERY BENEFIT WIDGET
class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _BenefitItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFB94E68), size: 27),
        const SizedBox(height: 7),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: Color(0xFF674943)),
        ),
      ],
    );
  }
}
