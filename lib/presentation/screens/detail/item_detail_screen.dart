import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_glass.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../editor/editor_screen.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final String itemId;
  const ItemDetailScreen({super.key, required this.itemId});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  final _noteController = TextEditingController();
  double _progress = 0;
  bool _hasChanges = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _updateProgress(double value) {
    setState(() {
      _progress = value;
      _hasChanges = true;
    });
  }

  void _saveProgress(LearningItem item) {
    if (!_hasChanges) return;
    ref
        .read(learningItemsProvider.notifier)
        .updateProgress(item.id, _progress.round());
    setState(() => _hasChanges = false);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(learningItemsProvider);
    final item = items.where((i) => i.id == widget.itemId).firstOrNull;
    final cs = Theme.of(context).colorScheme;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            'Elemento no encontrado',
            style: TextStyle(color: cs.onSurface),
          ),
        ),
      );
    }

    _progress = item.progress.toDouble();
    _noteController.text = item.notes ?? '';

    final color = AppHelpers.getTypeColor(item.type);
    final icon = AppHelpers.getTypeIcon(item.type);
    final typeName = AppHelpers.getTypeName(item.type);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _DetailHeroHeader(
            item: item,
            color: color,
            icon: icon,
            typeName: typeName,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                      height: 1.2,
                    ),
                  ),
                  if (item.description != null &&
                      item.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      item.description!,
                      style: TextStyle(
                        fontSize: 15,
                        color: cs.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _MetadataSection(item: item, color: color),
                  const SizedBox(height: 24),
                  _ProgressSection(
                    item: item,
                    color: color,
                    progress: _progress,
                    onChanged: _updateProgress,
                    onSave: () => _saveProgress(item),
                    hasChanges: _hasChanges,
                  ),
                  const SizedBox(height: 24),
                  _NotesSection(
                    controller: _noteController,
                    item: item,
                    ref: ref,
                  ),
                  const SizedBox(height: 24),
                  _ActionsSection(item: item, ref: ref),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailHeroHeader extends ConsumerWidget {
  final LearningItem item;
  final Color color;
  final IconData icon;
  final String typeName;

  const _DetailHeroHeader({
    required this.item,
    required this.color,
    required this.icon,
    required this.typeName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: cs.surface,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: item.isPinned ? cs.primary : cs.onSurfaceVariant,
              size: 20,
            ),
            onPressed: () =>
                ref.read(learningItemsProvider.notifier).togglePinned(item.id),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              item.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: item.isFavorite ? cs.error : cs.onSurfaceVariant,
              size: 20,
            ),
            onPressed: () => ref
                .read(learningItemsProvider.notifier)
                .toggleFavorite(item.id),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.edit, color: cs.primary, size: 20),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditorScreen(item: item),
                fullscreenDialog: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.4),
                    color.withValues(alpha: 0.1),
                    cs.surface,
                  ],
                ),
              ),
            ),
            Center(
              child: Icon(icon, size: 120, color: color.withValues(alpha: 0.2)),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      cs.surface.withValues(alpha: 0.9),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppGlass.radiusPill),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      typeName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataSection extends StatelessWidget {
  final LearningItem item;
  final Color color;
  const _MetadataSection({required this.item, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              _MetadataChip(
                icon: Icons.access_time,
                label: 'Estado',
                value: AppHelpers.getStatusName(item.status),
                color: AppHelpers.getStatusColor(item.status),
              ),
              const SizedBox(width: 12),
              _MetadataChip(
                icon: Icons.calendar_today,
                label: 'Creado',
                value:
                    '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
          if (item.url != null && item.url!.isNotEmpty) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final uri = Uri.parse(item.url!);
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: cs.secondary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.link, color: cs.secondary, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.url!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: cs.secondary, fontSize: 13),
                      ),
                    ),
                    Icon(Icons.open_in_new, color: cs.secondary, size: 16),
                  ],
                ),
              ),
            ),
          ],
          if (item.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#$tag',
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _MetadataChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final LearningItem item;
  final Color color;
  final double progress;
  final ValueChanged<double> onChanged;
  final VoidCallback onSave;
  final bool hasChanges;
  const _ProgressSection({
    required this.item,
    required this.color,
    required this.progress,
    required this.onChanged,
    required this.onSave,
    required this.hasChanges,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROGRESO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: cs.onSurfaceVariant,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${progress.round()}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                  if (hasChanges) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onSave,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: cs.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          GlassProgressBar(value: progress / 100, color: color, height: 8),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.2),
              thumbColor: Colors.white,
              overlayColor: color.withValues(alpha: 0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: progress,
              min: 0,
              max: 100,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['0%', '25%', '50%', '75%', '100%']
                .map(
                  (label) => Text(
                    label,
                    style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  final TextEditingController controller;
  final LearningItem item;
  final WidgetRef ref;
  const _NotesSection({
    required this.controller,
    required this.item,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NOTAS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: cs.onSurfaceVariant,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (controller.text != item.notes) {
                    final updated = item.copyWith(notes: controller.text);
                    ref.read(learningItemsProvider.notifier).update(updated);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(AppGlass.snackBar('Notas guardadas'));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Guardar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 5,
            style: TextStyle(color: cs.onSurface),
            decoration: AppGlass.inputDecoration(
              hintText: 'Escribe tus notas aquí...',
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsSection extends StatelessWidget {
  final LearningItem item;
  final WidgetRef ref;
  const _ActionsSection({required this.item, required this.ref});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCIONES',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        _ActionTile(
          icon: Icons.check_circle_outline,
          title: 'Marcar como completado',
          color: cs.secondary,
          onTap: () {
            ref
                .read(learningItemsProvider.notifier)
                .updateStatus(item.id, 'completed');
            Navigator.pop(context);
          },
        ),
        _ActionTile(
          icon: Icons.copy,
          title: 'Duplicar elemento',
          color: cs.primary,
          onTap: () {
            ref.read(learningItemsProvider.notifier).duplicateItem(item.id);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(AppGlass.snackBar('Elemento duplicado'));
          },
        ),
        _ActionTile(
          icon: Icons.archive_outlined,
          title: 'Archivar',
          color: cs.onSurfaceVariant,
          onTap: () {
            ref
                .read(learningItemsProvider.notifier)
                .updateStatus(item.id, 'archived');
            Navigator.pop(context);
          },
        ),
        _ActionTile(
          icon: Icons.delete_outline,
          title: 'Eliminar',
          color: cs.error,
          onTap: () => showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Eliminar'),
              content: Text('¿Eliminar "${item.title}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    ref.read(learningItemsProvider.notifier).delete(item.id);
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(backgroundColor: cs.error),
                  child: const Text('Eliminar'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppGlass.radiusMedium),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: color.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
