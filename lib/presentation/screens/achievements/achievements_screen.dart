import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../core/widgets/glass_design.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../../../domain/providers/customization_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);
    final profile = ref.watch(userProfileProvider);
    final customization = ref.watch(customizationProvider);

    final unlockedCount = achievements.where((a) => a.unlocked).length;
    final totalXP = achievements
        .where((a) => a.unlocked)
        .fold(0, (sum, a) => sum + a.xpReward);

    final sortedAchievements = [...achievements]
      ..sort((a, b) {
        if (a.unlocked && !b.unlocked) return -1;
        if (!a.unlocked && b.unlocked) return 1;
        if (a.unlocked && b.unlocked) {
          return b.unlockedAt!.compareTo(a.unlockedAt!);
        }
        return 0;
      });

    final effectivePadding = customization.compactMode ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(effectivePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(),
                  const SizedBox(height: 24),
                  _XPStatsCard(
                    unlockedCount: unlockedCount,
                    totalAchievements: achievements.length,
                    totalXP: totalXP,
                    level: profile.nivel,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: effectivePadding),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _AchievementCard(
                  achievement: sortedAchievements[index],
                  index: index,
                ),
                childCount: sortedAchievements.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Your ',
                      style: AppTypography.pageTitle.copyWith(
                        color: AppColors.onSurface,
                      ),
                      children: [
                        TextSpan(
                          text: 'Milestones',
                          style: AppTypography.pageTitle.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unlock achievements by completing tasks and mastering new knowledge. Each star is a step closer to universal mastery.',
                    style: AppTypography.subtitle.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2);
  }
}

class _XPStatsCard extends StatelessWidget {
  final int unlockedCount;
  final int totalAchievements;
  final int totalXP;
  final int level;

  const _XPStatsCard({
    required this.unlockedCount,
    required this.totalAchievements,
    required this.totalXP,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 32,
      padding: const EdgeInsets.all(32),
      opacity: 0.1,
      blur: 15,
      borderColor: AppColors.primary.withValues(alpha: 0.2),
      glowColor: AppColors.primary.withValues(alpha: 0.3),
      child: Row(
        children: [
          // Avatar / Rank Visual
          Stack(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withAlpha(51),
                    width: 4,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.brandGradient,
                  ),
                  child: const Icon(
                    Icons.military_tech,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withAlpha(128),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Text(
                    'LVL $level',
                    style: AppTypography.typeBadge.copyWith(
                      color: AppColors.onSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nebula Voyager', style: AppTypography.sectionTitle),
                const SizedBox(height: 4),
                Text(
                  'Rank progress toward Galactic Scholar',
                  style: AppTypography.body.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total XP',
                            style: AppTypography.typeBadge.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('$totalXP', style: AppTypography.statValueSmall),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Streak',
                            style: AppTypography.typeBadge.copyWith(
                              color: AppColors.tertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$unlockedCount / $totalAchievements',
                            style: AppTypography.statValueSmall,
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
      ),
    ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1);
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final int index;

  const _AchievementCard({required this.achievement, required this.index});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.unlocked;

    return ShadcnCard(
          padding: const EdgeInsets.all(24),
          hoverEffect: true,
          borderRadius: 24,
          glowColor: isUnlocked ? AppColors.primary : null,
          onTap: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: AppColors.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(achievement.title, style: AppTypography.cardTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getAchievementIcon(achievement.type),
                    size: 80,
                    color: isUnlocked
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    achievement.description,
                    style: AppTypography.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isUnlocked
                        ? 'Unlocked'
                        : 'Locked - ${achievement.xpReward} XP',
                    style: AppTypography.bodySmall.copyWith(
                      color: isUnlocked
                          ? AppColors.success
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? AppColors.primary.withAlpha(26)
                      : AppColors.surfaceContainerHighest,
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(77),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  _getAchievementIcon(achievement.type),
                  size: 32,
                  color: isUnlocked
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.cardTitle.copyWith(
                  color: isUnlocked
                      ? AppColors.onSurface
                      : AppColors.onSurface.withAlpha(128),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: 8),
              if (isUnlocked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(51),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Unlocked',
                    style: AppTypography.typeBadge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                )
              else
                Text(
                  '+${achievement.xpReward} XP',
                  style: AppTypography.caption,
                ),
            ],
          ),
        )
        .animate(delay: (50 * index).ms)
        .fadeIn()
        .scale(begin: const Offset(0.9, 0.9));
  }

  IconData _getAchievementIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'streak':
        return Icons.wb_sunny;
      case 'items':
        return Icons.auto_stories;
      case 'completion':
        return Icons.check_circle;
      case 'social':
        return Icons.people;
      case 'explorer':
        return Icons.explore;
      case 'master':
        return Icons.psychology;
      default:
        return Icons.emoji_events;
    }
  }
}
