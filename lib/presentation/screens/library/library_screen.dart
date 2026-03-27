import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../viewer/content_viewer.dart';
import '../detail/item_detail_screen.dart';

class LibraryTab extends ConsumerWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredItemsProvider);
    final filter = ref.watch(filterProvider);
    final categories = ref.watch(categoriesProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Biblioteca'),
            actions: [
              IconButton(
                icon: Icon(
                  settings.defaultView == 'grid'
                      ? Icons.view_list
                      : Icons.grid_view,
                ),
                onPressed: () =>
                    ref.read(settingsProvider.notifier).toggleViewMode(),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showSearch(context, ref),
              ),
            ],
          ),

          // Categories filter
          if (categories.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _CategoryChip(
                      label: 'Todos',
                      selected: filter.categoryId == null,
                      color: null,
                      onTap: () => ref.read(filterProvider.notifier).state =
                          filter.copyWith(clearCategoryId: true),
                    ),
                    const SizedBox(width: 8),
                    ...categories.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _CategoryChip(
                          label: c.name,
                          selected: filter.categoryId == c.id,
                          color: Color(c.color),
                          onTap: () => ref.read(filterProvider.notifier).state =
                              filter.copyWith(categoryId: c.id),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Type filters
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                children: [
                  _TypeChip(
                    label: 'Todos',
                    selected: filter.type == null,
                    onTap: () => ref.read(filterProvider.notifier).state =
                        filter.copyWith(clearType: true),
                  ),
                  const SizedBox(width: 8),
                  ...['course', 'book', 'pdf', 'video', 'audio', 'article'].map(
                    (type) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _TypeChip(
                        label: _getTypeLabel(type),
                        selected: filter.type == type,
                        onTap: () => ref.read(filterProvider.notifier).state =
                            filter.copyWith(type: type),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Status filters
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _StatusChip(
                    label: 'Todos',
                    selected: filter.status == null,
                    onTap: () => ref.read(filterProvider.notifier).state =
                        filter.copyWith(clearStatus: true),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'Pendiente',
                    selected: filter.status == 'pending',
                    color: Colors.grey,
                    onTap: () => ref.read(filterProvider.notifier).state =
                        filter.copyWith(status: 'pending'),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'En progreso',
                    selected: filter.status == 'in_progress',
                    color: Colors.orange,
                    onTap: () => ref.read(filterProvider.notifier).state =
                        filter.copyWith(status: 'in_progress'),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'Completado',
                    selected: filter.status == 'completed',
                    color: Colors.green,
                    onTap: () => ref.read(filterProvider.notifier).state =
                        filter.copyWith(status: 'completed'),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Items count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${items.length} elementos',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Items
          items.isEmpty
              ? SliverFillRemaining(child: _EmptyLibrary())
              : settings.defaultView == 'grid'
              ? _buildGridView(items)
              : _buildListView(items),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGridView(List<LearningItem> items) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _GridItem(item: items[index]),
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildListView(List<LearningItem> items) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _ListItem(item: items[index]),
          childCount: items.length,
        ),
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'course':
        return 'Cursos';
      case 'book':
        return 'Libros';
      case 'pdf':
        return 'PDFs';
      case 'video':
        return 'Videos';
      case 'audio':
        return 'Audio';
      case 'article':
        return 'Artículos';
      default:
        return type;
    }
  }

  void _showSearch(BuildContext context, WidgetRef ref) {
    showSearch(
      context: context,
      delegate: _ItemSearch(ref: ref),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    String selectedType = 'course';
    String? selectedPath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: StatefulBuilder(
          builder: (ctx, setState) => Column(
            mainAxisSize: MainAxisSize.min,
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
                    ],
                  );
                  if (result != null && result.files.single.path != null) {
                    setState(() => selectedPath = result.files.single.path!);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.3),
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
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : Theme.of(context).colorScheme.primary,
                          ),
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

              Text('Tipo', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _TypeButton(
                    type: 'course',
                    label: 'Curso',
                    icon: Icons.play_circle,
                    selected: selectedType,
                    onTap: () => setState(() => selectedType = 'course'),
                  ),
                  _TypeButton(
                    type: 'book',
                    label: 'Libro',
                    icon: Icons.menu_book,
                    selected: selectedType,
                    onTap: () => setState(() => selectedType = 'book'),
                  ),
                  _TypeButton(
                    type: 'pdf',
                    label: 'PDF',
                    icon: Icons.picture_as_pdf,
                    selected: selectedType,
                    onTap: () => setState(() => selectedType = 'pdf'),
                  ),
                  _TypeButton(
                    type: 'video',
                    label: 'Video',
                    icon: Icons.video_library,
                    selected: selectedType,
                    onTap: () => setState(() => selectedType = 'video'),
                  ),
                  _TypeButton(
                    type: 'audio',
                    label: 'Audio',
                    icon: Icons.headphones,
                    selected: selectedType,
                    onTap: () => setState(() => selectedType = 'audio'),
                  ),
                  _TypeButton(
                    type: 'article',
                    label: 'Artículo',
                    icon: Icons.article,
                    selected: selectedType,
                    onTap: () => setState(() => selectedType = 'article'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) return;

                    String finalType = selectedType;
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

                    ref
                        .read(learningItemsProvider.notifier)
                        .add(
                          LearningItem(
                            title: titleController.text.trim(),
                            type: finalType,
                            localPath: selectedPath,
                          ),
                        );
                    Navigator.pop(context);
                  },
                  child: const Text('Agregar'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? (color ?? Theme.of(context).colorScheme.primary)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? Colors.white
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
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.selected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? c
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? c
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String type;
  final String label;
  final IconData icon;
  final String selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.type,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = type == selected;
    final typeData = AppConstants.contentTypes.firstWhere(
      (t) => t.id == type,
      orElse: () => AppConstants.contentTypes.first,
    );
    final color = Color(typeData.color);

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
              icon,
              size: 16,
              color: isSelected
                  ? color
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
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
}

class _EmptyLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Biblioteca vacía',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primer contenido',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final LearningItem item;
  const _GridItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final typeData = AppConstants.contentTypes.firstWhere(
      (t) => t.id == item.type,
      orElse: () => AppConstants.contentTypes.first,
    );
    final color = Color(typeData.color);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: item.id)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_getIcon(item.type), color: color),
            ),
            const Spacer(),
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: item.progress / 100,
                minHeight: 4,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.progress}%',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (item.isFavorite)
                  Icon(Icons.favorite, size: 16, color: Colors.red),
              ],
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
      default:
        return Icons.library_books;
    }
  }
}

class _ListItem extends StatelessWidget {
  final LearningItem item;
  const _ListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final typeData = AppConstants.contentTypes.firstWhere(
      (t) => t.id == item.type,
      orElse: () => AppConstants.contentTypes.first,
    );
    final color = Color(typeData.color);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: item.id)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
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
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (item.isFavorite)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.favorite,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${item.progress}%',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
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
      default:
        return Icons.library_books;
    }
  }
}

class _ItemSearch extends SearchDelegate<LearningItem?> {
  final WidgetRef ref;

  _ItemSearch({required this.ref});

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
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    final items = ref.watch(learningItemsProvider);
    final results = items
        .where((i) => i.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(child: Text('No se encontraron resultados'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          child: Text(results[index].type[0].toUpperCase()),
        ),
        title: Text(results[index].title),
        subtitle: Text('${results[index].progress}%'),
        onTap: () => close(context, results[index]),
      ),
    );
  }
}
