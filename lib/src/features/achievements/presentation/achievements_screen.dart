import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/shadcn_widgets.dart';
import '../../../shared/widgets/glass_design.dart';
import '../../shared/providers/drift_providers.dart';
import '../../shared/providers/customization_provider.dart';
import '../../../services/database/database.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final customization = ref.watch(customizationProvider);

    return achievementsAsync.when(
      data: (achievements) {
        final profile = profileAsync.value;
        final unlockedCount = achievements.where((a) => a.unlocked).length;
        final totalXP = achievements
            .where((a) => a.unlocked)
            .fold(0, (sum, a) => sum + a.xpReward);

        final sortedAchievements = [...achievements]
          ..sort((a, b) {
            if (a.unlocked && !b.unlocked) return -1;
            if (!a.unlocked && b.unlocked) return 1;
            if (a.unlocked && b.unlocked) {
              return (b.unlockedAt ?? DateTime(2000)).compareTo(
                a.unlockedAt ?? DateTime(2000),
              );
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
                        level: profile?.level ?? 1,
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
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.surfaceContainerLowest,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.surfaceContainerLowest,
        body: Center(child: Text('Error: $e')),
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

    return GestureDetector(
      onTap: () => _showAchievementDialog(context, isUnlocked),
      child:
          GlassContainer(
                borderRadius: 24,
                padding: const EdgeInsets.all(24),
                glowColor: isUnlocked ? AppColors.primary : null,
                borderColor: isUnlocked
                    ? AppColors.primary.withAlpha(128)
                    : Colors.white.withAlpha(26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isUnlocked
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withAlpha(51),
                                  AppColors.primary.withAlpha(26),
                                ],
                              )
                            : null,
                        color: isUnlocked
                            ? null
                            : AppColors.surfaceContainerHighest,
                        boxShadow: isUnlocked
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(77),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        _getAchievementIcon(achievement.category),
                        size: 32,
                        color: isUnlocked
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      achievement.name,
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
              .scale(begin: const Offset(0.9, 0.9)),
    );
  }

  void _showAchievementDialog(BuildContext context, bool isUnlocked) {
    showDialog(
      context: context,
      builder: (_) => GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.all(32),
        glowColor: isUnlocked ? AppColors.primary : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isUnlocked
                    ? LinearGradient(
                        colors: [
                          AppColors.primary.withAlpha(51),
                          AppColors.secondary.withAlpha(26),
                        ],
                      )
                    : null,
                color: isUnlocked ? null : AppColors.surfaceContainerHighest,
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(77),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                _getAchievementIcon(achievement.type),
                size: 48,
                color: isUnlocked
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
                      achievement.name,
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              achievement.description,
              style: AppTypography.body.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.success.withAlpha(26)
                    : AppColors.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isUnlocked
                      ? AppColors.success.withAlpha(51)
                      : AppColors.primary.withAlpha(51),
                ),
              ),
              child: Text(
                isUnlocked ? '★ Unlocked' : '🔒 ${achievement.xpReward} XP',
                style: AppTypography.bodySmall.copyWith(
                  color: isUnlocked ? AppColors.success : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withAlpha(51)),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAchievementIcon(String category) {
    switch (category.toLowerCase()) {
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
