import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_glass.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../detail/item_detail_screen.dart';
import '../editor/editor_screen.dart';

class LibraryTab extends ConsumerWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredItemsProvider);
    final filter = ref.watch(filterProvider);
    final settings = ref.watch(settingsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          _LibraryAppBar(),

          // Filter Pills
          _FilterPills(filter: filter, ref: ref),

          // Items Count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${items.length} elementos',
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        ref.read(settingsProvider.notifier).toggleViewMode(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        settings.defaultView == 'grid'
                            ? Icons.view_list
                            : Icons.grid_view,
                        size: 18,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          items.isEmpty
              ? SliverFillRemaining(child: _EmptyState())
              : settings.defaultView == 'grid'
              ? _buildGridView(items)
              : _buildListView(items),
        ],
      ),
      floatingActionButton: _AddButton(),
    );
  }

  Widget _buildGridView(List<LearningItem> items) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 280,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _GridItemCard(item: items[index]),
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildListView(List<LearningItem> items) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _ListItemCard(item: items[index]),
          childCount: items.length,
        ),
      ),
    );
  }
}

// ==================== APP BAR ====================
class _LibraryAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 120,
      backgroundColor: cs.surface,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [cs.primary, cs.secondary],
          ).createShader(bounds),
          child: const Text(
            'BIBLIOTECA',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cs.primary.withValues(alpha: 0.08),
                cs.secondary.withValues(alpha: 0.03),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Consumer(
            builder: (context, ref, child) => IconButton(
              icon: Icon(Icons.search, color: cs.onSurfaceVariant, size: 20),
              onPressed: () => _showSearch(context, ref),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showSearch(BuildContext context, WidgetRef ref) {
    showSearch(
      context: context,
      delegate: _LibrarySearchDelegate(ref: ref),
    );
  }
}

// ==================== FILTER PILLS ====================
class _FilterPills extends StatelessWidget {
  final FilterState filter;
  final WidgetRef ref;

  const _FilterPills({required this.filter, required this.ref});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            GlassChip(
              label: 'Todos',
              isSelected: filter.type == null && filter.status == null,
              onTap: () => ref.read(filterProvider.notifier).state = filter
                  .copyWith(clearType: true, clearStatus: true),
            ),
            const SizedBox(width: 10),
            GlassChip(
              label: 'Cursos',
              icon: Icons.play_circle_outline,
              isSelected: filter.type == 'course',
              onTap: () => ref.read(filterProvider.notifier).state = filter
                  .copyWith(type: 'course', clearStatus: true),
            ),
            const SizedBox(width: 10),
            GlassChip(
              label: 'Libros',
              icon: Icons.menu_book_outlined,
              isSelected: filter.type == 'book',
              onTap: () => ref.read(filterProvider.notifier).state = filter
                  .copyWith(type: 'book', clearStatus: true),
            ),
            const SizedBox(width: 10),
            GlassChip(
              label: 'PDFs',
              icon: Icons.picture_as_pdf_outlined,
              isSelected: filter.type == 'pdf',
              onTap: () => ref.read(filterProvider.notifier).state = filter
                  .copyWith(type: 'pdf', clearStatus: true),
            ),
            const SizedBox(width: 10),
            GlassChip(
              label: 'Videos',
              icon: Icons.videocam_outlined,
              isSelected: filter.type == 'video',
              onTap: () => ref.read(filterProvider.notifier).state = filter
                  .copyWith(type: 'video', clearStatus: true),
            ),
            const SizedBox(width: 10),
            GlassChip(
              label: 'Audio',
              icon: Icons.headphones_outlined,
              isSelected: filter.type == 'audio',
              onTap: () => ref.read(filterProvider.notifier).state = filter
                  .copyWith(type: 'audio', clearStatus: true),
            ),
            const SizedBox(width: 16),
            Container(
              width: 1,
              height: 28,
              margin: const EdgeInsets.symmetric(vertical: 2),
              color: cs.outlineVariant,
            ),
            const SizedBox(width: 16),
            GlassChip(
              label: 'Urgente',
              leading: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: cs.error,
                  shape: BoxShape.circle,
                ),
              ),
              isSelected: filter.status == 'urgent',
              activeColor: cs.error,
              onTap: () => ref.read(filterProvider.notifier).state = filter
                  .copyWith(status: 'urgent', clearType: true),
            ),
            const SizedBox(width: 10),
            GlassChip(
              label: 'Pendiente',
              leading: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: cs.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              isSelected: filter.status == 'pending',
              activeColor: cs.tertiary,
              onTap: () => ref.read(filterProvider.notifier).state = filter
                  .copyWith(status: 'pending', clearType: true),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

// ==================== GRID ITEM CARD ====================
class _GridItemCard extends StatelessWidget {
  final LearningItem item;
  const _GridItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = AppHelpers.getTypeColor(item.type);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: item.id)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppGlass.radiusLarge),
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.25),
                    color.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppGlass.radiusLarge),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppHelpers.getTypeName(item.type).toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: color,
                      ),
                    ),
                  ),
                  if (item.isFavorite)
                    Icon(Icons.favorite, size: 14, color: cs.error)
                  else
                    Icon(
                      AppHelpers.getTypeIcon(item.type),
                      size: 16,
                      color: color.withValues(alpha: 0.5),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: cs.onSurface,
                        height: 1.3,
                      ),
                    ),
                    if (item.notes != null && item.notes!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.notes!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.status == 'completed'
                                  ? 'COMPLETADO'
                                  : 'PROGRESO',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${item.progress}%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GlassProgressBar(
                          value: item.progress / 100,
                          color: color,
                          height: 5,
                        ),
                      ],
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

// ==================== LIST ITEM CARD ====================
class _ListItemCard extends StatelessWidget {
  final LearningItem item;
  const _ListItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = AppHelpers.getTypeColor(item.type);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: item.id)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppGlass.radiusMedium),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                AppHelpers.getTypeIcon(item.type),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      if (item.isFavorite)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.favorite,
                            size: 16,
                            color: cs.error,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          AppHelpers.getTypeName(item.type),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${item.progress}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            GlassProgressBar(
                              value: item.progress / 100,
                              color: color,
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

// ==================== EMPTY STATE ====================
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_library_outlined,
              size: 48,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Biblioteca vacía',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primer contenido\npara comenzar tu aprendizaje',
            style: TextStyle(
              fontSize: 14,
              color: cs.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ==================== ADD BUTTON ====================
class _AddButton extends StatelessWidget {
  const _AddButton();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppGlass.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        key: const ValueKey('library_fab'),
        heroTag: 'library_fab_hero',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EditorScreen(),
            fullscreenDialog: true,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(Icons.add, color: cs.onPrimary, size: 28),
      ),
    );
  }
}

// ==================== SEARCH DELEGATE ====================
class _LibrarySearchDelegate extends SearchDelegate<LearningItem?> {
  final WidgetRef ref;

  _LibrarySearchDelegate({required this.ref});

  @override
  String get searchFieldLabel => 'Buscar en biblioteca...';

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    final items = ref.watch(learningItemsProvider);
    final cs = Theme.of(context).colorScheme;
    final results = items
        .where((i) => i.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Sin resultados',
              style: TextStyle(fontSize: 16, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        final color = AppHelpers.getTypeColor(item.type);
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              AppHelpers.getTypeIcon(item.type),
              color: color,
              size: 20,
            ),
          ),
          title: Text(item.title),
          subtitle: Text(
            '${item.progress}% - ${AppHelpers.getStatusName(item.status)}',
          ),
          onTap: () => close(context, item),
        );
      },
    );
  }
}
