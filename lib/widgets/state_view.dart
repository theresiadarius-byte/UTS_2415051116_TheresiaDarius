import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Status tampilan untuk StateView.
enum ViewStatus { loading, error, empty }

/// StateView – widget reusable untuk menampilkan loading, error, atau empty state.
///
/// Dipakai di semua screen: HomeScreen, RecipeListScreen, RecipeDetailScreen,
/// FavoriteScreen, dan seksi komentar di DetailScreen.
///
/// Setiap status tampil berbeda:
///   loading → CircularProgressIndicator bergaya Sweet Bliss
///   error   → ikon merah, pesan error ramah, tombol Retry (opsional)
///   empty   → ikon abu, pesan kosong
class StateView extends StatelessWidget {
  final ViewStatus status;
  final String? message;      // pesan error atau empty (opsional)
  final VoidCallback? onRetry; // tombol retry (hanya di status error)

  const StateView({
    super.key,
    required this.status,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      ViewStatus.loading => _buildLoading(),
      ViewStatus.error   => _buildError(),
      ViewStatus.empty   => _buildEmpty(),
    };
  }

  // ── Loading ───────────────────────────────────────────────────────────────
  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryPink,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          const Text(
            'Memuat...',
            style: TextStyle(
              color: AppTheme.medBrown, fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────
  Widget _buildError() {
    // Bersihkan prefix "Exception: " yang mungkin ikut ke pesan
    final cleanMsg = (message ?? 'Terjadi kesalahan sistem')
        .replaceAll('Exception: ', '')
        .trim();

    // Klasifikasikan jenis error untuk ikon yang tepat
    final isNetwork = cleanMsg.toLowerCase().contains('internet') ||
        cleanMsg.toLowerCase().contains('network') ||
        cleanMsg.toLowerCase().contains('connection') ||
        cleanMsg.toLowerCase().contains('koneksi');

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon error
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNetwork ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
                size: 40,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16),

            // Judul error
            Text(
              isNetwork ? 'Tidak Ada Koneksi' : 'Ups!',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkBrown,
              ),
            ),
            const SizedBox(height: 8),

            // Pesan detail
            Text(
              cleanMsg,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13, color: AppTheme.medBrown, height: 1.5,
              ),
            ),

            // Tombol Retry
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba Lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Empty ─────────────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    final msg = message ?? 'Belum ada data di sini';
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(
                color: AppTheme.palePink, shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cake_outlined,
                size: 40, color: AppTheme.primaryPink,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13, color: AppTheme.medBrown, height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
