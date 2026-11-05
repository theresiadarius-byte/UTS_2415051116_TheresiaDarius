import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Heading seksi dengan subtitle kecil dan garis aksen pink.
/// Digunakan berulang di HomeScreen untuk memisahkan antar-seksi.
class SectionHeading extends StatelessWidget {
  final String subtitle;  // teks kecil di atas (mis. "OUR SPECIALITY")
  final String title;     // judul besar

  const SectionHeading({
    super.key,
    required this.subtitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label kecil di atas
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: AppTheme.primaryPink,
            fontSize: 10,
            letterSpacing: 2.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        // Judul dalam Playfair Display (serif)
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBrown,
          ),
        ),
        const SizedBox(height: 8),
        // Garis aksen pink
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: AppTheme.primaryPink,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}
