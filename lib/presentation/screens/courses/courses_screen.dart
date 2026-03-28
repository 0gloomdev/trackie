import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../domain/providers/providers.dart';
import '../../../data/models/models.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = ref.watch(learningItemsProvider);

    // Filter items to only show courses
    final courses = items.where((i) => i.type == 'course').toList();
    final inProgress = courses.where((i) => i.status == 'in_progress').toList();
    final completed = courses.where((i) => i.status == 'completed').toList();
    final pending = courses.where((i) => i.status == 'pending').toList();

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mis Cursos',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${courses.length} cursos en total',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'En Progreso',
                      value: inProgress.length.toString(),
                      icon: Icons.play_circle,
                      color: isDark
                          ? AppColors.darkSecondary
                          : AppColors.lightSecondary,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Completados',
                      value: completed.length.toString(),
                      icon: Icons.check_circle,
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Pendientes',
                      value: pending.length.toString(),
                      icon: Icons.schedule,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Course List
          if (courses.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 64,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay cursos aún',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkOnSurface
                            : AppColors.lightOnSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Añade tu primer curso desde la biblioteca',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.lightOnSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final course = courses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CourseCard(
                      item: course,
                      isDark: isDark,
                      onTap: () {
                        // Navigate to detail
                      },
                    ),
                  );
                }, childCount: courses.length),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      backgroundColor: color.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.lightOnSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final LearningItem item;
  final bool isDark;
  final VoidCallback onTap;

  const _CourseCard({
    required this.item,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkOnSurface
                            : AppColors.lightOnSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStatusText(item.status),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(item.status, isDark),
                      ),
                    ),
                  ],
                ),
              ),
              if (item.isFavorite)
                Icon(
                  Icons.star,
                  color: isDark
                      ? AppColors.darkSecondary
                      : AppColors.lightSecondary,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 16),
          GlassProgressBar(
            value: item.progress / 100,
            color: _getStatusColor(item.status, isDark),
          ),
          const SizedBox(height: 8),
          Text(
            '${item.progress}% completado',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.lightOnSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Completado';
      case 'in_progress':
        return 'En progreso';
      case 'pending':
        return 'Pendiente';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status, bool isDark) {
    switch (status) {
      case 'completed':
        return isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
      case 'in_progress':
        return isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
      default:
        return isDark
            ? AppColors.darkOnSurfaceVariant
            : AppColors.lightOnSurfaceVariant;
    }
  }
}
