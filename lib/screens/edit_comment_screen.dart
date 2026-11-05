// SCREEN: EditCommentScreen
// Form untuk mengedit komentar yang sudah ada.
// Hanya pemilik komentar (user_id sama) yang bisa mengedit.
// Diisi otomatis dengan isi komentar lama.
//
// Tahap ini hanya placeholder – implementasi lengkap ada di Tahap 11.

import 'package:flutter/material.dart';

class EditCommentScreen extends StatelessWidget {
  final String commentId;
  final String initialContent;

  const EditCommentScreen({
    super.key,
    required this.commentId,
    required this.initialContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Comment')),
      body: Center(
        child: Text('Edit comment $commentId – coming soon'),
      ),
    );
  }
}
