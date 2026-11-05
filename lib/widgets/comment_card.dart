import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/comment.dart';
import '../theme/app_theme.dart';

/// CommentCard – kartu satu komentar.
/// Menampilkan avatar inisial, nama penulis, tanggal, dan isi komentar.
/// Jika [isOwner] true: tombol edit (Tahap 11) dan delete (Tahap 12) tampil.
class CommentCard extends StatelessWidget {
  final Comment comment;
  final bool isOwner;         // true jika komentar milik pengguna ini
  final VoidCallback? onEdit;   // null di Tahap 9–10; diisi di Tahap 11
  final VoidCallback? onDelete; // null di Tahap 9–11; diisi di Tahap 12

  const CommentCard({
    super.key,
    required this.comment,
    required this.isOwner,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPink.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: avatar + nama + tanggal + tombol aksi ─────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar bulat dengan inisial nama
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.lightPink,
                child: Text(
                  comment.authorName.isNotEmpty
                      ? comment.authorName[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.poppins(
                    color: AppTheme.primaryPink,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Nama dan tanggal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppTheme.darkBrown,
                      ),
                    ),
                    Text(
                      _formatDate(comment.createdAt),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppTheme.medBrown,
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol edit & delete – hanya tampil jika pemilik
              if (isOwner) ...[
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    color: AppTheme.medBrown,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Edit',
                    onPressed: onEdit,
                  ),
                if (onDelete != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    color: Colors.redAccent,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Delete',
                    onPressed: onDelete,
                  ),
                ],
              ],
            ],
          ),

          const SizedBox(height: 10),

          // ── Isi komentar ─────────────────────────────────────────────
          Text(
            comment.content,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppTheme.darkBrown,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Format tanggal: "5 Nov 2026 22:00"
  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final m = months[dt.month - 1];
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} $m ${dt.year}  $h:$min';
  }
}
