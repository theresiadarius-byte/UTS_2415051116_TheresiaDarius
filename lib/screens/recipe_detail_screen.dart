import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/comment_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/meal_provider.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/comment_card.dart';
import '../widgets/state_view.dart';

/// RecipeDetailScreen – detail lengkap satu resep + komentar + favorit.
///
/// Data awal (mealName, mealThumb) di-pass dari layar sebelumnya.
/// Detail & komentar dimuat dari API/Supabase via Provider di initState.
class RecipeDetailScreen extends StatefulWidget {
  final String mealId;
  final String mealName;
  final String mealThumb;

  const RecipeDetailScreen({
    super.key,
    required this.mealId,
    this.mealName  = '',
    this.mealThumb = '',
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load detail resep dan komentar setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealProvider>().loadMealDetail(widget.mealId);
      context.read<CommentProvider>().loadComments(widget.mealId);
    });
  }

  // ── Toggle favorit via FavoriteProvider ──────────────────────────────────
  void _toggleFavorite(BuildContext context) {
    final meal = context.read<MealProvider>().selectedMeal;
    context.read<FavoriteProvider>().toggleFavorite(
      userId:    SupabaseService.currentUserId,
      mealId:    widget.mealId,
      mealName:  meal?.name  ?? widget.mealName,
      mealThumb: meal?.thumbnail ?? widget.mealThumb,
    );
  }

  // ── Tampilkan form tambah komentar (Tahap 10) ─────────────────────────────
  void _showAddCommentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,  // supaya keyboard tidak menutupi form
      backgroundColor: Colors.transparent,
      builder: (_) => _CommentFormSheet(
        title: 'Add Comment',
        onSubmit: (name, content) async {
          final ok = await context.read<CommentProvider>().addComment(
            authorName: name,
            content:    content,
          );
          if (context.mounted) Navigator.pop(context);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(ok ? 'Comment added!' : 'Failed to add comment'),
                backgroundColor: ok ? AppTheme.primaryPink : Colors.redAccent,
              ),
            );
          }
        },
      ),
    );
  }

  // ── Tampilkan form edit komentar (Tahap 11) ───────────────────────────────
  void _showEditCommentSheet(BuildContext context, String commentId, String current) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommentFormSheet(
        title:          'Edit Comment',
        initialContent: current,   // isi sebelumnya di-prefill
        showNameField:  false,     // nama tidak bisa diubah saat edit
        onSubmit: (_, content) async {
          final ok = await context.read<CommentProvider>().updateComment(
            commentId: commentId,
            content:   content,
          );
          if (context.mounted) Navigator.pop(context);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(ok ? 'Comment updated!' : 'Failed to update'),
                backgroundColor: ok ? AppTheme.primaryPink : Colors.redAccent,
              ),
            );
          }
        },
      ),
    );
  }

  // ── Konfirmasi hapus komentar (Tahap 12) ─────────────────────────────────
  void _confirmDeleteComment(BuildContext context, String commentId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Comment?',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold, color: AppTheme.darkBrown,
          ),
        ),
        content: Text(
          'This action cannot be undone.',
          style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.medBrown),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppTheme.medBrown)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await context.read<CommentProvider>()
                  .deleteComment(commentId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok ? 'Comment deleted' : 'Failed to delete'),
                    backgroundColor: ok ? AppTheme.darkBrown : Colors.redAccent,
                  ),
                );
              }
            },
            child: Text('Delete',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, _) {
        final meal  = mealProvider.selectedMeal;
        final name  = meal?.name      ?? widget.mealName;
        final thumb = meal?.thumbnail ?? widget.mealThumb;

        return Scaffold(
          backgroundColor: AppTheme.warmCream,
          body: CustomScrollView(
            slivers: [
              // ── SliverAppBar dengan gambar hero + tombol favorit ──────
              SliverAppBar(
                expandedHeight: 290,
                pinned: true,
                backgroundColor: AppTheme.darkBrown,
                foregroundColor: Colors.white,
                actions: [
                  // Tombol favorit – bereaksi ke FavoriteProvider
                  Consumer<FavoriteProvider>(
                    builder: (_, favProvider, __) {
                      final isFav = favProvider.isFavorite(widget.mealId);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_outline,
                        ),
                        color: isFav ? Colors.pinkAccent[100] : Colors.white,
                        tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
                        onPressed: () => _toggleFavorite(context),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: thumb,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: AppTheme.palePink,
                          child: const Center(
                            child: CircularProgressIndicator(color: AppTheme.primaryPink),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppTheme.palePink,
                          child: const Center(
                            child: Icon(Icons.cake_outlined, size: 80, color: AppTheme.primaryPink),
                          ),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end:   Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Konten berubah sesuai status loading ─────────────────
              SliverToBoxAdapter(
                child: switch (mealProvider.detailStatus) {
                  ProviderStatus.loading => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: StateView(status: ViewStatus.loading),
                  ),
                  ProviderStatus.error => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: StateView(
                      status: ViewStatus.error,
                      message: mealProvider.detailError,
                      onRetry: () => context
                          .read<MealProvider>()
                          .loadMealDetail(widget.mealId),
                    ),
                  ),
                  ProviderStatus.loaded when meal != null =>
                      _buildDetail(context, meal),
                  _ => const SizedBox(height: 20),
                },
              ),
            ],
          ),

          // ── FAB: Tambah Komentar (Tahap 10) ──────────────────────────
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddCommentSheet(context),
            backgroundColor: AppTheme.primaryPink,
            icon: const Icon(Icons.add_comment_outlined, color: Colors.white),
            label: Text(
              'Add Comment',
              style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Detail konten setelah loaded ──────────────────────────────────────────
  Widget _buildDetail(BuildContext context, Meal meal) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // 100 px untuk FAB
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meal.name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.darkBrown,
            ),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8, runSpacing: 6,
            children: [
              if (meal.category != null) _Chip(label: meal.category!),
              if (meal.area     != null) _Chip(label: '🌍 ${meal.area!}'),
              if (meal.tags     != null && meal.tags!.isNotEmpty)
                ...meal.tags!.split(',').take(3).map((t) => _Chip(label: t.trim())),
            ],
          ),

          const SizedBox(height: 28),

          // ── Bahan ────────────────────────────────────────────────────
          const _SectionTitle(title: 'Ingredients'),
          const SizedBox(height: 12),
          meal.ingredients.isEmpty
              ? _placeholder('No ingredients available')
              : Column(
                  children: meal.ingredients
                      .map((ing) => _IngredientRow(ingredient: ing))
                      .toList(),
                ),

          const SizedBox(height: 28),

          // ── Instruksi ────────────────────────────────────────────────
          const _SectionTitle(title: 'Instructions'),
          const SizedBox(height: 12),
          meal.instructions == null
              ? _placeholder('No instructions available')
              : _buildInstructions(meal.instructions!),

          const SizedBox(height: 28),

          // ── Komentar ─────────────────────────────────────────────────
          const _SectionTitle(title: 'Comments'),
          const SizedBox(height: 12),
          _buildComments(context),
        ],
      ),
    );
  }

  // ── Seksi komentar ────────────────────────────────────────────────────────
  Widget _buildComments(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: StateView(status: ViewStatus.loading),
          );
        }

        if (provider.error != null) {
          return StateView(
            status: ViewStatus.error,
            message: provider.error,
            onRetry: () => provider.loadComments(widget.mealId),
          );
        }

        if (provider.comments.isEmpty) {
          return const StateView(
            status: ViewStatus.empty,
            message: 'No comments yet\nTap + to be the first!',
          );
        }

        return Column(
          children: provider.comments.map((c) {
            final isOwner = c.userId == provider.currentUserId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CommentCard(
                comment: c,
                isOwner: isOwner,
                // onEdit  → Tahap 11
                onEdit: isOwner
                    ? () => _showEditCommentSheet(context, c.id, c.content)
                    : null,
                // onDelete → Tahap 12
                onDelete: isOwner
                    ? () => _confirmDeleteComment(context, c.id)
                    : null,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ── Helper widgets ────────────────────────────────────────────────────────
  Widget _buildInstructions(String raw) {
    final steps = raw
        .split(RegExp(r'\r?\n(\r?\n)+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26, height: 26,
                margin: const EdgeInsets.only(right: 10, top: 2),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryPink, shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${entry.key + 1}',
                  style: GoogleFonts.poppins(
                    color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  entry.value,
                  style: GoogleFonts.poppins(
                    fontSize: 13, color: AppTheme.darkBrown, height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _placeholder(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.palePink.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        msg,
        style: GoogleFonts.poppins(
          fontSize: 13, color: AppTheme.medBrown, fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// COMMENT FORM BOTTOM SHEET (Tahap 10 & 11)
// ═══════════════════════════════════════════════════════════════════════════

/// Bottom sheet form untuk tambah komentar (Tahap 10) dan edit (Tahap 11).
/// [showNameField] = false saat edit (nama tidak bisa diubah).
/// [initialContent] di-prefill saat edit.
class _CommentFormSheet extends StatefulWidget {
  final String title;
  final String? initialContent;
  final bool showNameField;
  final Future<void> Function(String name, String content) onSubmit;

  const _CommentFormSheet({
    required this.title,
    required this.onSubmit,
    this.initialContent,
    this.showNameField = true,
  });

  @override
  State<_CommentFormSheet> createState() => _CommentFormSheetState();
}

class _CommentFormSheetState extends State<_CommentFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _contentCtrl;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl    = TextEditingController();
    _contentCtrl = TextEditingController(text: widget.initialContent ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await widget.onSubmit(_nameCtrl.text.trim(), _contentCtrl.text.trim());
    if (mounted) setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    // Padding bawah mengikuti keyboard
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: AppTheme.warmCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.lightPink,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              widget.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkBrown,
              ),
            ),
            const SizedBox(height: 20),

            // Field Nama (hanya saat tambah)
            if (widget.showNameField) ...[
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  hintText: 'Your name',
                  prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryPink),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Name cannot be empty';
                  return null;
                },
              ),
              const SizedBox(height: 14),
            ],

            // Field Komentar
            TextFormField(
              controller: _contentCtrl,
              decoration: const InputDecoration(
                hintText: 'Write your comment...',
                prefixIcon: Icon(Icons.comment_outlined, color: AppTheme.primaryPink),
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Comment cannot be empty';
                if (v.trim().length < 5) return 'Comment must be at least 5 characters';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Tombol submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white,
                        ),
                      )
                    : Text(widget.title),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── HELPER WIDGETS ─────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkBrown,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.lightPink, borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11, color: AppTheme.primaryPink, fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final dynamic ingredient;
  const _IngredientRow({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: AppTheme.primaryPink),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              ingredient.name as String,
              style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.darkBrown),
            ),
          ),
          Text(
            ingredient.measure as String,
            style: GoogleFonts.poppins(
              fontSize: 12, color: AppTheme.medBrown, fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
