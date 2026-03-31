import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            const SizedBox(height: 32),
            _StatsGrid(analytics: analytics, profile: profile),
            const SizedBox(height: 24),
            _ChartsRow(analytics: analytics),
            const SizedBox(height: 24),
            _PomodoroStats(analytics: analytics),
            const SizedBox(height: 24),
            _AchievementsSummary(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Metrics',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: Colors.transparent,
            decorationColor: AppColors.shadcnSecondary,
            shadows: [
              Shadow(
                color: AppColors.shadcnSecondary.withAlpha(128),
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
        const SizedBox(height: 8),
        Text(
          'Capture and file habit analytics',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withAlpha(179),
            fontWeight: FontWeight.w500,
          ),
        ).animate(delay: 100.ms).fadeIn(duration: 600.ms),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Analytics analytics;
  final UserProfile profile;

  const _StatsGrid({required this.analytics, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Overview'),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.6,
          children: [
            _StatCard(
              title: 'Total Items',
              value: '${analytics.totalItems}',
              icon: Icons.folder,
              color: AppColors.shadcnPrimary,
              index: 0,
            ),
            _StatCard(
              title: 'Completed',
              value: '${analytics.completedItems}',
              icon: Icons.check_circle,
              color: Colors.green,
              index: 1,
            ),
            _StatCard(
              title: 'In Progress',
              value: '${analytics.inProgressItems}',
              icon: Icons.pending,
              color: Colors.orange,
              index: 2,
            ),
            _StatCard(
              title: 'Pending',
              value: '${analytics.pendingItems}',
              icon: Icons.schedule,
              color: Colors.grey,
              index: 3,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _SectionTitle(title: 'Performance'),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.6,
          children: [
            _StatCard(
              title: 'Completion Rate',
              value: '${(analytics.completionRate * 100).toStringAsFixed(1)}%',
              icon: Icons.trending_up,
              color: AppColors.shadcnSecondary,
              index: 4,
            ),
            _StatCard(
              title: 'Total XP',
              value: '${analytics.totalXp}',
              icon: Icons.star,
              color: Colors.amber,
              index: 5,
            ),
            _StatCard(
              title: 'Level',
              value: '${profile.nivel}',
              icon: Icons.military_tech,
              color: Colors.purple,
              index: 6,
            ),
            _StatCard(
              title: 'Streak',
              value: '${analytics.currentStreak} days',
              icon: Icons.local_fire_department,
              color: Colors.red,
              index: 7,
            ),
          ],
        ),
      ],
    );
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int index;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
          padding: const EdgeInsets.all(16),
          hoverEffect: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                ],
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withAlpha(179),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
        .animate(delay: (50 * index).ms)
        .fadeIn()
        .scale(begin: const Offset(0.95, 0.95));
  }
}

class _ChartsRow extends StatelessWidget {
  final Analytics analytics;

  const _ChartsRow({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _WeeklyChart(analytics: analytics)),
        const SizedBox(width: 16),
        Expanded(child: _CompletionRate(analytics: analytics)),
      ],
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final Analytics analytics;

  const _WeeklyChart({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.shadcnBackground,
                    tooltipBorder: BorderSide(
                      color: Colors.white.withAlpha(51),
                    ),
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} items',
                        TextStyle(
                          color: AppColors.shadcnSecondary,
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
                        final index = value.toInt();
                        if (index >= 0 && index < weekDays.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              weekDays[index],
                              style: TextStyle(
                                color: Colors.white.withAlpha(128),
                                fontSize: 11,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                      reservedSize: 28,
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
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.white.withAlpha(13), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _getBarGroups(),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1);
  }

  double _getMaxY() {
    final weeklyActivity = analytics.weeklyActivity;
    final max = weeklyActivity.isEmpty
        ? 10.0
        : weeklyActivity
              .map((e) => e.itemsCompleted)
              .reduce((a, b) => a > b ? a : b)
              .toDouble();
    return max < 5 ? 5 : max + 2;
  }

  List<BarChartGroupData> _getBarGroups() {
    final weeklyActivity = analytics.weeklyActivity;
    return List.generate(7, (index) {
      final value = index < weeklyActivity.length
          ? weeklyActivity[index].itemsCompleted.toDouble()
          : 0.0;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: AppColors.shadcnSecondary,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }
}

class _CompletionRate extends StatelessWidget {
  final Analytics analytics;

  const _CompletionRate({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final rate = (analytics.completionRate * 100).toInt();

    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Extraction Rate (URL)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 10,
                      color: Colors.white.withAlpha(13),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: 0.94,
                      strokeWidth: 10,
                      color: AppColors.shadcnPrimary,
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: 0.85,
                      strokeWidth: 10,
                      color: AppColors.shadcnSecondary.withAlpha(128),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$rate%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.transparent,
                          shadows: [
                            Shadow(
                              color: AppColors.shadcnPrimary,
                              offset: Offset.zero,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'SUCCESS',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: Colors.white.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Success rate extracting metadata via automatic parsing.',
            style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(179)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn().slideX(begin: 0.1);
  }
}

class _PomodoroStats extends StatelessWidget {
  final Analytics analytics;

  const _PomodoroStats({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Pomodoro Statistics'),
        const SizedBox(height: 16),
        ShadcnCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _PomodoroStatItem(
                      icon: Icons.timer,
                      value: '${analytics.totalPomodoroSessions}',
                      label: 'Sessions',
                      color: Colors.red,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.white.withAlpha(26),
                  ),
                  Expanded(
                    child: _PomodoroStatItem(
                      icon: Icons.access_time,
                      value: '${analytics.todayMinutes}',
                      label: 'Today (min)',
                      color: AppColors.shadcnSecondary,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.white.withAlpha(26),
                  ),
                  Expanded(
                    child: _PomodoroStatItem(
                      icon: Icons.calendar_today,
                      value: '${analytics.weekMinutes}',
                      label: 'This week',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            )
            .animate(delay: 400.ms)
            .fadeIn()
            .scale(begin: const Offset(0.95, 0.95)),
      ],
    );
  }
}

class _PomodoroStatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _PomodoroStatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(128)),
        ),
      ],
    );
  }
}

class _AchievementsSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final achievements = ref.watch(achievementsProvider);
        final unlocked = achievements.where((a) => a.desbloqueado).length;
        final total = achievements.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: 'Unlocked Achievements'),
            const SizedBox(height: 16),
            ShadcnCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(51),
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
                          '$unlocked of $total achievements',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ShadcnProgress(
                          value: total > 0 ? unlocked / total : 0,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate(delay: 500.ms).fadeIn().slideX(begin: 0.05),
          ],
        );
      },
    );
  }
}
