import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// SectionHeading – judul seksi dengan subtitle kecil di atas.
/// Responsive: teks tidak overflow di layar sempit.
class SectionHeading extends StatelessWidget {
  final String subtitle;
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const SectionHeading({
    super.key,
    required this.subtitle,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Judul (pakai Expanded agar tidak overflow ke kanan)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: AppTheme.primaryPink,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Tombol aksi opsional (mis. "See All")
        if (actionLabel != null && onActionTap != null) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionLabel!,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppTheme.primaryPink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
