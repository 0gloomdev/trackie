import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../editor/editor_screen.dart';

class LibraryTab extends ConsumerWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredItemsProvider);
    final filter = ref.watch(filterProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      body: Column(
        children: [
          _FilterChips(filter: filter, ref: ref),
          Expanded(
            child: items.isEmpty
                ? _EmptyState()
                : settings.defaultView == 'grid'
                ? _GridView(items: items)
                : _ListView(items: items),
          ),
        ],
      ),
      floatingActionButton: _AddButton(),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final FilterState filter;
  final WidgetRef ref;

  const _FilterChips({required this.filter, required this.ref});

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'label': 'All', 'value': null},
      {'label': 'Courses', 'value': 'course'},
      {'label': 'Books', 'value': 'book'},
      {'label': 'PDFs', 'value': 'pdf'},
      {'label': 'Videos', 'value': 'video'},
      {'label': 'Articles', 'value': 'article'},
    ];

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final f = filters[index];
          final isActive = filter.type == f['value'];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ShadcnChip(
              label: f['label'] as String,
              isActive: isActive,
              onTap: () {
                final value = f['value'];
                ref.read(filterProvider.notifier).state = filter.copyWith(
                  type: value as String?,
                  clearType: value == null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final List<LearningItem> items;

  const _GridView({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _GridItemCard(item: items[index], index: index);
      },
    );
  }
}

class _GridItemCard extends StatelessWidget {
  final LearningItem item;
  final int index;

  const _GridItemCard({required this.item, required this.index});

  Color _getTypeColor() {
    switch (item.type) {
      case 'course':
        return AppColors.shadcnPrimary;
      case 'video':
        return AppColors.shadcnSecondary;
      case 'book':
        return Colors.orange;
      case 'pdf':
        return Colors.red;
      case 'article':
        return Colors.green;
      default:
        return AppColors.shadcnPrimary;
    }
  }

  IconData _getTypeIcon() {
    switch (item.type) {
      case 'course':
        return Icons.play_circle;
      case 'video':
        return Icons.videocam;
      case 'book':
        return Icons.menu_book;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'article':
        return Icons.article;
      default:
        return Icons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor();

    return ShadcnCard(
          padding: EdgeInsets.zero,
          hoverEffect: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EditorScreen(item: item)),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withAlpha(51), color.withAlpha(26)],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          _getTypeIcon(),
                          size: 48,
                          color: color.withAlpha(128),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.shadcnBackground.withAlpha(204),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.status == 'completed'
                                ? '✓'
                                : item.status == 'in_progress'
                                ? '⟳'
                                : '○',
                            style: TextStyle(
                              fontSize: 12,
                              color: item.status == 'completed'
                                  ? Colors.green
                                  : item.status == 'in_progress'
                                  ? Colors.orange
                                  : Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (item.url != null)
                        Expanded(
                          child: Text(
                            item.url!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withAlpha(128),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(delay: (50 * index).ms)
        .fadeIn()
        .scale(begin: const Offset(0.95, 0.95));
  }
}

class _ListView extends StatelessWidget {
  final List<LearningItem> items;

  const _ListView({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, index) =>
          _ListItemCard(item: items[index], index: index),
    );
  }
}

class _ListItemCard extends StatelessWidget {
  final LearningItem item;
  final int index;

  const _ListItemCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ShadcnCard(
        padding: const EdgeInsets.all(16),
        hoverEffect: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditorScreen(item: item)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.shadcnPrimary.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.link,
                color: AppColors.shadcnPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.shadcnSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withAlpha(77)),
          ],
        ),
      ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.05),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.shadcnPrimary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.folder_open,
              size: 40,
              color: AppColors.shadcnPrimary.withAlpha(128),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No se encontraron elementos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza agregando tu primer enlace',
            style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(128)),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const EditorScreen(),
          fullscreenDialog: true,
        ),
      ),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadcnPrimary.withAlpha(128),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
