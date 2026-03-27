import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'data/models/models.dart';
import 'data/repositories/repositories.dart';
import 'domain/providers/providers.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/library/library_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/detail/item_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await Hive.initFlutter();

  final learningRepo = LearningRepository();
  final categoryRepo = CategoryRepository();
  final tagRepo = TagRepository();
  final settingsRepo = SettingsRepository();

  await learningRepo.init();
  await categoryRepo.init();
  await tagRepo.init();
  await settingsRepo.init();

  runApp(
    ProviderScope(
      overrides: [
        learningRepositoryProvider.overrideWithValue(learningRepo),
        categoryRepositoryProvider.overrideWithValue(categoryRepo),
        tagRepositoryProvider.overrideWithValue(tagRepo),
        settingsRepositoryProvider.overrideWithValue(settingsRepo),
      ],
      child: const TrackieApp(),
    ),
  );
}

class TrackieApp extends ConsumerWidget {
  const TrackieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    ThemeMode themeMode;
    switch (settings.theme) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    return MaterialApp(
      title: 'Trackie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: settings.showOnboarding
          ? const OnboardingScreen()
          : const MainScreen(),
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    LibraryTab(),
    StatsTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            height: 70,
            indicatorColor: Theme.of(context).colorScheme.primaryContainer,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.library_books_outlined),
                selectedIcon: Icon(Icons.library_books),
                label: 'Biblioteca',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: 'Stats',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Ajustes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LibraryTab extends ConsumerStatefulWidget {
  const LibraryTab({super.key});

  @override
  ConsumerState<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends ConsumerState<LibraryTab> {
  bool _isSearchExpanded = false;
  bool _isFilterExpanded = false;
  bool _isSelectionMode = false;
  final Set<String> _selectedItems = {};
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(advancedFilteredItemsProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: _isSearchExpanded
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Buscar en biblioteca...',
                      border: InputBorder.none,
                      filled: false,
                    ),
                    onChanged: (v) =>
                        ref.read(searchProvider.notifier).state = v,
                  )
                : Text(
                    _isSelectionMode
                        ? '${_selectedItems.length} seleccionados'
                        : 'Biblioteca',
                  ),
            actions: [
              if (_isSelectionMode) ...[
                IconButton(
                  icon: Icon(
                    _selectedItems.length == items.length
                        ? Icons.deselect
                        : Icons.select_all,
                  ),
                  onPressed: () {
                    if (_selectedItems.length == items.length) {
                      _selectedItems.clear();
                    } else {
                      _selectedItems.addAll(items.map((e) => e.id));
                    }
                    setState(() {});
                  },
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (v) => _handleBulkAction(v),
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'favorite',
                      child: Row(
                        children: [
                          Icon(Icons.favorite_border),
                          SizedBox(width: 8),
                          Text('Agregar a favoritos'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'complete',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle),
                          SizedBox(width: 8),
                          Text('Marcar completados'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'pending',
                      child: Row(
                        children: [
                          Icon(Icons.pending),
                          SizedBox(width: 8),
                          Text('Marcar pendientes'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSelectionMode = false;
                      _selectedItems.clear();
                    });
                  },
                ),
              ] else ...[
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
                  icon: Badge(
                    isLabelVisible:
                        filter.type != null ||
                        filter.status != null ||
                        filter.showFavoritesOnly,
                    child: Icon(
                      _isFilterExpanded
                          ? Icons.filter_list_off
                          : Icons.filter_list,
                    ),
                  ),
                  onPressed: () =>
                      setState(() => _isFilterExpanded = !_isFilterExpanded),
                ),
                IconButton(
                  icon: const Icon(Icons.view_module),
                  onPressed: () => _showSortOptions(context, ref),
                ),
              ],
            ],
          ),
          if (_isFilterExpanded)
            SliverToBoxAdapter(child: _AdvancedFilters(filter: filter)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _FilterChip(
                    label: 'Todos',
                    selected: filter.type == null,
                    onTap: () => ref.read(filterProvider.notifier).state =
                        filter.copyWith(clearType: true),
                  ),
                  const SizedBox(width: 8),
                  ...AppConstants.contentTypes
                      .take(6)
                      .map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _FilterChip(
                            label: t.name,
                            selected: filter.type == t.id,
                            color: Color(t.color),
                            onTap: () =>
                                ref.read(filterProvider.notifier).state = filter
                                    .copyWith(type: t.id),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _StatusChip(
                    label: 'Pendientes',
                    selected: filter.status == 'pending',
                    color: const Color(0xFF9E9E9E),
                    onTap: () => ref.read(filterProvider.notifier).state =
                        filter.status == 'pending'
                        ? filter.copyWith(clearStatus: true)
                        : filter.copyWith(status: 'pending'),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'En progreso',
                    selected: filter.status == 'in_progress',
                    color: const Color(0xFFFF9800),
                    onTap: () => ref.read(filterProvider.notifier).state =
                        filter.status == 'in_progress'
                        ? filter.copyWith(clearStatus: true)
                        : filter.copyWith(status: 'in_progress'),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'Completados',
                    selected: filter.status == 'completed',
                    color: const Color(0xFF4CAF50),
                    onTap: () => ref.read(filterProvider.notifier).state =
                        filter.status == 'completed'
                        ? filter.copyWith(clearStatus: true)
                        : filter.copyWith(status: 'completed'),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'Favoritos',
                    selected: filter.showFavoritesOnly,
                    color: Colors.red,
                    icon: Icons.favorite,
                    onTap: () => ref.read(filterProvider.notifier).state =
                        filter.copyWith(
                          showFavoritesOnly: !filter.showFavoritesOnly,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          items.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.library_books_outlined,
                          size: 80,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay elementos',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Agrega tu primer contenido',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = items[index];
                      final isSelected = _selectedItems.contains(item.id);
                      return _LibraryItemCard(
                        item: item,
                        isSelected: isSelected,
                        isSelectionMode: _isSelectionMode,
                        onTap: () {
                          if (_isSelectionMode) {
                            setState(() {
                              if (isSelected)
                                _selectedItems.remove(item.id);
                              else
                                _selectedItems.add(item.id);
                            });
                          } else {
                            ref
                                .read(learningItemsProvider.notifier)
                                .updateLastAccessed(item.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ItemDetailScreen(itemId: item.id),
                              ),
                            );
                          }
                        },
                        onLongPress: () {
                          if (!_isSelectionMode) {
                            setState(() {
                              _isSelectionMode = true;
                              _selectedItems.add(item.id);
                            });
                          }
                        },
                        onTogglePin: () => ref
                            .read(learningItemsProvider.notifier)
                            .togglePinned(item.id),
                        onToggleFavorite: () => ref
                            .read(learningItemsProvider.notifier)
                            .toggleFavorite(item.id),
                        onDuplicate: () => ref
                            .read(learningItemsProvider.notifier)
                            .duplicateItem(item.id),
                        onDelete: () => ref
                            .read(learningItemsProvider.notifier)
                            .delete(item.id),
                      );
                    }, childCount: items.length),
                  ),
                ),
        ],
      ),
    );
  }

  void _handleBulkAction(String action) {
    final ids = _selectedItems.toList();
    switch (action) {
      case 'favorite':
        ref.read(learningItemsProvider.notifier).bulkToggleFavorite(ids);
        break;
      case 'complete':
        ref
            .read(learningItemsProvider.notifier)
            .bulkUpdateStatus(ids, 'completed');
        break;
      case 'pending':
        ref
            .read(learningItemsProvider.notifier)
            .bulkUpdateStatus(ids, 'pending');
        break;
      case 'delete':
        ref.read(learningItemsProvider.notifier).bulkDelete(ids);
        break;
    }
    setState(() {
      _isSelectionMode = false;
      _selectedItems.clear();
    });
  }

  void _showSortOptions(BuildContext context, WidgetRef ref) {
    final filter = ref.read(filterProvider);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ordenar por', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _SortOption(
              title: 'Fecha de actualización',
              icon: Icons.update,
              isSelected: filter.sortBy == 'updatedAt',
              ascending: filter.sortAscending,
              onTap: () {
                ref.read(filterProvider.notifier).state = filter.copyWith(
                  sortBy: 'updatedAt',
                  sortAscending: false,
                );
                Navigator.pop(ctx);
              },
            ),
            _SortOption(
              title: 'Fecha de creación',
              icon: Icons.calendar_today,
              isSelected: filter.sortBy == 'createdAt',
              ascending: filter.sortAscending,
              onTap: () {
                ref.read(filterProvider.notifier).state = filter.copyWith(
                  sortBy: 'createdAt',
                  sortAscending: false,
                );
                Navigator.pop(ctx);
              },
            ),
            _SortOption(
              title: 'Título',
              icon: Icons.sort_by_alpha,
              isSelected: filter.sortBy == 'title',
              ascending: filter.sortAscending,
              onTap: () {
                ref.read(filterProvider.notifier).state = filter.copyWith(
                  sortBy: 'title',
                  sortAscending: true,
                );
                Navigator.pop(ctx);
              },
            ),
            _SortOption(
              title: 'Progreso',
              icon: Icons.trending_up,
              isSelected: filter.sortBy == 'progress',
              ascending: filter.sortAscending,
              onTap: () {
                ref.read(filterProvider.notifier).state = filter.copyWith(
                  sortBy: 'progress',
                  sortAscending: false,
                );
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AdvancedFilters extends ConsumerWidget {
  final FilterState filter;
  const _AdvancedFilters({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtros avanzados',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PriorityFilterChip(
                label: 'Alta prioridad',
                selected: filter.priority == 'high',
                color: const Color(0xFFF44336),
                onTap: () =>
                    ref.read(filterProvider.notifier).state = filter.copyWith(
                      priority: filter.priority == 'high' ? null : 'high',
                    ),
              ),
              _PriorityFilterChip(
                label: 'Media prioridad',
                selected: filter.priority == 'medium',
                color: const Color(0xFFFF9800),
                onTap: () =>
                    ref.read(filterProvider.notifier).state = filter.copyWith(
                      priority: filter.priority == 'medium' ? null : 'medium',
                    ),
              ),
              _PriorityFilterChip(
                label: 'Baja prioridad',
                selected: filter.priority == 'low',
                color: const Color(0xFF4CAF50),
                onTap: () =>
                    ref.read(filterProvider.notifier).state = filter.copyWith(
                      priority: filter.priority == 'low' ? null : 'low',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: const Text('Limpiar'),
                  onPressed: () => ref.read(filterProvider.notifier).state =
                      const FilterState(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriorityFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _PriorityFilterChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? color : Colors.grey),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? color : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool ascending;
  final VoidCallback onTap;
  const _SortOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.ascending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      trailing: isSelected
          ? Icon(
              ascending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final IconData? icon;
  final VoidCallback onTap;
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.color,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: selected ? Border.all(color: color) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: selected
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? chipColor
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
          ),
        ),
      ),
    );
  }
}

class _LibraryItemCard extends StatelessWidget {
  final LearningItem item;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  const _LibraryItemCard({
    required this.item,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
    required this.onTogglePin,
    required this.onToggleFavorite,
    required this.onDuplicate,
    required this.onDelete,
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
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.5)
              : Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: Row(
          children: [
            if (isSelectionMode)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
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
                      if (item.isPinned)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.push_pin,
                            size: 14,
                            color: Colors.amber,
                          ),
                        ),
                      if (item.isFavorite)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.favorite,
                            size: 14,
                            color: Colors.red,
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
                          color: Color(statusData.color).withValues(alpha: 0.2),
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
            if (!isSelectionMode)
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
                  PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        const Icon(Icons.copy, size: 20),
                        const SizedBox(width: 8),
                        const Text('Duplicar'),
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

class _ItemCard extends StatelessWidget {
  final dynamic item;
  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.play_circle,
              color: Theme.of(context).colorScheme.primary,
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
                  style: const TextStyle(fontWeight: FontWeight.w600),
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
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${item.progress}%',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class StatsTab extends ConsumerWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statisticsProvider);
    final items = ref.watch(learningItemsProvider);
    final byType = stats['byType'] as Map<String, int>;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Estadísticas')),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    _StatCard(
                      title: 'Total',
                      value: '${stats['total']}',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      title: 'Completados',
                      value: '${stats['completed']}',
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatCard(
                      title: 'En progreso',
                      value: '${stats['inProgress']}',
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      title: 'Por hacer',
                      value: '${stats['pending']}',
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Por tipo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  Center(
                    child: Text(
                      'Sin datos aún',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                else
                  ...byType.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(e.key.toUpperCase())),
                          Text(
                            '${e.value}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.analytics, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Ajustes')),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SettingsSection(
                  title: 'Apariencia',
                  children: [
                    _SettingsTile(
                      icon: Icons.palette,
                      title: 'Tema',
                      subtitle: settings.theme == 'system'
                          ? 'Sistema'
                          : settings.theme == 'light'
                          ? 'Claro'
                          : 'Oscuro',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.view_module,
                      title: 'Vista',
                      subtitle: settings.defaultView == 'grid'
                          ? 'Cuadrícula'
                          : 'Lista',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SettingsSection(
                  title: 'Datos',
                  children: [
                    _SettingsTile(
                      icon: Icons.download,
                      title: 'Exportar datos',
                      subtitle: 'Descargar como JSON',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.delete,
                      title: 'Borrar datos',
                      subtitle: 'Eliminar todo',
                      onTap: () {},
                      isDestructive: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SettingsSection(
                  title: 'Acerca de',
                  children: [
                    _SettingsTile(
                      icon: Icons.info,
                      title: 'Versión',
                      subtitle: '1.0.0',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.code,
                      title: 'Código fuente',
                      subtitle: 'GitHub',
                      onTap: () {},
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Colors.red
        : Theme.of(context).colorScheme.primary;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? Colors.red : null),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
