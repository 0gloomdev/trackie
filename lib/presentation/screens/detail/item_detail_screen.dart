import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../viewer/content_viewer.dart';
import 'package:path_provider/path_provider.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final String itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(learningItemsProvider);
    final item = items.firstWhere(
      (i) => i.id == widget.itemId,
      orElse: () => throw Exception('No encontrado'),
    );
    final typeData = AppConstants.contentTypes.firstWhere(
      (t) => t.id == item.type,
      orElse: () => AppConstants.contentTypes.first,
    );
    final color = Color(typeData.color);
    final categories = ref.watch(categoriesProvider);
    final category = item.categoryId != null
        ? categories.where((c) => c.id == item.categoryId).firstOrNull
        : null;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(item.title, style: const TextStyle(fontSize: 16)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.8),
                      color.withValues(alpha: 0.4),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getIcon(item.type),
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  item.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: item.isFavorite ? Colors.red : null,
                ),
                onPressed: () => ref
                    .read(learningItemsProvider.notifier)
                    .toggleFavorite(item.id),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Editar')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') _deleteItem(context, item.id);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status & Category
                  Wrap(
                    spacing: 8,
                    children: [
                      _StatusChip(status: item.status),
                      if (category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(category.color).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: Color(category.color),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress
                  Text(
                    'Progreso',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: item.progress / 100,
                            minHeight: 12,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 80,
                        child: Slider(
                          value: item.progress.toDouble(),
                          min: 0,
                          max: 100,
                          divisions: 20,
                          label: '${item.progress}%',
                          onChanged: (v) => ref
                              .read(learningItemsProvider.notifier)
                              .updateProgress(item.id, v.round()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      if (item.localPath != null || item.url != null)
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ContentViewerScreen(itemId: item.id),
                              ),
                            ),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Abrir contenido'),
                          ),
                        ),
                      if (item.localPath != null || item.url != null)
                        const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _showAssignCategory(context, item, categories),
                          icon: const Icon(Icons.category),
                          label: const Text('Categoría'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Notas'),
                  Tab(text: 'Info'),
                  Tab(text: 'Actividad'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _NotesTab(itemId: widget.itemId, noteController: _noteController),
            _InfoTab(item: item),
            _ActivityTab(item: item),
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

  void _deleteItem(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar elemento?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(learningItemsProvider.notifier).delete(id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showAssignCategory(
    BuildContext context,
    LearningItem item,
    List<Category> categories,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asignar categoría',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.clear),
              title: const Text('Sin categoría'),
              onTap: () {
                ref
                    .read(learningItemsProvider.notifier)
                    .update(item.copyWith(categoryId: null));
                Navigator.pop(ctx);
              },
            ),
            ...categories.map(
              (c) => ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Color(c.color),
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(c.name),
                trailing: item.categoryId == c.id
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  ref
                      .read(learningItemsProvider.notifier)
                      .update(item.copyWith(categoryId: c.id));
                  Navigator.pop(ctx);
                },
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () => _showCreateCategory(context, ctx),
                icon: const Icon(Icons.add),
                label: const Text('Nueva categoría'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCategory(BuildContext context, BuildContext modalContext) {
    final nameController = TextEditingController();
    int selectedColor = AppConstants.tagColors.first;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva categoría'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.tagColors
                  .map(
                    (c) => GestureDetector(
                      onTap: () => selectedColor = c,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(c),
                          shape: BoxShape.circle,
                          border: selectedColor == c
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                ref
                    .read(categoriesProvider.notifier)
                    .add(
                      Category(
                        name: nameController.text.trim(),
                        color: selectedColor,
                      ),
                    );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: tabBar,
  );
  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final s = AppConstants.statuses.firstWhere(
      (st) => st.id == status,
      orElse: () => AppConstants.statuses.first,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(s.color).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        s.name,
        style: TextStyle(
          color: Color(s.color),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _NotesTab extends ConsumerWidget {
  final String itemId;
  final TextEditingController noteController;

  const _NotesTab({required this.itemId, required this.noteController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(learningItemsProvider);
    final item = items.firstWhere((i) => i.id == itemId);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Escribe una nota...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (noteController.text.trim().isNotEmpty) {
                    final notes = item.notes ?? '';
                    final newNotes = notes.isEmpty
                        ? noteController.text.trim()
                        : '$notes\n\n${noteController.text.trim()}';
                    ref
                        .read(learningItemsProvider.notifier)
                        .update(item.copyWith(notes: newNotes));
                    noteController.clear();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (item.notes != null && item.notes!.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    item.notes!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  'Sin notas aún',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  final LearningItem item;
  const _InfoTab({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoRow(label: 'Tipo', value: item.type.toUpperCase()),
        _InfoRow(label: 'Estado', value: item.status),
        _InfoRow(label: 'Progreso', value: '${item.progress}%'),
        if (item.priority != null)
          _InfoRow(label: 'Prioridad', value: item.priority!),
        if (item.description != null)
          _InfoRow(label: 'Descripción', value: item.description!),
        if (item.localPath != null)
          _InfoRow(
            label: 'Archivo local',
            value: item.localPath!.split('/').last,
          ),
        if (item.url != null) _InfoRow(label: 'URL', value: item.url!),
        _InfoRow(label: 'Creado', value: _formatDate(item.createdAt)),
        _InfoRow(label: 'Actualizado', value: _formatDate(item.updatedAt)),
      ],
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

class _ActivityTab extends StatelessWidget {
  final LearningItem item;
  const _ActivityTab({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ActivityItem(
          icon: Icons.add_circle,
          title: 'Elemento creado',
          time: item.createdAt,
        ),
        _ActivityItem(
          icon: Icons.edit,
          title: 'Última actualización',
          time: item.updatedAt,
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final DateTime time;
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute.toString().padLeft(2, '0')}',
      ),
    );
  }
}
