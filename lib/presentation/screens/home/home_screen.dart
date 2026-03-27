import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/url_metadata_service.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../viewer/content_viewer.dart';
import '../detail/item_detail_screen.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  bool _isSearchExpanded = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(statisticsProvider);
    final pinnedItems = ref.watch(pinnedItemsProvider);
    final recentItems = ref.watch(recentItemsProvider);
    final inProgressItems = ref.watch(recentInProgressItemsProvider);
    final searchQuery = ref.watch(searchProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: _isSearchExpanded
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Buscar en todo...',
                      border: InputBorder.none,
                      filled: false,
                    ),
                    onChanged: (v) =>
                        ref.read(searchProvider.notifier).state = v,
                  )
                : const Text('Trackie'),
            actions: [
              IconButton(
                icon: Icon(_isSearchExpanded ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    _isSearchExpanded = !_isSearchExpanded;
                    if (!_isSearchExpanded) {
                      _searchController.clear();
                      ref.read(searchProvider.notifier).state = '';
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _showAddDialog(context, ref),
              ),
            ],
          ),
          if (searchQuery.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SearchResultsSection(query: searchQuery),
                ]),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _GreetingSection(),
                  const SizedBox(height: 24),
                  _StatsSection(stats: stats),
                  const SizedBox(height: 32),

                  if (pinnedItems.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Fijados',
                      icon: Icons.push_pin,
                      actionLabel: 'Ver todos',
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),
                    _PinnedItemsGrid(items: pinnedItems),
                    const SizedBox(height: 24),
                  ],

                  _SectionHeader(
                    title: 'Continuar aprendiendo',
                    icon: Icons.trending_up,
                    actionLabel: inProgressItems.isNotEmpty
                        ? '${inProgressItems.length} activos'
                        : null,
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  if (inProgressItems.isEmpty)
                    _EmptyState(
                      icon: Icons.school_outlined,
                      title: '¡Comienza a aprender!',
                      subtitle: 'Agrega tu primer contenido',
                      actionLabel: 'Agregar',
                      onAction: () => _showAddDialog(context, ref),
                    )
                  else
                    ...inProgressItems
                        .take(5)
                        .map(
                          (item) => _LearningItemCard(
                            item: item,
                            onTap: () => _openDetail(context, item.id),
                            onTogglePin: () => ref
                                .read(learningItemsProvider.notifier)
                                .togglePinned(item.id),
                            onToggleFavorite: () => ref
                                .read(learningItemsProvider.notifier)
                                .toggleFavorite(item.id),
                            onDuplicate: () => ref
                                .read(learningItemsProvider.notifier)
                                .duplicateItem(item.id),
                            onDelete: () =>
                                _confirmDelete(context, ref, item.id),
                          ),
                        ),
                  const SizedBox(height: 24),

                  _SectionHeader(title: 'Recientes', icon: Icons.access_time),
                  const SizedBox(height: 12),
                  if (recentItems.isEmpty)
                    _EmptyState(
                      icon: Icons.library_books_outlined,
                      title: 'Sin actividad reciente',
                      subtitle: 'Tu historial aparecerá aquí',
                    )
                  else
                    ...recentItems
                        .take(5)
                        .map(
                          (item) => _LearningItemCard(
                            item: item,
                            compact: true,
                            onTap: () => _openDetail(context, item.id),
                            onTogglePin: () => ref
                                .read(learningItemsProvider.notifier)
                                .togglePinned(item.id),
                            onToggleFavorite: () => ref
                                .read(learningItemsProvider.notifier)
                                .toggleFavorite(item.id),
                            onDuplicate: () => ref
                                .read(learningItemsProvider.notifier)
                                .duplicateItem(item.id),
                            onDelete: () =>
                                _confirmDelete(context, ref, item.id),
                          ),
                        ),
                ]),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }

  void _openDetail(BuildContext context, String itemId) {
    ref.read(learningItemsProvider.notifier).updateLastAccessed(itemId);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: itemId)),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar'),
        content: const Text('¿Estás seguro de eliminar este elemento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(learningItemsProvider.notifier).delete(id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    final descController = TextEditingController();
    String selectedType = 'course';
    String? selectedPath;
    bool _isLoadingMetadata = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: StatefulBuilder(
          builder: (ctx, setState) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Nuevo elemento',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: urlController,
                        decoration: InputDecoration(
                          labelText: 'URL (opcional)',
                          hintText: 'https://...',
                          prefixIcon: const Icon(Icons.link),
                          suffixIcon: _isLoadingMetadata
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : urlController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.auto_awesome),
                                  tooltip: 'Obtener metadatos',
                                  onPressed: () async {
                                    final url = urlController.text.trim();
                                    if (url.isEmpty || !url.startsWith('http'))
                                      return;
                                    setState(() => _isLoadingMetadata = true);
                                    final metadata =
                                        await UrlMetadataService.fetchMetadata(
                                          url,
                                        );
                                    if (metadata.title != null &&
                                        titleController.text.isEmpty) {
                                      titleController.text = metadata.title!;
                                    }
                                    if (metadata.description != null &&
                                        descController.text.isEmpty) {
                                      descController.text =
                                          metadata.description!;
                                    }
                                    if (metadata.title != null) {
                                      setState(() {});
                                    }
                                    setState(() => _isLoadingMetadata = false);
                                  },
                                )
                              : null,
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      GestureDetector(
                        onTap: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
                              'pdf',
                              'mp4',
                              'mp3',
                              'wav',
                              'epub',
                              'mobi',
                              'avi',
                              'mkv',
                              'm4a',
                            ],
                          );
                          if (result != null &&
                              result.files.single.path != null) {
                            setState(
                              () => selectedPath = result.files.single.path!,
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.folder_open,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  selectedPath ?? 'Seleccionar archivo local',
                                  style: TextStyle(
                                    color: selectedPath == null
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          hintText: 'Nombre del recurso',
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: descController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Descripción (opcional)',
                          hintText: 'Breve descripción...',
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Tipo de contenido',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AppConstants.contentTypes
                            .map(
                              (t) => _TypeChip(
                                type: t,
                                selected: selectedType,
                                onTap: () =>
                                    setState(() => selectedType = t.id),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;

                    String finalType = selectedType;
                    String? urlFavicon;
                    String? urlThumbnail;

                    if (selectedPath != null) {
                      final ext = selectedPath!.split('.').last.toLowerCase();
                      if (ext == 'pdf')
                        finalType = 'pdf';
                      else if (['mp4', 'mov', 'avi', 'mkv'].contains(ext))
                        finalType = 'video';
                      else if (['mp3', 'wav', 'aac', 'm4a'].contains(ext))
                        finalType = 'audio';
                      else if (['epub', 'mobi'].contains(ext))
                        finalType = 'book';
                    }

                    final url = urlController.text.trim();
                    if (url.isNotEmpty && url.startsWith('http')) {
                      final metadata = await UrlMetadataService.fetchMetadata(
                        url,
                      );
                      urlFavicon = metadata.favicon;
                      urlThumbnail = metadata.imageUrl;
                    }

                    ref
                        .read(learningItemsProvider.notifier)
                        .add(
                          LearningItem(
                            title: titleController.text.trim(),
                            type: finalType,
                            description: descController.text.trim().isEmpty
                                ? null
                                : descController.text.trim(),
                            url: url.isEmpty ? null : url,
                            urlFavicon: urlFavicon,
                            urlThumbnail: urlThumbnail,
                            localPath: selectedPath,
                          ),
                        );
                    Navigator.pop(context);
                  },
                  child: const Text('Agregar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResultsSection extends ConsumerWidget {
  final String query;
  const _SearchResultsSection({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(advancedFilteredItemsProvider);

    if (results.isEmpty) {
      return _EmptyState(
        icon: Icons.search_off,
        title: 'Sin resultados',
        subtitle: 'No se encontraron elementos para "$query"',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${results.length} resultados',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...results.map(
          (item) => _LearningItemCard(
            item: item,
            onTap: () {
              ref
                  .read(learningItemsProvider.notifier)
                  .updateLastAccessed(item.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ItemDetailScreen(itemId: item.id),
                ),
              );
            },
            onTogglePin: () =>
                ref.read(learningItemsProvider.notifier).togglePinned(item.id),
            onToggleFavorite: () => ref
                .read(learningItemsProvider.notifier)
                .toggleFavorite(item.id),
            onDuplicate: () =>
                ref.read(learningItemsProvider.notifier).duplicateItem(item.id),
            onDelete: () =>
                ref.read(learningItemsProvider.notifier).delete(item.id),
          ),
        ),
      ],
    );
  }
}

class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12)
      greeting = '¡Buenos días!';
    else if (hour < 18)
      greeting = '¡Buenas tardes!';
    else
      greeting = '¡Buenas noches!';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '¿Qué aprenderás hoy?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  final Map<String, dynamic> stats;
  const _StatsSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    final total = stats['total'] as int;
    final completed = stats['completed'] as int;
    final inProgress = stats['inProgress'] as int;
    final progressPercent = total > 0 ? (completed / total * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progreso general',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$progressPercent%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.emoji_events, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressPercent / 100,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'Total', value: '$total'),
              _StatItem(label: 'Completados', value: '$completed'),
              _StatItem(label: 'En curso', value: '$inProgress'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}

class _PinnedItemsGrid extends StatelessWidget {
  final List<LearningItem> items;
  const _PinnedItemsGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length > 5 ? 5 : items.length,
        itemBuilder: (ctx, i) => _PinnedItemCard(item: items[i]),
      ),
    );
  }
}

class _PinnedItemCard extends StatelessWidget {
  final LearningItem item;
  const _PinnedItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final typeData = AppConstants.contentTypes.firstWhere(
      (t) => t.id == item.type,
      orElse: () => AppConstants.contentTypes.first,
    );

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: item.id)),
      ),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(typeData.color).withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(typeData.color).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIcon(item.type),
                    size: 16,
                    color: Color(typeData.color),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.push_pin,
                  size: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const Spacer(),
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: item.progress / 100,
              minHeight: 4,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              color: Color(typeData.color),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'course':
        return Icons.play_circle;
      case 'book':
        return Icons.menu_book;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'video':
        return Icons.video_library;
      case 'audio':
        return Icons.headphones;
      case 'article':
        return Icons.article;
      case 'link':
        return Icons.link;
      default:
        return Icons.library_books;
    }
  }
}

class _LearningItemCard extends StatelessWidget {
  final LearningItem item;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final bool compact;

  const _LearningItemCard({
    required this.item,
    required this.onTap,
    required this.onTogglePin,
    required this.onToggleFavorite,
    required this.onDuplicate,
    required this.onDelete,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final typeData = AppConstants.contentTypes.firstWhere(
      (t) => t.id == item.type,
      orElse: () => AppConstants.contentTypes.first,
    );
    final color = Color(typeData.color);
    final statusData = AppConstants.statuses.firstWhere(
      (s) => s.id == item.status,
      orElse: () => AppConstants.statuses.first,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_getIcon(item.type), color: color),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (item.isPinned)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.push_pin,
                                size: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Color(
                                statusData.color,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusData.name,
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(statusData.color),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item.progress}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onSelected: (v) {
                    switch (v) {
                      case 'pin':
                        onTogglePin();
                        break;
                      case 'favorite':
                        onToggleFavorite();
                        break;
                      case 'duplicate':
                        onDuplicate();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                      case 'open_url':
                        if (item.url != null) launchUrl(Uri.parse(item.url!));
                        break;
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'pin',
                      child: Row(
                        children: [
                          Icon(
                            item.isPinned
                                ? Icons.push_pin_outlined
                                : Icons.push_pin,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(item.isPinned ? 'Desfijar' : 'Fijar'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'favorite',
                      child: Row(
                        children: [
                          Icon(
                            item.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.isFavorite
                                ? 'Quitar favorito'
                                : 'Agregar a favoritos',
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy, size: 20),
                          SizedBox(width: 8),
                          Text('Duplicar'),
                        ],
                      ),
                    ),
                    if (item.url != null)
                      const PopupMenuItem(
                        value: 'open_url',
                        child: Row(
                          children: [
                            Icon(Icons.open_in_new, size: 20),
                            SizedBox(width: 8),
                            Text('Abrir URL'),
                          ],
                        ),
                      ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (!compact) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: item.progress / 100,
                  minHeight: 6,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  color: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'course':
        return Icons.play_circle;
      case 'book':
        return Icons.menu_book;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'video':
        return Icons.video_library;
      case 'audio':
        return Icons.headphones;
      case 'article':
        return Icons.article;
      case 'link':
        return Icons.link;
      default:
        return Icons.library_books;
    }
  }
}

class _TypeChip extends StatelessWidget {
  final ContentType type;
  final String selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = type.id == selected;
    final color = Color(type.color);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(type.id),
              size: 16,
              color: isSelected
                  ? color
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              type.name,
              style: TextStyle(
                color: isSelected
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'course':
        return Icons.play_circle;
      case 'book':
        return Icons.menu_book;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'video':
        return Icons.video_library;
      case 'audio':
        return Icons.headphones;
      case 'article':
        return Icons.article;
      case 'link':
        return Icons.link;
      case 'podcast':
        return Icons.podcasts;
      case 'note':
        return Icons.note;
      case 'epub':
        return Icons.book;
      default:
        return Icons.library_books;
    }
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 16),
            FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
