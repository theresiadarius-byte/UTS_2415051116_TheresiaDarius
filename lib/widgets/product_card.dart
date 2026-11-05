import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String rating;
  final IconData icon;
  final Color color;

  const ProductCard({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1DFDA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 65, color: const Color(0xFFAE6475)),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            category,
            style: const TextStyle(color: Color(0xFFAA8290), fontSize: 9),
          ),
          const SizedBox(height: 3),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF55342F),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  price,
                  style: const TextStyle(
                    color: Color(0xFFC65370),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.star, color: Color(0xFFF1BD56), size: 13),
              Text(rating, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
