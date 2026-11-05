// WIDGET: StateView (reusable)
// Widget serba guna untuk menampilkan 3 kondisi state:
//   - loading  → CircularProgressIndicator
//   - error    → ikon error + pesan + tombol retry
//   - empty    → ikon kosong + pesan
//
// Dipakai di semua screen yang memuat data dari API atau Supabase
// sehingga tampilan konsisten di seluruh aplikasi.
//
// Tahap ini hanya placeholder – implementasi lengkap ada di Tahap 3.

import 'package:flutter/material.dart';

/// Enum status untuk memperjelas kondisi state
enum ViewStatus { loading, error, empty }

class StateView extends StatelessWidget {
  final ViewStatus status;
  final String? message;
  final VoidCallback? onRetry;

  const StateView({
    super.key,
    required this.status,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder – UI lengkap di Tahap 3
    return Center(
      child: switch (status) {
        ViewStatus.loading => const CircularProgressIndicator(),
        ViewStatus.error   => Text('Error: ${message ?? "Unknown error"}'),
        ViewStatus.empty   => Text(message ?? 'No data found'),
      },
    );
  }
}
