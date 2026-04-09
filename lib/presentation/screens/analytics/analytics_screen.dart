import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../core/widgets/glass_design.dart';
import '../../../domain/providers/providers.dart';
import '../../../domain/providers/customization_provider.dart';
import '../timer/pomodoro_screen.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final customization = ref.watch(customizationProvider);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;

    final completionRate = (analytics.completionRate * 100).toInt();
    final weekItems = analytics.weeklyActivity.fold(
      0,
      (sum, a) => sum + a.itemsCompleted,
    );
    final inProgress = analytics.totalItems - analytics.completedItems;

    final effectivePadding = customization.compactMode
        ? (isDesktop ? 16.0 : 12.0)
        : (isDesktop ? 32.0 : 16.0);

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(effectivePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _KpisRow(
              completionRate: completionRate,
              weeklyOutput: weekItems,
              inProgress: inProgress,
              totalStudyTime: (analytics.weekMinutes ~/ 60),
            ),
            const SizedBox(height: 32),
            _NebulaOverview(),
            const SizedBox(height: 32),
            _PerformanceGrid(isDesktop: isDesktop),
            const SizedBox(height: 32),
            SizedBox(
              height: 320,
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _WeeklyChart(
                            weeklyActivity: analytics.weeklyActivity,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _CompletionRateChart(
                            completionRate: completionRate,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: _WeeklyChart(
                            weeklyActivity: analytics.weeklyActivity,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: _CompletionRateChart(
                            completionRate: completionRate,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 280,
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _HeatMapSection()),
                        const SizedBox(width: 24),
                        Expanded(flex: 1, child: _PomodoroStats()),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(child: _HeatMapSection()),
                        const SizedBox(height: 24),
                        Expanded(child: _PomodoroStats()),
                      ],
                    ),
            ),
            const SizedBox(height: 32),
            _AdvancedInsights(analytics: analytics),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _KpisRow extends StatelessWidget {
  final int completionRate;
  final int weeklyOutput;
  final int inProgress;
  final int totalStudyTime;

  const _KpisRow({
    required this.completionRate,
    required this.weeklyOutput,
    required this.inProgress,
    required this.totalStudyTime,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _KpiCard(
        title: 'Completion Rate',
        value: '$completionRate%',
        trend: '+2.4%',
        color: AppColors.primary,
        glowColor: AppColors.neonPurple,
      ),
      _KpiCard(
        title: 'Weekly Output',
        value: '$weeklyOutput',
        trend: '+12',
        color: AppColors.secondary,
        glowColor: AppColors.neonCyan,
      ),
      _KpiCard(
        title: 'Items In Progress',
        value: '$inProgress',
        trend: 'Stable',
        color: AppColors.tertiary,
        glowColor: AppColors.neonTertiary,
      ),
      _KpiCard(
        title: 'Total Study Time',
        value: '${totalStudyTime}h',
        trend: 'Focus',
        color: AppColors.onSurface,
        glowColor: Colors.white.withAlpha(51),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 12),
                  Expanded(child: cards[1]),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: cards[2]),
                  const SizedBox(width: 12),
                  Expanded(child: cards[3]),
                ],
              ),
            ],
          );
        }
        return Row(
          children:
              cards.expand((card) => [card, const SizedBox(width: 16)]).toList()
                ..removeLast(),
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final Color color;
  final Color glowColor;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.color,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(24),
      glowColor: glowColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -16,
            right: -16,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    glowColor.withAlpha(51),
                    glowColor.withAlpha(13),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTypography.typeBadge.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: AppTypography.statValue.copyWith(color: color),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      trend,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}

class _NebulaOverview extends StatelessWidget {
  const _NebulaOverview();

  @override
  Widget build(BuildContext context) {
    final metrics = [
      {
        'icon': Icons.bolt,
        'label': 'Velocity',
        'value': '8.4',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.my_location,
        'label': 'Accuracy',
        'value': '92%',
        'color': AppColors.secondary,
      },
      {
        'icon': Icons.timer,
        'label': 'Focus Gap',
        'value': '12m',
        'color': AppColors.tertiary,
      },
      {
        'icon': Icons.psychology,
        'label': 'Recall',
        'value': '76%',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.rocket_launch,
        'label': 'Deep Work',
        'value': '4.2h',
        'color': AppColors.secondary,
      },
      {
        'icon': Icons.auto_graph,
        'label': 'Consistency',
        'value': '14d',
        'color': AppColors.tertiary,
      },
      {
        'icon': Icons.inventory_2,
        'label': 'Backlog',
        'value': '29',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.forum,
        'label': 'Collab',
        'value': '12%',
        'color': AppColors.secondary,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nebula Overview', style: AppTypography.sectionTitle),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final m = metrics[index];
            return ShadcnCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 16,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        m['icon'] as IconData,
                        color: m['color'] as Color,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (m['label'] as String).toUpperCase(),
                        style: AppTypography.typeBadge.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m['value'] as String,
                        style: AppTypography.statValueSmall.copyWith(
                          color: m['color'] as Color,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
                .animate(delay: (50 * index).ms)
                .fadeIn()
                .scale(begin: const Offset(0.95, 0.95));
          },
        ),
      ],
    );
  }
}

class _PerformanceGrid extends StatelessWidget {
  final bool isDesktop;
  const _PerformanceGrid({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final leftCard = ShadcnCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Learning Performance', style: AppTypography.cardTitle),
              Row(
                children: [
                  _FilterChip(label: 'Real-time', isActive: false),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Monthly', isActive: true),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _ProgressBar(
            label: 'Deep Focus Sessions',
            value: 0.85,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 16),
          _ProgressBar(
            label: 'Information Retention',
            value: 0.62,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          _ProgressBar(
            label: 'Peer Engagement',
            value: 0.41,
            color: AppColors.tertiary,
          ),
        ],
      ),
    );
    final rightCard = ShadcnCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subject Breakdown', style: AppTypography.cardTitle),
          const SizedBox(height: 16),
          _SubjectRow(
            label: 'Computer Science',
            hours: '32h',
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _SubjectRow(
            label: 'Astrophysics',
            hours: '24h',
            color: AppColors.secondary,
          ),
          const SizedBox(height: 12),
          _SubjectRow(
            label: 'Digital Design',
            hours: '18h',
            color: AppColors.tertiary,
          ),
          const SizedBox(height: 12),
          _SubjectRow(
            label: 'Others',
            hours: '12h',
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withAlpha(51),
                        AppColors.secondary.withAlpha(51),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Top Badge', style: AppTypography.typeBadge),
                    Text(
                      'Orbit Master IV',
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
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
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: leftCard),
          const SizedBox(width: 24),
          Expanded(flex: 1, child: rightCard),
        ],
      );
    }
    return Column(children: [leftCard, const SizedBox(height: 24), rightCard]);
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  const _FilterChip({required this.label, required this.isActive});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withAlpha(51)
            : Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(999),
        border: isActive
            ? Border.all(color: AppColors.primary.withAlpha(51))
            : null,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.typeBadge.copyWith(
          color: isActive
              ? AppColors.primary
              : AppColors.onSurfaceVariant.withAlpha(128),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _ProgressBar({
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.typeBadge.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            Text(
              '${(value * 100).toInt()}% Efficiency',
              style: AppTypography.typeBadge.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth * value,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(color: color.withAlpha(153), blurRadius: 15),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SubjectRow extends StatelessWidget {
  final String label;
  final String hours;
  final Color color;
  const _SubjectRow({
    required this.label,
    required this.hours,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [BoxShadow(color: color.withAlpha(153), blurRadius: 8)],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: AppTypography.body)),
        Text(
          hours,
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<dynamic> weeklyActivity;
  const _WeeklyChart({required this.weeklyActivity});

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final data = weeklyActivity.isEmpty
        ? List.generate(7, (i) => 0.0)
        : weeklyActivity.map((a) => a.itemsCompleted.toDouble()).toList();
    final maxVal = data.isEmpty ? 10.0 : data.reduce((a, b) => a > b ? a : b);
    final maxIndex = data.indexOf(maxVal);

    return ShadcnCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Activity Distribution', style: AppTypography.cardTitle),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(days.length, (i) {
                final heightPercent = maxVal > 0
                    ? (data[i].toDouble() / maxVal)
                    : 0.0;
                final isMax = i == maxIndex && data[i] > 0;
                final colors = [
                  AppColors.primary,
                  AppColors.primary,
                  AppColors.primary,
                  AppColors.primary,
                  AppColors.secondary,
                  AppColors.tertiary,
                  Colors.white.withAlpha(26),
                ];

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: heightPercent),
                          duration: Duration(milliseconds: 500 + (i * 100)),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Container(
                              width: double.infinity,
                              height: value * 200,
                              decoration: BoxDecoration(
                                color: colors[i],
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                boxShadow: isMax
                                    ? [
                                        BoxShadow(
                                          color: colors[i].withAlpha(102),
                                          blurRadius: 15,
                                          offset: const Offset(0, -5),
                                        ),
                                      ]
                                    : null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[i],
                          style: AppTypography.typeBadge.copyWith(
                            color: isMax
                                ? AppColors.secondary
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}

class _CompletionRateChart extends StatelessWidget {
  final int completionRate;
  const _CompletionRateChart({required this.completionRate});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(32),
      borderRadius: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Completion Rate by Type', style: AppTypography.cardTitle),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 192,
                height: 192,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(192, 192),
                      painter: _PieChartPainter(
                        values: [0.6, 0.25, 0.15],
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                          AppColors.tertiary,
                        ],
                      ),
                    ),
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainerLowest,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '74%',
                            style: AppTypography.statValue.copyWith(
                              color: AppColors.onSurface,
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            'Global Avg',
                            style: AppTypography.typeBadge.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(color: AppColors.primary, label: 'Courses (60%)'),
                  const SizedBox(height: 12),
                  _LegendItem(
                    color: AppColors.secondary,
                    label: 'Reading (25%)',
                  ),
                  const SizedBox(height: 12),
                  _LegendItem(color: AppColors.tertiary, label: 'Exams (15%)'),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1);
  }
}

class _PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  _PieChartPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..style = PaintingStyle.fill;
    double startAngle = -3.14159 / 2;

    for (int i = 0; i < values.length; i++) {
      paint.color = colors[i];
      canvas.drawArc(rect, startAngle, values[i] * 6.28318, true, paint);
      startAngle += values[i] * 6.28318;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [BoxShadow(color: color.withAlpha(153), blurRadius: 8)],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _HeatMapSection extends StatelessWidget {
  const _HeatMapSection();

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.secondary,
      AppColors.primary.withAlpha(102),
      Colors.white.withAlpha(13),
      AppColors.primary,
      AppColors.primary.withAlpha(51),
      AppColors.secondary.withAlpha(153),
      AppColors.primary,
      Colors.white.withAlpha(13),
      AppColors.primary.withAlpha(153),
      AppColors.tertiary,
      Colors.white.withAlpha(13),
      AppColors.secondary,
      AppColors.primary.withAlpha(102),
      AppColors.primary,
      AppColors.secondary.withAlpha(102),
      Colors.white.withAlpha(13),
      AppColors.primary,
      AppColors.primary.withAlpha(204),
      Colors.white.withAlpha(13),
      AppColors.primary.withAlpha(51),
      AppColors.secondary,
      AppColors.primary,
      AppColors.primary.withAlpha(102),
      AppColors.secondary.withAlpha(153),
      Colors.white.withAlpha(13),
      AppColors.tertiary.withAlpha(153),
      AppColors.primary.withAlpha(51),
      AppColors.secondary,
    ];

    return ShadcnCard(
      padding: const EdgeInsets.all(32),
      borderRadius: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Activity Heat Map', style: AppTypography.cardTitle),
              Text('Last 28 Days intensity', style: AppTypography.bodySmall),
            ],
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 28,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: colors[index],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: colors[index] != Colors.white.withAlpha(13)
                      ? [
                          BoxShadow(
                            color: colors[index].withAlpha(102),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }
}

class _PomodoroStats extends StatelessWidget {
  const _PomodoroStats();

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(32),
      borderRadius: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppColors.tertiary,
              ),
              const SizedBox(width: 12),
              Text('Pomodoro Stats', style: AppTypography.cardTitle),
            ],
          ),
          const SizedBox(height: 24),
          _PomodoroStatRow(label: 'Focus Periods', value: '142'),
          const SizedBox(height: 16),
          _PomodoroStatRow(
            label: 'Total Flow Time',
            value: '58.5h',
            color: AppColors.secondary,
          ),
          const SizedBox(height: 16),
          _PomodoroStatRow(
            label: 'Interruption Rate',
            value: '2.4/day',
            color: AppColors.tertiary,
          ),
          const Spacer(),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PomodoroScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.rocket_launch, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Start Focus Session',
                  style: AppTypography.label.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.1);
  }
}

class _AdvancedInsights extends StatelessWidget {
  final Analytics analytics;
  const _AdvancedInsights({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Advanced Insights', style: AppTypography.sectionTitle),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _ScoreCard(
                      title: 'Focus Score',
                      score: analytics.focusScore,
                      icon: Icons.psychology,
                      color: AppColors.primary,
                      description: 'Based on daily focus time',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ScoreCard(
                      title: 'Consistency',
                      score: analytics.consistencyScore,
                      icon: Icons.event_repeat,
                      color: AppColors.secondary,
                      description: '30-day activity pattern',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _PeakHourCard(peakHour: analytics.peakHour)),
                ],
              );
            }
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ScoreCard(
                        title: 'Focus Score',
                        score: analytics.focusScore,
                        icon: Icons.psychology,
                        color: AppColors.primary,
                        description: 'Based on daily focus time',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ScoreCard(
                        title: 'Consistency',
                        score: analytics.consistencyScore,
                        icon: Icons.event_repeat,
                        color: AppColors.secondary,
                        description: '30-day activity pattern',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _PeakHourCard(peakHour: analytics.peakHour),
              ],
            );
          },
        ),
        const SizedBox(height: 32),
        _GrowthCard(
          title: 'Week-over-Week',
          growth: analytics.weekOverWeekGrowth,
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 16),
        _GrowthCard(
          title: 'Month-over-Month',
          growth: analytics.monthOverMonthGrowth,
          icon: Icons.calendar_month,
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }
}

class _ScoreCard extends StatelessWidget {
  final String title;
  final double score;
  final IconData icon;
  final Color color;
  final String description;

  const _ScoreCard({
    required this.title,
    required this.score,
    required this.icon,
    required this.color,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score * 100).toInt();
    return ShadcnCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      glowColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title, style: AppTypography.cardTitle),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$percentage%',
                style: AppTypography.statValue.copyWith(
                  color: color,
                  fontSize: 36,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getScoreLabel(score),
                  style: AppTypography.typeBadge.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTypography.caption.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score,
              backgroundColor: color.withAlpha(26),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreLabel(double score) {
    if (score >= 0.8) return 'Excellent';
    if (score >= 0.6) return 'Good';
    if (score >= 0.4) return 'Fair';
    return 'Low';
  }
}

class _PeakHourCard extends StatelessWidget {
  final int peakHour;
  const _PeakHourCard({required this.peakHour});

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      glowColor: AppColors.tertiary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.schedule,
                  color: AppColors.tertiary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text('Peak Hour', style: AppTypography.cardTitle),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _formatHour(peakHour),
            style: AppTypography.statValue.copyWith(
              color: AppColors.tertiary,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Most productive time',
            style: AppTypography.caption.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthCard extends StatelessWidget {
  final String title;
  final double growth;
  final IconData icon;

  const _GrowthCard({
    required this.title,
    required this.growth,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = growth >= 0;
    final color = isPositive ? AppColors.tertiary : AppColors.error;

    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.body),
                Text(
                  '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%',
                  style: AppTypography.statValueSmall.copyWith(
                    color: color,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: color,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _PomodoroStatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _PomodoroStatRow({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(color: AppColors.onSurfaceVariant),
        ),
        Text(
          value,
          style: AppTypography.statValueSmall.copyWith(
            color: color ?? AppColors.onSurface,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
