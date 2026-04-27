import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/shadcn_widgets.dart';
import '../../../services/models/models.dart';
import '../../shared/providers/drift_providers.dart';
import '../../shared/providers/customization_provider.dart';
import '../../editor/presentation/editor_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _filter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LearningItem> _filterItems(List<LearningItem> items) {
    var filtered = items;

    if (_query.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.title.toLowerCase().contains(_query.toLowerCase()) ||
            (item.description?.toLowerCase().contains(_query.toLowerCase()) ??
                false) ||
            (item.url?.toLowerCase().contains(_query.toLowerCase()) ?? false);
      }).toList();
    }

    switch (_filter) {
      case 'in_progress':
        filtered = filtered.where((i) => i.status == 'in_progress').toList();
        break;
      case 'completed':
        filtered = filtered.where((i) => i.status == 'completed').toList();
        break;
      case 'pending':
        filtered = filtered.where((i) => i.status == 'pending').toList();
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(learningItemsProvider);
    final customization = ref.watch(customizationProvider);
    final List<LearningItem> items = itemsAsync.when(
      data: (data) => data,
      loading: () => <LearningItem>[],
      error: (_, _) => <LearningItem>[],
    );
    final filteredItems = _filterItems(items);

    final effectivePadding = customization.compactMode ? 16.0 : 24.0;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.pop(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: AppColors.shadcnBackground,
          body: Padding(
            padding: EdgeInsets.all(effectivePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(onClose: () => Navigator.pop(context)),
                const SizedBox(height: 24),
                _SearchInput(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  onClear: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                ),
                const SizedBox(height: 16),
                _FilterChips(
                  selectedFilter: _filter,
                  onFilterChanged: (filter) => setState(() => _filter = filter),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: filteredItems.isEmpty
                      ? _EmptyState(hasQuery: _query.isNotEmpty)
                      : _SearchResults(items: filteredItems, query: _query),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onClose;

  const _Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onClose,
        ),
        const SizedBox(width: 8),
        const Text(
          'Search',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ).animate().fadeIn(duration: 400.ms),
      ],
    );
  }
}

class _SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchInput({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnInput(
      controller: controller,
      hintText: 'Search your library...',
      prefixIcon: const Icon(Icons.search, color: Colors.white54),
      suffixIcon: controller.text.isNotEmpty
          ? GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close, color: Colors.white54, size: 20),
            )
          : null,
      onChanged: onChanged,
    ).animate(delay: 100.ms).fadeIn().slideY(begin: -0.1);
  }
}

class _FilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const _FilterChips({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'value': 'all', 'label': 'All'},
      {'value': 'in_progress', 'label': 'In Progress'},
      {'value': 'completed', 'label': 'Completed'},
      {'value': 'pending', 'label': 'Pending'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = selectedFilter == f['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ShadcnChip(
              label: f['label'] as String,
              isActive: isSelected,
              onTap: () => onFilterChanged(f['value'] as String),
            ),
          );
        }).toList(),
      ),
    ).animate(delay: 150.ms).fadeIn();
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasQuery;

  const _EmptyState({required this.hasQuery});

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
              hasQuery ? Icons.search_off : Icons.search,
              size: 40,
              color: AppColors.shadcnPrimary.withAlpha(128),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            hasQuery ? 'No results' : 'Search library',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasQuery ? 'No items found' : 'Type to search',
            style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(128)),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

class _SearchResults extends StatelessWidget {
  final List<LearningItem> items;
  final String query;

  const _SearchResults({required this.items, required this.query});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) =>
          _SearchResultItem(item: items[index], index: index, query: query),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final LearningItem item;
  final int index;
  final String query;

  const _SearchResultItem({
    required this.item,
    required this.index,
    required this.query,
  });

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
                color: _getTypeColor().withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getTypeIcon(), color: _getTypeColor(), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HighlightedText(
                    text: item.title,
                    query: query,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _StatusBadge(status: item.status),
                      const SizedBox(width: 8),
                      Text(
                        item.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withAlpha(102),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withAlpha(77)),
          ],
        ),
      ),
    ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.05);
  }

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
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle style;

  const _HighlightedText({
    required this.text,
    required this.query,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final endIndex = startIndex + query.length;

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(text: text.substring(0, startIndex), style: style),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: style.copyWith(
              backgroundColor: AppColors.shadcnPrimary.withAlpha(77),
            ),
          ),
          TextSpan(text: text.substring(endIndex), style: style),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'completed':
        color = AppColors.success;
        label = 'Completed';
        break;
      case 'in_progress':
        color = AppColors.secondary;
        label = 'In Progress';
        break;
      default:
        color = AppColors.onSurfaceVariant;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
