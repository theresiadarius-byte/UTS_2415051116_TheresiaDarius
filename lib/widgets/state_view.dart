import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Enum untuk memperjelas kondisi state tampilan
enum ViewStatus { loading, error, empty }

/// StateView – widget reusable untuk 3 kondisi state:
///   - loading : tampilkan CircularProgressIndicator
///   - error   : tampilkan ikon error + pesan + tombol retry
///   - empty   : tampilkan ikon kosong + pesan
///
/// Dipakai di semua screen agar tampilannya konsisten.
class StateView extends StatelessWidget {
  final ViewStatus status;
  final String? message;      // pesan error atau kosong
  final VoidCallback? onRetry; // aksi saat tombol "Try Again" ditekan

  const StateView({
    super.key,
    required this.status,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: switch (status) {
          ViewStatus.loading => _buildLoading(),
          ViewStatus.error   => _buildError(),
          ViewStatus.empty   => _buildEmpty(),
        },
      ),
    );
  }

  // ── Loading ────────────────────────────────────────────────────────────────
  Widget _buildLoading() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(
          color: AppTheme.primaryPink,
          strokeWidth: 3,
        ),
        const SizedBox(height: 16),
        Text(
          'Loading...',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppTheme.medBrown,
          ),
        ),
      ],
    );
  }

  // ── Error ──────────────────────────────────────────────────────────────────
  Widget _buildError() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.wifi_off_rounded,
          size: 60,
          color: AppTheme.lightPink,
        ),
        const SizedBox(height: 14),
        Text(
          'Oops, something went wrong',
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkBrown,
          ),
          textAlign: TextAlign.center,
        ),
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppTheme.medBrown,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (onRetry != null) ...[
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Try Again'),
          ),
        ],
      ],
    );
  }

  // ── Empty ──────────────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.cake_outlined,
          size: 60,
          color: AppTheme.lightPink,
        ),
        const SizedBox(height: 14),
        Text(
          message ?? 'No recipes found',
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkBrown,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Try searching for something else',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppTheme.medBrown,
          ),
        ),
      ],
    );
  }
}
