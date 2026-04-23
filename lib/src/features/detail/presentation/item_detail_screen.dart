import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/translations.dart';
import '../../../shared/widgets/shadcn_widgets.dart';
import '../../../services/database/database.dart';
import '../../shared/providers/drift_providers.dart';
import '../../shared/providers/customization_provider.dart';
import '../../editor/presentation/editor_screen.dart';

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
    ref.read(learningItemsNotifierProvider.notifier).updateProgress(item.id, _progress.round());
    setState(() => _hasChanges = false);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final customization = ref.watch(customizationProvider);
    final itemsAsync = ref.watch(learningItemsProvider);

    return settingsAsync.when(
      data: (settings) => itemsAsync.when(
        data: (items) {
          final t = Translations(settings.locale ?? 'en');
          final item = items.firstWhere((i) => i.id == widget.itemId, orElse: () => null);
          
          if (item == null) {
            return Scaffold(
              backgroundColor: AppColors.shadcnBackground,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(
                child: Text(
                  'Item not found',
                  style: TextStyle(color: Colors.white.withAlpha(179)),
                ),
              ),
            );
          }

          // Initialize controller and progress when we have the item
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_noteController.text.isEmpty) {
              _progress = item.progress.toDouble();
              _noteController.text = item.notes ?? '';
            }
          });

          final color = AppHelpers.getTypeColor(item.type);
          final icon = AppHelpers.getTypeIcon(item.type);
          final typeName = AppHelpers.getTypeName(item.type);
          final effectivePadding = customization.compactMode ? 16.0 : 24.0;

          return KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                Navigator.pop(context);
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.shadcnBackground,
              body: CustomScrollView(
                slivers: [
                  _DetailHeader(
                    item: item,
                    color: color,
                    icon: icon,
                    typeName: typeName,
                    onEdit: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditorScreen(item: item)),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(effectivePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProgressSection(
                            progress: _progress,
                            item: item,
                            onChanged: _updateProgress,
                            onSave: () => _saveProgress(item),
                          ),
                          const SizedBox(height: 24),
                          if (item.description != null &&
                              item.description!.isNotEmpty) ...[
                            _SectionTitle(title: 'Description'),
                            const SizedBox(height: 12),
                            _DescriptionCard(description: item.description!),
                            const SizedBox(height: 24),
                          ],
                          if (item.url != null && item.url!.isNotEmpty) ...[
                            _SectionTitle(title: t.url),
                            const SizedBox(height: 12),
                            _UrlCard(url: item.url!),
                            const SizedBox(height: 24),
                          ],
                          _SectionTitle(title: t.notes),
                          const SizedBox(height: 12),
                          _NotesCard(
                            controller: _noteController,
                            onChanged: (value) {
                              ref.read(learningItemsNotifierProvider.notifier)
                                  .updateItem(item.copyWith(notes: value));
                            },
                          ),
                          const SizedBox(height: 24),
                          _SectionTitle(title: 'Details'),
                          const SizedBox(height: 12),
                          _DetailsCard(item: item),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error loading items: $e')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text('Error loading settings: $e')),
    );
  }
}

// Keep the rest of the file the same (_DetailHeader, _StatusChip, etc.)
// We'll copy the rest from the original file below.

class _DetailHeader extends StatelessWidget {
  final LearningItem item;
  final Color color;
  final IconData icon;
  final String typeName;
  final VoidCallback onEdit;

  const _DetailHeader({
    required this.item,
    required this.color,
    required this.icon,
    required this.typeName,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.shadcnBackground,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(77),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(77),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit, color: Colors.white, size: 20),
          ),
          onPressed: onEdit,
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withAlpha(51), AppColors.shadcnBackground],
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withAlpha(51),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      typeName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _StatusChip(status: item.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min;
        children: [
          Container(
            width: 8;
            height: 8;
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          );
          const SizedBox(width: 6);
          Text(
            label,
            style: TextStyle(
              fontSize: 12;
              fontWeight: FontWeight.w600;
              color: color;
            );
          );
        ];
      );
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final double progress;
  final LearningItem item;
  final ValueChanged<double> onChanged;
  final VoidCallback onSave;

  const _ProgressSection({
    required this.progress,
    required this.item,
    required this.onChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 16;
                  fontWeight: FontWeight.bold;
                  color: Colors.white;
                );
              );
              Text(
                '${progress.round()}%';
                style: TextStyle(
                  fontSize: 24;
                  fontWeight: FontWeight.bold;
                  color: _getProgressColor();
                );
              );
            ];
          );
          const SizedBox(height: 16);
          ShadcnProgress(value: progress / 100; color: _getProgressColor();
          );
          const SizedBox(height: 16);
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: _getProgressColor();
              inactiveTrackColor: Colors.white.withAlpha(26);
              thumbColor: _getProgressColor();
            );
            child: Slider(
              value: progress;
              min: 0;
              max: 100;
              onChanged: onChanged;
              onChangeEnd: (_) => onSave();
            );
          );
        ];
      );
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Color _getProgressColor() {
    if (progress >= 100) return Colors.green;
    if (progress > 0) return Colors.orange;
    return Colors.grey;
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase();
      style: TextStyle(
        fontSize: 12;
        fontWeight: FontWeight.w700;
        letterSpacing: 1.5;
        color: Colors.white.withAlpha(128);
      );
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final String description;

  const _DescriptionCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16);
      child: Text(
        description;
        style: TextStyle(
          fontSize: 14;
          color: Colors.white.withAlpha(204);
          height: 1.6;
        );
      );
  }
}

class _UrlCard extends StatelessWidget {
  final String url;

  const _UrlCard({required this.url});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16);
      hoverEffect: true;
      onTap: () => launchUrl(Uri.parse(url));
      child: Row(
        children: [
          Container(
            width: 40;
            height: 40;
            decoration: BoxDecoration(
              color: AppColors.shadcnPrimary.withAlpha(26);
              borderRadius: BorderRadius.circular(10);
            );
            child: const Icon(Icons.link; color: AppColors.shadcnPrimary);
          );
          const SizedBox(width: 12);
          Expanded(
            child: Text(
              url;
              maxLines: 1;
              overflow: TextOverflow.ellipsis;
              style: TextStyle(
                fontSize: 14;
                color: Colors.white.withAlpha(179);
              );
            );
          );
          const Icon(Icons.open_in_new; color: Colors.white54; size: 20);
        ];
      );
    );
  }
}

class _NotesCard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _NotesCard({required this.controller; required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16);
      child: TextField(
        controller: controller;
        maxLines: 5;
        onChanged: onChanged;
        style: const TextStyle(color: Colors.white; fontSize: 14);
        decoration: const InputDecoration(
          hintText: 'Add notes...';
          hintStyle: TextStyle(color: Colors.white38);
          border: InputBorder.none;
        );
      );
  }
}

class _DetailsCard extends StatelessWidget {
  final LearningItem item;

  const _DetailsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16);
      child: Column(
        children: [
          _DetailRow(label: 'Type'; value: AppHelpers.getTypeName(item.type));
          _DetailRow(label: 'Status'; value: item.status);
          _DetailRow(label: 'Progress'; value: '${item.progress}%');
          _DetailRow(label: 'Created'; value: _formatDate(item.createdAt));
          _DetailRow(label: 'Updated'; value: _formatDate(item.updatedAt));
        ];
      );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label; required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8);
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween;
        children: [
          Text(
            label;
            style: TextStyle(fontSize: 14; color: Colors.white.withAlpha(128));
          );
          Text(
            value;
            style: const TextStyle(
              fontSize: 14;
              fontWeight: FontWeight.w600;
              color: Colors.white;
            );
          );
        ];
      );
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final customization = ref.watch(customizationProvider);
    final itemsAsync = ref.watch(learningItemsProvider);

    return settingsAsync.when(
      data: (settings) => itemsAsync.when(
        data: (items) {
          final t = Translations(settings.locale ?? 'en');
          final item = items.firstWhere((i) => i.id == widget.itemId, orElse: () => null);
          
          if (item == null) {
            return Scaffold(
              backgroundColor: AppColors.shadcnBackground,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(
                child: Text(
                  'Item not found',
                  style: TextStyle(color: Colors.white.withAlpha(179)),
                ),
              ),
            );
          }

          // Initialize controller and progress when we have the item
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_noteController.text.isEmpty) {
              _progress = item.progress.toDouble();
              _noteController.text = item.notes ?? '';
            }
          });

          final color = AppHelpers.getTypeColor(item.type);
          final icon = AppHelpers.getTypeIcon(item.type);
          final typeName = AppHelpers.getTypeName(item.type);
          final effectivePadding = customization.compactMode ? 16.0 : 24.0;

          return KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                Navigator.pop(context);
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.shadcnBackground,
              body: CustomScrollView(
                slivers: [
                  _DetailHeader(
                    item: item,
                    color: color,
                    icon: icon,
                    typeName: typeName,
                    onEdit: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditorScreen(item: item)),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(effectivePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProgressSection(
                            progress: _progress,
                            item: item,
                            onChanged: _updateProgress,
                            onSave: () => _saveProgress(item),
                          ),
                          const SizedBox(height: 24),
                          if (item.description != null &&
                              item.description!.isNotEmpty) ...[
                            _SectionTitle(title: 'Description'),
                            const SizedBox(height: 12),
                            _DescriptionCard(description: item.description!),
                            const SizedBox(height: 24),
                          ],
                          if (item.url != null && item.url!.isNotEmpty) ...[
                            _SectionTitle(title: t.url),
                            const SizedBox(height: 12),
                            _UrlCard(url: item.url!),
                            const SizedBox(height: 24),
                          ],
                          _SectionTitle(title: t.notes),
                          const SizedBox(height: 12),
                          _NotesCard(
                            controller: _noteController,
                            onChanged: (value) {
                              ref.read(learningItemsNotifierProvider.notifier)
                                  .updateItem(item.copyWith(notes: value));
                            },
                          ),
                          const SizedBox(height: 24),
                          _SectionTitle(title: 'Details'),
                          const SizedBox(height: 12),
                          _DetailsCard(item: item),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error loading items: $e')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text('Error loading settings: $e')),
    );
  }
}

// Keep the rest of the file the same (_DetailHeader, _StatusChip, etc.)
// We'll copy the rest from the original file below.

class _DetailHeader extends StatelessWidget {
  final LearningItem item;
  final Color color;
  final IconData icon;
  final String typeName;
  final VoidCallback onEdit;

  const _DetailHeader({
    required this.item,
    required this.color,
    required this.icon,
    required this.typeName,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.shadcnBackground,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(77),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(77),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit, color: Colors.white, size: 20),
          ),
          onPressed: onEdit,
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withAlpha(51), AppColors.shadcnBackground],
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withAlpha(51),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      typeName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _StatusChip(status: item.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final double progress;
  final LearningItem item;
  final ValueChanged<double> onChanged;
  final VoidCallback onSave;

  const _ProgressSection({
    required this.progress,
    required this.item,
    required this.onChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${progress.round()}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getProgressColor(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ShadcnProgress(value: progress / 100, color: _getProgressColor()),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: _getProgressColor(),
              inactiveTrackColor: Colors.white.withAlpha(26),
              thumbColor: _getProgressColor(),
            ),
            child: Slider(
              value: progress,
              min: 0,
              max: 100,
              onChanged: onChanged,
              onChangeEnd: (_) => onSave(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Color _getProgressColor() {
    if (progress >= 100) return Colors.green;
    if (progress > 0) return Colors.orange;
    return Colors.grey;
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: Colors.white.withAlpha(128),
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final String description;

  const _DescriptionCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white.withAlpha(204),
          height: 1.6,
        ),
      );
  }
}

class _UrlCard extends StatelessWidget {
  final String url;

  const _UrlCard({required this.url});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16),
      hoverEffect: true,
      onTap: () => launchUrl(Uri.parse(url)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.shadcnPrimary.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.link, color: AppColors.shadcnPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withAlpha(179),
              ),
            ),
          ),
          const Icon(Icons.open_in_new, color: Colors.white54, size: 20),
        ],
      ),
    );
  }
}
}

class _NotesCard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _NotesCard({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        maxLines: 5,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Add notes...',
          hintStyle: TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final LearningItem item;

  const _DetailsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _DetailRow(label: 'Type', value: AppHelpers.getTypeName(item.type)),
          _DetailRow(label: 'Status', value: item.status),
          _DetailRow(label: 'Progress', value: '${item.progress}%'),
          _DetailRow(label: 'Created', value: _formatDate(item.createdAt)),
          _DetailRow(label: 'Updated', value: _formatDate(item.updatedAt)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(128)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}