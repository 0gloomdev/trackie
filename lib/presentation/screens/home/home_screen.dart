import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final recentItems = ref.watch(recentInProgressItemsProvider);
    final profile = ref.watch(userProfileProvider);
    final achievements = ref.watch(achievementsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          _HeroSection(
            profile: profile,
            weekItems: analytics.weeklyActivity.fold(
              0,
              (sum, a) => sum + a.itemsCompleted,
            ),
          ),
          const SizedBox(height: 32),

          // Stats Grid
          _StatsGrid(analytics: analytics, profile: profile),
          const SizedBox(height: 32),

          // Chart Section
          _WeeklyChart(weeklyActivity: analytics.weeklyActivity),
          const SizedBox(height: 32),

          // Recent Items
          if (recentItems.isNotEmpty) ...[
            _RecentItemsSection(items: recentItems),
            const SizedBox(height: 32),
          ],

          // Achievements Preview
          _AchievementsPreview(achievements: achievements),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final UserProfile? profile;
  final int weekItems;

  const _HeroSection({this.profile, required this.weekItems});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 18) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting,',
          style: TextStyle(fontSize: 18, color: Colors.white.withAlpha(179)),
        ),
        const SizedBox(height: 4),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.shadcnPrimary, Colors.white],
          ).createShader(bounds),
          child: const Text(
            'Your universe overview.',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.2,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'You saved $weekItems items this week. Keep it up!',
          style: TextStyle(fontSize: 16, color: Colors.white.withAlpha(179)),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1, end: 0);
  }
}

class _StatsGrid extends StatelessWidget {
  final Analytics analytics;
  final UserProfile? profile;

  const _StatsGrid({required this.analytics, this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.download_done,
            iconColor: AppColors.shadcnSecondary,
            value: '${analytics.totalItems}',
            label: 'Total Saved',
            subLabel: 'items',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            icon: Icons.trending_up,
            iconColor: AppColors.shadcnPrimary,
            value:
                '+${analytics.weeklyActivity.fold(0, (sum, a) => sum + a.itemsCompleted)}',
            label: 'This week',
            subLabel: '+12%',
            isPositive: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            icon: Icons.offline_bolt,
            iconColor: AppColors.shadcnSuccess,
            value: '100%',
            label: 'Sync',
            subLabel: 'Offline Active',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String subLabel;
  final bool isPositive;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.subLabel,
    this.isPositive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      hoverEffect: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(51),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: iconColor.withAlpha(77)),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  color: Colors.white,
                ),
              ),
              if (isPositive) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_upward,
                  color: Colors.green.shade400,
                  size: 16,
                ),
                Text(
                  subLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else ...[
                const SizedBox(width: 4),
                Text(
                  subLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withAlpha(128),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withAlpha(179),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).scale(begin: const Offset(0.95, 0.95));
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<DailyActivity> weeklyActivity;

  const _WeeklyChart({required this.weeklyActivity});

  @override
  Widget build(BuildContext context) {
    final data = weeklyActivity.isEmpty
        ? List.generate(7, (i) => 0.0)
        : weeklyActivity.map((a) => a.itemsCompleted.toDouble()).toList();

    final maxVal = data.isEmpty ? 1.0 : data.reduce((a, b) => a > b ? a : b);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return ShadcnCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Collection Growth',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal + 2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.shadcnCard,
                    tooltipBorder: BorderSide(
                      color: Colors.white.withAlpha(51),
                    ),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} items',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[idx],
                              style: TextStyle(
                                color: Colors.white.withAlpha(128),
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withAlpha(26),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (index) {
                  final value = index < data.length ? data[index] : 0.0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        width: 24,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.shadcnPrimary,
                            AppColors.shadcnSecondary.withAlpha(204),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}

class _RecentItemsSection extends StatelessWidget {
  final List<LearningItem> items;

  const _RecentItemsSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.shadcnSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _RecentItemCard(
                item: item,
                index: index,
                totalItems: items.length,
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }
}

class _RecentItemCard extends StatelessWidget {
  final LearningItem item;
  final int index;
  final int totalItems;

  const _RecentItemCard({
    required this.item,
    required this.index,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: index < totalItems - 1 ? 12 : 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.shadcnSecondary.withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.link,
                  color: AppColors.shadcnSecondary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.type.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.shadcnPrimary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            item.url ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(128)),
          ),
        ],
      ),
    ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.1);
  }
}

class _AchievementsPreview extends StatelessWidget {
  final List<Achievement> achievements;

  const _AchievementsPreview({required this.achievements});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievements.where((a) => a.desbloqueado).take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Unlocked Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.shadcnSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ...unlocked.asMap().entries.map((entry) {
              final achievement = entry.value;
              return Expanded(
                child: _AchievementBadge(
                  achievement: achievement,
                  index: entry.key,
                ),
              );
            }),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }
}

class _AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final int index;

  const _AchievementBadge({required this.achievement, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: index < 3 ? 12 : 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.shadcnPrimary.withAlpha(26),
            AppColors.shadcnSecondary.withAlpha(13),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.shadcnPrimary.withAlpha(51)),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
              ),
            ),
            child: Icon(
              Icons.emoji_events,
              color: Colors.white.withAlpha(204),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            achievement.titulo,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
