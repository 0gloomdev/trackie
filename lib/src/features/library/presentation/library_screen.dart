import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/shadcn_widgets.dart';
import '../../../shared/widgets/glass_design.dart';
import '../../../services/models/models.dart';
import '../../shared/providers/customization_provider.dart';
import '../../editor/presentation/editor_screen.dart';

class LibraryTab extends ConsumerStatefulWidget {
  const LibraryTab({super.key});

  @override
  ConsumerState<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends ConsumerState<LibraryTab> {
  String _activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(filteredItemsProvider);
    final customization = ref.watch(customizationProvider);
    final courses = items.where((i) => i.type == 'course').toList();
    final books = items.where((i) => i.type == 'book').toList();
    final videos = items.where((i) => i.type == 'video').toList();
    final articles = items.where((i) => i.type == 'article').toList();
    final pdfs = items.where((i) => i.type == 'pdf').toList();

    List<LearningItem> filteredItems;
    switch (_activeFilter) {
      case 'Books':
        filteredItems = books;
        break;
      case 'Videos':
        filteredItems = videos;
        break;
      case 'Articles':
        filteredItems = articles;
        break;
      case 'PDFs':
        filteredItems = pdfs;
        break;
      case 'Courses':
        filteredItems = courses;
        break;
      default:
        filteredItems = items;
    }

    final effectivePadding = customization.compactMode ? 16.0 : 48.0;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(effectivePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Universe Library',
                        style: AppTypography.heroTitle.copyWith(
                          color: AppColors.primary,
                          fontSize: 64,
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        children: [
                          _FilterChip(
                            label: 'All',
                            isActive: _activeFilter == 'All',
                            onTap: () => setState(() => _activeFilter = 'All'),
                          ),
                          _FilterChip(
                            label: 'Books',
                            isActive: _activeFilter == 'Books',
                            onTap: () =>
                                setState(() => _activeFilter = 'Books'),
                          ),
                          _FilterChip(
                            label: 'Videos',
                            isActive: _activeFilter == 'Videos',
                            onTap: () =>
                                setState(() => _activeFilter = 'Videos'),
                          ),
                          _FilterChip(
                            label: 'Articles',
                            isActive: _activeFilter == 'Articles',
                            onTap: () =>
                                setState(() => _activeFilter = 'Articles'),
                          ),
                          _FilterChip(
                            label: 'PDFs',
                            isActive: _activeFilter == 'PDFs',
                            onTap: () => setState(() => _activeFilter = 'PDFs'),
                          ),
                          _FilterChip(
                            label: 'Courses',
                            isActive: _activeFilter == 'Courses',
                            onTap: () =>
                                setState(() => _activeFilter = 'Courses'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 24),
                    ShadcnCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      borderRadius: 16,
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.brandGradient,
                            ),
                            child: const Center(
                              child: Text(
                                'U',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.onSurfaceVariant,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 64),
            // Bento Grid Layout
            if (filteredItems.isNotEmpty) ...[
              SizedBox(
                height: 700,
                child: Row(
                  children: [
                    // Large Hero Card (8 cols)
                    Expanded(
                      flex: 8,
                      child: _HeroCard(item: filteredItems.first),
                    ),
                    const SizedBox(width: 32),
                    // Right Column (4 cols)
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          // Medium Video Card
                          Expanded(
                            child: _VideoCard(
                              item: filteredItems.length > 1
                                  ? filteredItems[1]
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Small Cards Cluster
                          Expanded(
                            child: _SmallCardsGrid(
                              items: filteredItems.length > 2
                                  ? filteredItems.sublist(2)
                                  : [],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              const _EmptyState(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: _Fab(),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.secondaryContainer
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          border: isActive
              ? null
              : Border.all(color: Colors.white.withAlpha(13)),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withAlpha(102),
                    blurRadius: 25,
                    offset: const Offset(0, -5),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive
                ? AppColors.onSecondaryContainer
                : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final LearningItem item;

  const _HeroCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 32,
      padding: const EdgeInsets.all(40),
      glowColor: AppColors.primary,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background decoration
          Positioned(
            top: 32,
            right: 32,
            child: Transform.rotate(
              angle: 0.2,
              child: Icon(
                Icons.auto_stories,
                size: 64,
                color: AppColors.primary.withAlpha(102),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withAlpha(51),
                    AppColors.primary.withAlpha(13),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.primary.withAlpha(51),
                      ),
                    ),
                    child: Text(
                      'Active Journey',
                      style: AppTypography.typeBadge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    item.title,
                    style: AppTypography.pageTitle.copyWith(fontSize: 36),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.description?.isNotEmpty == true
                        ? item.description!
                        : 'Master the principles and advance your knowledge.',
                    style: AppTypography.body.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress: Orbital Insertion',
                        style: AppTypography.typeBadge.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        '${item.progress}%',
                        style: AppTypography.typeBadge.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth * (item.progress / 100),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary.withAlpha(102),
                                  blurRadius: 25,
                                  offset: const Offset(0, -5),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Item details coming soon'),
                              ),
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimaryContainer,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Resume Journey',
                          style: AppTypography.label.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Item details coming soon'),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Review Logbook',
                              style: AppTypography.label.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1);
  }
}

class _VideoCard extends StatelessWidget {
  final LearningItem? item;

  const _VideoCard({this.item});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 32,
      padding: const EdgeInsets.all(32),
      glowColor: AppColors.secondary,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background image area
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.secondary.withAlpha(26),
                    AppColors.surfaceContainer.withAlpha(153),
                  ],
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle,
                  size: 64,
                  color: Colors.white.withAlpha(153),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(26),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.play_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(26),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '24:12',
                      style: AppTypography.typeBadge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.title ?? 'Neural Networks in Zero Gravity',
                    style: AppTypography.cardTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lecture by Dr. Aris Thorne',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1);
  }
}

class _SmallCardsGrid extends StatelessWidget {
  final List<LearningItem> items;

  const _SmallCardsGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _SmallCard(
          icon: Icons.picture_as_pdf,
          iconColor: AppColors.tertiary,
          title: items.isNotEmpty ? items[0].title : 'Deep Learning PDF',
          subtitle: 'Unread',
          showDot: true,
        ),
        _SmallCard(
          icon: Icons.history_edu,
          iconColor: AppColors.secondary,
          title: items.length > 1 ? items[1].title : 'The Martian Logbook',
          subtitle: '88%',
          showProgress: true,
          progress: 0.88,
        ),
        _SmallCard(
          icon: Icons.inventory_2,
          iconColor: AppColors.onSurfaceVariant,
          title: items.length > 2 ? items[2].title : 'Ether Protocols',
          subtitle: 'Archived',
          opacity: 0.6,
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EditorScreen(),
              fullscreenDialog: true,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withAlpha(13),
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle,
                  color: AppColors.onSurfaceVariant.withAlpha(153),
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  'Import Data',
                  style: AppTypography.typeBadge.copyWith(
                    color: AppColors.onSurfaceVariant.withAlpha(153),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool showDot;
  final bool showProgress;
  final double progress;
  final double opacity;

  const _SmallCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.showDot = false,
    this.showProgress = false,
    this.progress = 0,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      hoverEffect: true,
      child: Opacity(
        opacity: opacity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: iconColor, size: 20),
                if (showDot)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withAlpha(102),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                if (showProgress)
                  Text(
                    subtitle,
                    style: AppTypography.typeBadge.copyWith(
                      color: AppColors.secondary,
                      fontSize: 9,
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showProgress) ...[
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(26),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: double.infinity * progress,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ] else
                  Text(
                    subtitle,
                    style: AppTypography.typeBadge.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 9,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
              color: AppColors.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_library,
              size: 40,
              color: AppColors.primary.withAlpha(128),
            ),
          ),
          const SizedBox(height: 24),
          Text('No items found', style: AppTypography.sectionTitle),
          const SizedBox(height: 8),
          Text('Start by adding your first link', style: AppTypography.body),
        ],
      ),
    ).animate().fadeIn();
  }
}

class _Fab extends StatelessWidget {
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
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(51),
              blurRadius: 30,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: AppColors.onPrimaryContainer,
          size: 32,
        ),
      ),
    );
  }
}
