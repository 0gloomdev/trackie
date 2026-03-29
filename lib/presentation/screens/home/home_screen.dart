import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_glass.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../detail/item_detail_screen.dart';
import '../editor/editor_screen.dart';
import '../timer/pomodoro_screen.dart';
import '../search/search_screen.dart';
import '../analytics/analytics_screen.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(learningItemsProvider);
    final stats = ref.watch(statisticsProvider);
    final pinnedItems = ref.watch(pinnedItemsProvider);
    final recentItems = ref.watch(recentInProgressItemsProvider);
    final achievements = ref.watch(achievementsProvider);
    final userPosts = ref
        .watch(communityFeedProvider)
        .where((p) => p.isUserPost)
        .take(5)
        .toList();
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _HomeAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _GreetingCard(profile: profile),
                const SizedBox(height: 24),
                _StatsBentoGrid(stats: stats),
                const SizedBox(height: 24),
                _WeeklyProgressCard(items: items, profile: profile),
                const SizedBox(height: 24),
                _QuickActions(),
                const SizedBox(height: 24),
                _DailyGoalsCard(),
                const SizedBox(height: 24),
                _PomodoroQuickWidget(),
                _RecentAchievementsCard(achievements: achievements),
                const SizedBox(height: 24),
                _ActivityTimelineCard(activities: userPosts),
                const SizedBox(height: 24),
                if (pinnedItems.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Items Fijados',
                    icon: Icons.push_pin,
                    actionText: 'Ver todos',
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  ...pinnedItems
                      .take(3)
                      .map((item) => _PinnedItemCard(item: item)),
                  const SizedBox(height: 24),
                ],
                if (recentItems.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Continuar Aprendiendo',
                    icon: Icons.play_circle_outline,
                    actionText: 'Ver todos',
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  ...recentItems
                      .take(3)
                      .map((item) => _RecentItemCard(item: item)),
                ],
                if (items.isEmpty) _EmptyDashboard(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 100,
      backgroundColor: cs.surface,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [cs.primary, cs.secondary],
          ).createShader(bounds),
          child: const Text(
            'TRACKIE',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: cs.onSurfaceVariant,
              size: 20,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final UserProfile? profile;
  const _GreetingCard({this.profile});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Buenos días';
    } else if (hour < 18) {
      greeting = 'Buenas tardes';
    } else {
      greeting = 'Buenas noches';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: TextStyle(fontSize: 16, color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        Text(
          profile?.nombre ?? 'Usuario',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
        if (profile != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Nivel ${profile!.nivel}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Text(
                '${profile!.streak} días',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _StatsBentoGrid extends StatelessWidget {
  final Map<String, dynamic> stats;
  const _StatsBentoGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = stats['total'] as int;
    final completed = stats['completed'] as int;
    final inProgress = stats['inProgress'] as int;
    final pending = stats['pending'] as int;
    final progressPercent = total > 0 ? (completed / total * 100).round() : 0;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppGlass.radiusLarge),
            border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PROGRESO TOTAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: cs.primary.withValues(alpha: 0.8),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.trending_up, color: cs.primary, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 12),
              GlassProgressBar(
                value: progressPercent / 100,
                color: cs.primary,
                height: 6,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatMiniCard(
                title: 'Completados',
                value: '$completed',
                icon: Icons.check_circle,
                color: cs.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatMiniCard(
                title: 'En Progreso',
                value: '$inProgress',
                icon: Icons.play_circle,
                color: cs.tertiary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatMiniCard(
                title: 'Pendientes',
                value: '$pending',
                icon: Icons.schedule,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatMiniCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppGlass.radiusMedium),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 18),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  final List<LearningItem> items;
  final UserProfile profile;
  const _WeeklyProgressCard({required this.items, required this.profile});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weeklyItems = items
        .where((i) => i.status == 'completed' && i.updatedAt.isAfter(weekStart))
        .length;

    final weekDays = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final today = now.weekday - 1;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Esta semana',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              Text(
                '$weeklyItems completados',
                style: TextStyle(
                  fontSize: 12,
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final isToday = index == today;
              final hasActivity = _hasActivityOnDay(index, items);
              return Column(
                children: [
                  Text(
                    weekDays[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                      color: isToday ? cs.primary : cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasActivity
                          ? cs.primary
                          : (isToday
                                ? cs.primaryContainer
                                : cs.surfaceContainerHighest),
                      border: isToday
                          ? Border.all(color: cs.primary, width: 2)
                          : null,
                    ),
                    child: hasActivity
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Text(
                'Racha: ${profile.streak} días',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
              const Spacer(),
              Text(
                '${profile.xp} XP',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _hasActivityOnDay(int dayIndex, List<LearningItem> items) {
    final now = DateTime.now();
    final dayStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1 - dayIndex));
    final dayEnd = dayStart.add(const Duration(days: 1));
    return items.any(
      (i) => i.updatedAt.isAfter(dayStart) && i.updatedAt.isBefore(dayEnd),
    );
  }
}

class _PomodoroQuickWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<_PomodoroQuickWidget> createState() =>
      _PomodoroQuickWidgetState();
}

class _PomodoroQuickWidgetState extends ConsumerState<_PomodoroQuickWidget> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pomodoroState = ref.watch(pomodoroStateProvider);
    final pomodoroTime = ref.watch(pomodoroTimeProvider);
    final minutes = pomodoroTime ~/ 60;
    final seconds = pomodoroTime % 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'POMODORO',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PomodoroScreen()),
            ),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: pomodoroState == PomodoroState.running
                          ? LinearGradient(
                              colors: [
                                Colors.red.shade400,
                                Colors.red.shade700,
                              ],
                            )
                          : null,
                      color: pomodoroState != PomodoroState.running
                          ? cs.primary.withValues(alpha: 0.2)
                          : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: pomodoroState == PomodoroState.running
                              ? Colors.white
                              : cs.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pomodoroState == PomodoroState.running
                              ? 'En progreso...'
                              : pomodoroState == PomodoroState.paused
                              ? 'Pausado'
                              : 'Listo para estudiar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pomodoroState == PomodoroState.idle
                              ? '25 minutos de enfoque'
                              : 'Toca para continuar',
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    pomodoroState == PomodoroState.running
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 36,
                    color: pomodoroState == PomodoroState.running
                        ? Colors.red
                        : cs.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentAchievementsCard extends StatelessWidget {
  final List<Achievement> achievements;
  const _RecentAchievementsCard({required this.achievements});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final unlockedAchievements = achievements
        .where((a) => a.desbloqueado)
        .take(3)
        .toList();

    if (unlockedAchievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LOGROS RECIENTES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        ...unlockedAchievements.map(
          (a) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber.withValues(alpha: 0.2),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.titulo,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          a.descripcion,
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '+${a.xpRecompensa} XP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivityTimelineCard extends StatelessWidget {
  final List<CommunityPost> activities;
  const _ActivityTimelineCard({required this.activities});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (activities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACTIVIDAD RECIENTE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            children: activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              final isLast = index == activities.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getTypeColor(
                            activity.tipo,
                          ).withValues(alpha: 0.2),
                        ),
                        child: Icon(
                          _getTypeIcon(activity.tipo),
                          size: 16,
                          color: _getTypeColor(activity.tipo),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 24,
                          color: cs.surfaceContainerHighest,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.contenido,
                            style: TextStyle(fontSize: 13, color: cs.onSurface),
                          ),
                          Text(
                            _formatTime(activity.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _getTypeIcon(String tipo) {
    switch (tipo) {
      case 'item_completed':
        return Icons.check_circle;
      case 'achievement_unlocked':
        return Icons.emoji_events;
      case 'streak_milestone':
        return Icons.local_fire_department;
      case 'level_up':
        return Icons.arrow_upward;
      default:
        return Icons.circle;
    }
  }

  Color _getTypeColor(String tipo) {
    switch (tipo) {
      case 'item_completed':
        return Colors.green;
      case 'achievement_unlocked':
        return Colors.amber;
      case 'streak_milestone':
        return Colors.orange;
      case 'level_up':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${time.day}/${time.month}';
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCIONES RÁPIDAS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.add,
                label: 'Nuevo',
                color: cs.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditorScreen(),
                    fullscreenDialog: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.search,
                label: 'Buscar',
                color: cs.secondary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.timer,
                label: 'Pomodoro',
                color: Colors.redAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PomodoroScreen()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.bar_chart,
                label: 'Stats',
                color: cs.tertiary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppGlass.radiusMedium),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
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
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String actionText;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: cs.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: 12,
              color: cs.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _PinnedItemCard extends StatelessWidget {
  final LearningItem item;
  const _PinnedItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = AppHelpers.getTypeColor(item.type);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: item.id)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppGlass.radiusMedium),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                AppHelpers.getTypeIcon(item.type),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        AppHelpers.getTypeName(item.type),
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${item.progress}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.push_pin, color: cs.primary, size: 16),
          ],
        ),
      ),
    );
  }
}

class _RecentItemCard extends StatelessWidget {
  final LearningItem item;
  const _RecentItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = AppHelpers.getTypeColor(item.type);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: item.id)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppGlass.radiusMedium),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                AppHelpers.getTypeIcon(item.type),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GlassProgressBar(
                    value: item.progress / 100,
                    color: color,
                    height: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${item.progress}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppGlass.radiusLarge),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.rocket_launch, size: 40, color: cs.primary),
          ),
          const SizedBox(height: 24),
          Text(
            '¡Comienza tu viaje!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primer contenido\npara comenzar a aprender',
            style: TextStyle(
              fontSize: 14,
              color: cs.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GlassButton(
            label: 'Agregar contenido',
            icon: Icons.add,
            isPrimary: true,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EditorScreen(),
                fullscreenDialog: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyGoalsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final goals = ref.watch(dailyGoalsProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayGoal = goals.isNotEmpty
        ? goals.firstWhere(
            (g) => DateTime(
              g.date.year,
              g.date.month,
              g.date.day,
            ).isAtSameMomentAs(today),
            orElse: () => DailyGoal(),
          )
        : DailyGoal();

    final itemsProgress = todayGoal.itemsToComplete > 0
        ? todayGoal.itemsCompleted / todayGoal.itemsToComplete
        : 0.0;
    final minutesProgress = todayGoal.minutesToStudy > 0
        ? todayGoal.minutesStudied / todayGoal.minutesToStudy
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'METAS DIARIAS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: cs.onSurfaceVariant,
              ),
            ),
            GestureDetector(
              onTap: () => _showGoalsDialog(context, ref, todayGoal),
              child: Row(
                children: [
                  Text(
                    'Editar',
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.edit, size: 14, color: cs.primary),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: todayGoal.completed
                          ? Colors.green.withValues(alpha: 0.2)
                          : cs.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      todayGoal.completed ? Icons.check_circle : Icons.flag,
                      color: todayGoal.completed ? Colors.green : cs.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todayGoal.completed
                              ? '¡Meta completada!'
                              : 'Meta de hoy',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          '${todayGoal.itemsCompleted}/${todayGoal.itemsToComplete} items • ${todayGoal.minutesStudied}/${todayGoal.minutesToStudy} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (todayGoal.completed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '✓',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Items',
                              style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${todayGoal.itemsCompleted}/${todayGoal.itemsToComplete}',
                              style: TextStyle(
                                fontSize: 11,
                                color: cs.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        GlassProgressBar(
                          value: itemsProgress.clamp(0.0, 1.0),
                          color: cs.primary,
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tiempo',
                              style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${todayGoal.minutesStudied}/${todayGoal.minutesToStudy}m',
                              style: TextStyle(
                                fontSize: 11,
                                color: cs.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        GlassProgressBar(
                          value: minutesProgress.clamp(0.0, 1.0),
                          color: cs.secondary,
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showGoalsDialog(BuildContext context, WidgetRef ref, DailyGoal goal) {
    final itemsController = TextEditingController(
      text: goal.itemsToComplete.toString(),
    );
    final minutesController = TextEditingController(
      text: goal.minutesToStudy.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Editar metas diarias'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Items a completar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: minutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minutos de estudio',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final items = int.tryParse(itemsController.text) ?? 3;
              final minutes = int.tryParse(minutesController.text) ?? 30;

              ref
                  .read(dailyGoalsProvider.notifier)
                  .updateTodayGoal(
                    goal.copyWith(
                      itemsToComplete: items,
                      minutesToStudy: minutes,
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
