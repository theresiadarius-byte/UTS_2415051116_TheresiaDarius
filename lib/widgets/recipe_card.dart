// WIDGET: RecipeCard (reusable)
// Kartu resep yang dipakai di HomeScreen, RecipeListScreen, dan FavoriteScreen.
// Menampilkan thumbnail, nama, kategori, dan tombol favorit.
//
// Tahap ini hanya placeholder – implementasi lengkap ada di Tahap 3.

import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String mealId;
  final String mealName;
  final String mealThumb;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.mealId,
    required this.mealName,
    required this.mealThumb,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder – UI lengkap di Tahap 3
    return Card(
      child: ListTile(
        title: Text(mealName),
        subtitle: Text(mealId),
        onTap: onTap,
      ),
    );
  }
}
