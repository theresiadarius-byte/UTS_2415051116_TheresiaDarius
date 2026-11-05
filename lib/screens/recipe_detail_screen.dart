// SCREEN: RecipeDetailScreen
// Menampilkan detail satu resep: gambar, instruksi, bahan, dan komentar.
// Juga berisi tombol tambah/hapus favorit.
//
// Tahap ini hanya placeholder – implementasi lengkap ada di Tahap 3.

import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String mealId;

  const RecipeDetailScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Detail')),
      body: Center(child: Text('Detail for meal: $mealId – coming soon')),
    );
  }
}
