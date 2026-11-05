// WIDGET: CommentTile (reusable)
// Menampilkan satu komentar dalam daftar di RecipeDetailScreen.
// Menampilkan nama penulis, isi komentar, tanggal, dan tombol edit/hapus
// (hanya tampil jika komentar milik pengguna sendiri).
//
// Tahap ini hanya placeholder – implementasi lengkap ada di Tahap 3.

import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  final String authorName;
  final String content;
  final DateTime createdAt;
  final bool isOwner;         // true jika komentar milik pengguna ini
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommentTile({
    super.key,
    required this.authorName,
    required this.content,
    required this.createdAt,
    required this.isOwner,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder – UI lengkap di Tahap 3
    return ListTile(
      title: Text(authorName),
      subtitle: Text(content),
      trailing: isOwner
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
                IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
              ],
            )
          : null,
    );
  }
}
