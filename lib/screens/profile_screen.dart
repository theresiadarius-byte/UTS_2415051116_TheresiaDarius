import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// ProfileScreen – halaman profil pengembang aplikasi Sweet Bliss.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        title: Text(
          'Profil Pengembang',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBrown,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ── Avatar & Header Info ───────────────────────────────────────
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF4DADD), Color(0xFFFFEEE7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryPink, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryPink.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'TD',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryPink,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryPink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cake_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Theresia Darius',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBrown,
              ),
            ),
            const SizedBox(height: 4),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.palePink,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'NIM: 2415051116  •  Kelas: PTI 5 A',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPink,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── Kartu Informasi Mahasiswa ──────────────────────────────────
            _buildSectionHeader('INFORMASI MAHASISWA'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPink.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: const [
                  _ProfileItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Nama Lengkap',
                    value: 'Theresia Darius',
                  ),
                  _Divider(),
                  _ProfileItem(
                    icon: Icons.badge_outlined,
                    label: 'Nomor Induk Mahasiswa (NIM)',
                    value: '2415051116',
                  ),
                  _Divider(),
                  _ProfileItem(
                    icon: Icons.class_outlined,
                    label: 'Kelas / Program Studi',
                    value: 'PTI 5 A (Pendidikan Teknik Informatika)',
                  ),
                  _Divider(),
                  _ProfileItem(
                    icon: Icons.school_outlined,
                    label: 'Universitas',
                    value: 'Universitas Pendidikan Ganesha',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Kartu Informasi Aplikasi ───────────────────────────────────
            _buildSectionHeader('INFORMASI APLIKASI'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPink.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: const [
                  _ProfileItem(
                    icon: Icons.cake_outlined,
                    label: 'Nama Aplikasi',
                    value: 'Sweet Bliss',
                  ),
                  _Divider(),
                  _ProfileItem(
                    icon: Icons.assignment_outlined,
                    label: 'Keperluan',
                    value: 'UTS Pemrograman Mobile',
                  ),
                  _Divider(),
                  _ProfileItem(
                    icon: Icons.info_outline_rounded,
                    label: 'Versi Aplikasi',
                    value: '1.0.0+1',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── Footer ─────────────────────────────────────────────────────
            Center(
              child: Column(
                children: [
                  Text(
                    'Universitas Pendidikan Ganesha',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.medBrown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© 2026 Sweet Bliss  •  Theresia Darius',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppTheme.medBrown.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryPink,
          ),
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.palePink,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryPink, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppTheme.medBrown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkBrown,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 72,
      endIndent: 16,
      color: AppTheme.warmCream,
    );
  }
}
