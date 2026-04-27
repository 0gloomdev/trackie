import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/shadcn_widgets.dart';
import '../../../shared/widgets/glass_design.dart';
import '../../../services/models/models.dart';
import '../../shared/providers/drift_providers.dart';
import '../../shared/providers/customization_provider.dart';
import '../../search/presentation/search_screen.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(learningItemsProvider);
    final customization = ref.watch(customizationProvider);
    final List<LearningItem> allItems = itemsAsync.when(
      data: (data) => data,
      loading: () => <LearningItem>[],
      error: (_, _) => <LearningItem>[],
    );
    final courses = allItems.where((i) => i.type == 'course').toList();
    final inProgress = courses.where((i) => i.status == 'in_progress').toList();
    final completed = courses.where((i) => i.status == 'completed').toList();
    final pending = courses.where((i) => i.status == 'pending').toList();

    final effectivePadding = customization.compactMode
        ? DesignTokens.spaceMd
        : DesignTokens.spaceXxl;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Stack(
        children: [
          // Decorative glow orbs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.primary.withAlpha(38), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withAlpha(26),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.all(effectivePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Learning Path',
                          style: AppTypography.typeBadge.copyWith(
                            color: AppColors.tertiary,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spaceSm),
                        Text(
                              'Courses',
                              style: AppTypography.heroTitle.copyWith(
                                color: AppColors.primary,
                                fontSize: 64,
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: -0.2),
                      ],
                    ),
                    ShadcnCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      borderRadius: 999,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary.withAlpha(128),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${inProgress.length} Active Courses',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                // Stat Cards
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.play_circle,
                        label: 'In Progress',
                        value: '${inProgress.length}',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.verified,
                        label: 'Completed',
                        value: '${completed.length}',
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.schedule,
                        label: 'Pending',
                        value: pending.length.toString().padLeft(2, '0'),
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1),
                const SizedBox(height: 80),
                // Course List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Curriculum',
                      style: AppTypography.sectionTitle.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'View All',
                            style: AppTypography.label.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Course Cards
                ...[
                  ...inProgress,
                  ...completed,
                  ...pending,
                ].asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: _CourseCard(item: entry.value, index: entry.key),
                  ),
                ),
                if (courses.isEmpty) const _EmptyState(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(32),
      borderRadius: 32,
      hoverEffect: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Glow orb
          Positioned(
            top: -16,
            right: -16,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color.withAlpha(38), Colors.transparent],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 16),
              Text(
                label,
                style: AppTypography.body.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTypography.statValue.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 36,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final LearningItem item;
  final int index;

  const _CourseCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final isActive = item.status == 'in_progress';
    final isPaused = item.status == 'pending';

    return ShadcnCard(
      padding: const EdgeInsets.all(32),
      borderRadius: 32,
      hoverEffect: true,
      child: Row(
        children: [
          // Image
          Container(
            width: 192,
            height: 128,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withAlpha(26)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  if (isActive)
                    AppColors.primary.withAlpha(51)
                  else
                    AppColors.surfaceContainerHighest,
                  if (isActive)
                    AppColors.secondary.withAlpha(26)
                  else
                    AppColors.surfaceContainer,
                ],
              ),
              color: isPaused ? AppColors.surfaceContainerHighest : null,
            ),
            child: Center(
              child: Icon(
                Icons.school,
                size: 48,
                color: isActive
                    ? AppColors.primary.withAlpha(128)
                    : AppColors.onSurfaceVariant.withAlpha(128),
              ),
            ),
          ),
          const SizedBox(width: 32),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: AppTypography.cardTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description?.isNotEmpty == true
                                ? item.description!
                                : 'Advanced Learning Module',
                            style: AppTypography.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.secondary.withAlpha(26)
                            : Colors.white.withAlpha(13),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? AppColors.secondary
                                  : AppColors.onSurfaceVariant,
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: AppColors.secondary.withAlpha(
                                          128,
                                        ),
                                        blurRadius: 6,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isActive
                                ? 'Active'
                                : isPaused
                                ? 'Paused'
                                : 'Done',
                            style: AppTypography.typeBadge.copyWith(
                              color: isActive
                                  ? AppColors.secondary
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress bar
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          width: constraints.maxWidth * (item.progress / 100),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.secondary
                                : AppColors.primary.withAlpha(102),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: AppColors.secondary.withAlpha(102),
                                      blurRadius: 15,
                                    ),
                                  ]
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.progress}% Complete',
                      style: AppTypography.typeBadge.copyWith(
                        color: isActive
                            ? AppColors.secondary
                            : AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${item.progress ~/ 5} of 20 Lessons',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          // Button
          ElevatedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Course details coming soon')),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive
                  ? AppColors.primary
                  : Colors.transparent,
              foregroundColor: isActive
                  ? AppColors.onPrimaryContainer
                  : AppColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: isActive
                    ? BorderSide.none
                    : BorderSide(color: AppColors.secondary.withAlpha(77)),
              ),
              elevation: isActive ? 0 : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Resume Learning',
                  style: AppTypography.label.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? AppColors.onPrimaryContainer
                        : AppColors.secondary,
                  ),
                ),
                if (isActive) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.05);
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
              Icons.school,
              size: 40,
              color: AppColors.primary.withAlpha(128),
            ),
          ),
          const SizedBox(height: 24),
          Text('No courses yet', style: AppTypography.sectionTitle),
          const SizedBox(height: DesignTokens.spaceSm),
          Text('Add your first course to begin', style: AppTypography.body),
        ],
      ),
    ).animate().fadeIn();
  }
}
