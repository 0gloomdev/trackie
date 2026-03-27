import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/url_metadata_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../detail/item_detail_screen.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  bool _isSearchExpanded = false;
  final _searchController = TextEditingController();
  int _selectedNavIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _Sidebar(
            selectedIndex: _selectedNavIndex,
            onItemSelected: (i) => setState(() => _selectedNavIndex = i),
          ),
          Expanded(
            child: _MainContent(
              searchExpanded: _isSearchExpanded,
              searchController: _searchController,
              onSearchToggle: () =>
                  setState(() => _isSearchExpanded = !_isSearchExpanded),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        backgroundColor: const Color(0xFFB79FFF),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Proyecto'),
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
        decoration: const BoxDecoration(
          color: Color(0xFF0F1930),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Nuevo elemento',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
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
                              : null,
                        ),
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
                            ],
                          );
                          if (result != null &&
                              result.files.single.path != null)
                            setState(
                              () => selectedPath = result.files.single.path!,
                            );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF192540),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(
                                0xFFB79FFF,
                              ).withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.folder_open,
                                color: Color(0xFFB79FFF),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  selectedPath ?? 'Seleccionar archivo',
                                  style: TextStyle(
                                    color: selectedPath == null
                                        ? Colors.white54
                                        : Colors.white,
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
                      TextField(
                        controller: descController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Descripción (opcional)',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tipo',
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
                            url: urlController.text.trim().isEmpty
                                ? null
                                : urlController.text.trim(),
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

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  const _Sidebar({required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1930).withValues(alpha: 0.95),
        border: Border(
          right: BorderSide(
            color: const Color(0xFFB79FFF).withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [Color(0xFFB79FFF), Color(0xFF62FAE3)],
                  ).createShader(b),
                  child: const Text(
                    'Trackie',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'GESTIÓN DE APRENDIZAJE',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    color: Colors.white.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _NavItem(
            icon: Icons.dashboard,
            label: 'Panel',
            isSelected: selectedIndex == 0,
            onTap: () => onItemSelected(0),
          ),
          _NavItem(
            icon: Icons.local_library,
            label: 'Biblioteca',
            isSelected: selectedIndex == 1,
            onTap: () => onItemSelected(1),
          ),
          _NavItem(
            icon: Icons.edit_note,
            label: 'Editor',
            isSelected: selectedIndex == 2,
            onTap: () => onItemSelected(2),
          ),
          _NavItem(
            icon: Icons.settings,
            label: 'Ajustes',
            isSelected: selectedIndex == 3,
            onTap: () => onItemSelected(3),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: _NavItem(
              icon: Icons.help,
              label: 'Ayuda',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFB79FFF).withValues(alpha: 0.1)
              : Colors.transparent,
          border: isSelected
              ? const Border(
                  right: BorderSide(color: Color(0xFFB79FFF), width: 3),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFB79FFF) : Colors.white54,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFB79FFF) : Colors.white54,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainContent extends ConsumerWidget {
  final bool searchExpanded;
  final TextEditingController searchController;
  final VoidCallback onSearchToggle;
  const _MainContent({
    required this.searchExpanded,
    required this.searchController,
    required this.onSearchToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statisticsProvider);
    final pinnedItems = ref.watch(pinnedItemsProvider);
    final recentItems = ref.watch(recentItemsProvider);
    final inProgressItems = ref.watch(recentInProgressItemsProvider);
    final searchQuery = ref.watch(searchProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF060E20), Color(0xFF0A1628)],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: searchExpanded
                ? TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Buscar...',
                      border: InputBorder.none,
                      filled: false,
                    ),
                    onChanged: (v) =>
                        ref.read(searchProvider.notifier).state = v,
                  )
                : Text(
                    'Panel',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
            actions: [
              IconButton(
                icon: Icon(searchExpanded ? Icons.close : Icons.search),
                onPressed: () {
                  onSearchToggle();
                  if (!searchExpanded) searchController.clear();
                  ref.read(searchProvider.notifier).state = '';
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFB79FFF),
                child: Icon(Icons.person, size: 18, color: Colors.black),
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _GreetingCard(),
                const SizedBox(height: 32),
                _StatsBentoGrid(stats: stats),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _PinnedItemsSection(items: pinnedItems)),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _RecentActivitySection(
                        items: recentItems,
                        inProgressCount: inProgressItems.length,
                      ),
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

class _GreetingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? 'Buenos días'
        : hour < 18
        ? 'Buenas tardes'
        : 'Buenas noches';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tu progreso de aprendizaje está fluyendo hoy',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _StatsBentoGrid extends StatelessWidget {
  final Map<String, dynamic> stats;
  const _StatsBentoGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final total = stats['total'] as int;
    final completed = stats['completed'] as int;
    final progressPercent = total > 0 ? (completed / total * 100).round() : 0;

    return SizedBox(
      height: 160,
      child: Row(
        children: [
          Expanded(
            flex: 12,
            child: _StatCard(
              title: 'PROGRESO TOTAL',
              value: '$progressPercent%',
              icon: Icons.trending_up,
              color: const Color(0xFFB79FFF),
              isMain: true,
              progressValue: progressPercent.toDouble(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 8,
            child: _StatCard(
              title: 'CURSOS COMPLETADOS',
              value: '$completed',
              icon: Icons.school,
              color: const Color(0xFF62FAE3),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 8,
            child: _StatCard(
              title: 'EN LECTURA',
              value: '${stats['inProgress']}',
              icon: Icons.menu_book,
              color: const Color(0xFFFF86C3),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 8,
            child: _StatCard(
              title: 'DÍAS SEGUIDOS',
              value: '7',
              icon: Icons.local_fire_department,
              color: Colors.orange,
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
  final IconData icon;
  final Color color;
  final bool isMain;
  final double? progressValue;
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isMain = false,
    this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isMain
            ? color.withValues(alpha: 0.15)
            : const Color(0xFF192540).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMain
              ? color.withValues(alpha: 0.5)
              : color.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1,
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: isMain ? 36 : 28,
                  fontWeight: FontWeight.w900,
                  color: isMain ? color : Colors.white,
                ),
              ),
              if (isMain)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                )
              else
                Icon(icon, color: color, size: 28),
            ],
          ),
          if (isMain && progressValue != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressValue! / 100,
                minHeight: 6,
                backgroundColor: Colors.white24,
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}

class _PinnedItemsSection extends StatelessWidget {
  final List<LearningItem> items;
  const _PinnedItemsSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Items Fijados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              'Ver todos',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFFB79FFF).withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF192540).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Sin items fijados',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          )
        else
          ...items.take(2).map((item) => _PinnedItemCard(item: item)),
      ],
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF192540).withValues(alpha: 0.6),
            const Color(0xFF141F38).withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(typeData.color).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(typeData.color).withValues(alpha: 0.3),
                  Color(typeData.color).withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    _getIcon(item.type),
                    size: 40,
                    color: Color(typeData.color).withValues(alpha: 0.5),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.push_pin,
                      size: 16,
                      color: Color(0xFFB79FFF),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: item.progress / 100,
                          minHeight: 4,
                          backgroundColor: Colors.white12,
                          color: Color(typeData.color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item.progress}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

class _RecentActivitySection extends StatelessWidget {
  final List<LearningItem> items;
  final int inProgressCount;
  const _RecentActivitySection({
    required this.items,
    required this.inProgressCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actividad Reciente',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF192540).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _ActivityItem(
                icon: Icons.check_circle,
                color: const Color(0xFFB79FFF),
                title: 'Completaste un módulo',
                subtitle: 'Hace 2 horas',
                isHighlighted: true,
              ),
              const SizedBox(height: 16),
              _ActivityItem(
                icon: Icons.bookmark,
                color: const Color(0xFF62FAE3),
                title: 'Añadiste nuevo item',
                subtitle: 'Hace 5 horas',
              ),
              const SizedBox(height: 16),
              _ActivityItem(
                icon: Icons.edit_note,
                color: const Color(0xFFFF86C3),
                title: 'Nueva nota creada',
                subtitle: 'Ayer a las 21:30',
              ),
              const SizedBox(height: 16),
              _ActivityItem(
                icon: Icons.schedule,
                color: Colors.white38,
                title: 'Sesión de estudio terminada',
                subtitle: 'Ayer a las 18:15',
                isDimmed: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool isHighlighted;
  final bool isDimmed;
  const _ActivityItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.isHighlighted = false,
    this.isDimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDimmed ? 0.1 : 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isDimmed ? Colors.white24 : color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDimmed ? Colors.white38 : Colors.white,
                  fontSize: 13,
                  fontWeight: isHighlighted
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(type.color).withValues(alpha: 0.2)
              : const Color(0xFF192540),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Color(type.color), width: 2)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(type.id),
              size: 16,
              color: isSelected ? Color(type.color) : Colors.white54,
            ),
            const SizedBox(width: 6),
            Text(
              type.name,
              style: TextStyle(
                color: isSelected ? Color(type.color) : Colors.white54,
                fontSize: 12,
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
      default:
        return Icons.library_books;
    }
  }
}
