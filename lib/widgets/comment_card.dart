import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/comment.dart';
import '../theme/app_theme.dart';

/// CommentCard – kartu satu komentar.
/// Semua teks dibatasi dengan maxLines+ellipsis agar tidak overflow
/// di layar kecil maupun komentar yang sangat panjang.
class CommentCard extends StatelessWidget {
  final Comment comment;
  final bool isOwner;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

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
              // Avatar bulat dengan inisial
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

              // Nama dan tanggal – pakai Flexible agar tidak overflow
              Flexible(
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _formatDate(comment.createdAt),
                      style: GoogleFonts.poppins(
                        fontSize: 11, color: AppTheme.medBrown,
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol edit & delete – hanya untuk pemilik
              if (isOwner) ...[
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    color: AppTheme.medBrown,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    tooltip: 'Edit comment',
                    onPressed: onEdit,
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    color: Colors.redAccent,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    tooltip: 'Delete comment',
                    onPressed: onDelete,
                  ),
              ],
            ],
          ),

          const SizedBox(height: 10),

          // ── Isi komentar (tidak dibatasi maxLines – boleh panjang) ───
          Text(
            comment.content,
            style: GoogleFonts.poppins(
              fontSize: 13, color: AppTheme.darkBrown, height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec',
    ];
    final m   = months[dt.month - 1];
    final h   = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} $m ${dt.year}  $h:$min';
  }
}
