// SCREEN: AddCommentScreen
// Form untuk menambah komentar baru ke sebuah resep.
// Validasi: nama dan komentar tidak boleh kosong.
// Setelah berhasil, kembali ke RecipeDetailScreen.
//
// Tahap ini hanya placeholder – implementasi lengkap ada di Tahap 10.

import 'package:flutter/material.dart';

class AddCommentScreen extends StatelessWidget {
  final String mealId;

  const AddCommentScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Comment')),
      body: Center(child: Text('Add comment for: $mealId – coming soon')),
    );
  }
}
