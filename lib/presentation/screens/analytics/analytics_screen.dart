import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_glass.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../domain/providers/providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analytics = ref.watch(analyticsProvider);
    final items = ref.watch(learningItemsProvider);
    final profile = ref.watch(userProfileProvider);

    final completedItems = items.where((i) => i.status == 'completed').toList();
    final inProgressItems = items
        .where((i) => i.status == 'in_progress')
        .toList();
    final pendingItems = items.where((i) => i.status == 'pending').toList();

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estadísticas',
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
                    'Tu progreso en números',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _StatCard(
                    title: 'Resumen General',
                    icon: Icons.dashboard,
                    isDark: isDark,
                    children: [
                      _StatRow(
                        label: 'Total de items',
                        value: '${analytics.totalItems}',
                        isDark: isDark,
                      ),
                      _StatRow(
                        label: 'Completados',
                        value: '${analytics.completedItems}',
                        valueColor: Colors.green,
                        isDark: isDark,
                      ),
                      _StatRow(
                        label: 'En progreso',
                        value: '${analytics.inProgressItems}',
                        valueColor: Colors.blue,
                        isDark: isDark,
                      ),
                      _StatRow(
                        label: 'Pendientes',
                        value: '${analytics.pendingItems}',
                        valueColor: Colors.grey,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _StatCard(
                    title: 'Rendimiento',
                    icon: Icons.trending_up,
                    isDark: isDark,
                    children: [
                      _StatRow(
                        label: 'Tasa de completado',
                        value:
                            '${(analytics.completionRate * 100).toStringAsFixed(1)}%',
                        valueColor: AppColors.lightPrimary,
                        isDark: isDark,
                      ),
                      _StatRow(
                        label: 'XP Total',
                        value: '${analytics.totalXp}',
                        valueColor: Colors.amber,
                        isDark: isDark,
                      ),
                      _StatRow(
                        label: 'Nivel actual',
                        value: '${profile.nivel}',
                        valueColor: Colors.purple,
                        isDark: isDark,
                      ),
                      _StatRow(
                        label: 'Racha actual',
                        value: '${analytics.currentStreak} días',
                        valueColor: Colors.orange,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _StatCard(
                    title: 'Actividad de Hoy',
                    icon: Icons.today,
                    isDark: isDark,
                    children: [
                      _StatRow(
                        label: 'Items completados',
                        value: '${analytics.todayCompleted}',
                        isDark: isDark,
                      ),
                      _StatRow(
                        label: 'Minutos estudiados',
                        value: '${analytics.todayMinutes} min',
                        valueColor: AppColors.lightPrimary,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'ACTIVIDAD SEMANAL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: ['L', 'M', 'X', 'J', 'V', 'S', 'D']
                                .asMap()
                                .entries
                                .map((entry) {
                                  final index = entry.key;
                                  final day = entry.value;
                                  final activity =
                                      index < analytics.weeklyActivity.length
                                      ? analytics
                                            .weeklyActivity[index]
                                            .itemsCompleted
                                      : 0;
                                  final maxActivity =
                                      analytics.weeklyActivity.isEmpty
                                      ? 1
                                      : analytics.weeklyActivity
                                            .map((e) => e.itemsCompleted)
                                            .reduce((a, b) => a > b ? a : b);
                                  final height = maxActivity > 0
                                      ? (activity / maxActivity) * 60
                                      : 0.0;

                                  return Column(
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 60,
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: 24,
                                          height: height.clamp(4.0, 60.0),
                                          decoration: BoxDecoration(
                                            color: activity > 0
                                                ? AppColors.lightPrimary
                                                : (isDark
                                                      ? AppColors
                                                            .darkSurfaceContainerHighest
                                                      : AppColors
                                                            .lightSurfaceContainerHighest),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        day,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? AppColors.darkOnSurfaceVariant
                                              : AppColors.lightOnSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  );
                                })
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'DISTRIBUCIÓN POR TIPO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TypeDistributionChart(items: items, isDark: isDark),
                  const SizedBox(height: 24),

                  Text(
                    'LOGROS DESBLOQUEADOS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _AchievementsSummary(isDark: isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDark;
  final List<Widget> children;

  const _StatCard({
    required this.title,
    required this.icon,
    required this.isDark,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.lightPrimary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkOnSurface
                      : AppColors.lightOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isDark;

  const _StatRow({
    required this.label,
    required this.value,
    this.valueColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.lightOnSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color:
                  valueColor ??
                  (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeDistributionChart extends StatelessWidget {
  final List items;
  final bool isDark;

  const _TypeDistributionChart({required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final typeCount = <String, int>{};
    for (final item in items) {
      typeCount[item.type] = (typeCount[item.type] ?? 0) + 1;
    }

    if (typeCount.isEmpty) {
      return GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'No hay datos aún',
              style: TextStyle(
                color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.lightOnSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    final colors = [
      AppColors.lightPrimary,
      AppColors.lightSecondary,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    int colorIndex = 0;

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: typeCount.entries.map((entry) {
            final color = colors[colorIndex % colors.length];
            colorIndex++;
            final percentage = items.isNotEmpty
                ? (entry.value / items.length * 100)
                : 0.0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getTypeName(entry.key),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkOnSurface
                            : AppColors.lightOnSurface,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.value}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.lightOnSurfaceVariant,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getTypeName(String type) {
    switch (type) {
      case 'course':
        return 'Curso';
      case 'book':
        return 'Libro';
      case 'video':
        return 'Video';
      case 'article':
        return 'Artículo';
      case 'podcast':
        return 'Podcast';
      case 'tutorial':
        return 'Tutorial';
      case 'workshop':
        return 'Taller';
      case 'bootcamp':
        return 'Bootcamp';
      case 'certification':
        return 'Certificación';
      default:
        return type;
    }
  }
}

class _AchievementsSummary extends StatelessWidget {
  final bool isDark;

  const _AchievementsSummary({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final achievements = ref.watch(achievementsProvider);
        final unlocked = achievements.where((a) => a.desbloqueado).length;
        final total = achievements.length;

        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$unlocked de $total logros',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isDark
                              ? AppColors.darkOnSurface
                              : AppColors.lightOnSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GlassProgressBar(
                        value: total > 0 ? unlocked / total : 0,
                        color: Colors.amber,
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
