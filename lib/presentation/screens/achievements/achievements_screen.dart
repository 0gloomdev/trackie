import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../domain/providers/providers.dart';
import '../../../data/models/models.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final achievements = ref.watch(achievementsProvider);
    final profile = ref.watch(userProfileProvider);

    final unlockedCount = achievements.where((a) => a.desbloqueado).length;
    final totalXP = achievements
        .where((a) => a.desbloqueado)
        .fold(0, (sum, a) => sum + a.xpRecompensa);

    // Sort: unlocked first, then by date
    final sortedAchievements = [...achievements]
      ..sort((a, b) {
        if (a.desbloqueado && !b.desbloqueado) return -1;
        if (!a.desbloqueado && b.desbloqueado) return 1;
        if (a.desbloqueado && b.desbloqueado) {
          return b.desbloqueadoEn!.compareTo(a.desbloqueadoEn!);
        }
        return 0;
      });

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // Header with XP
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Logros',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // XP Card
                  Container(
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? AppColors.liquidGradient
                          : LinearGradient(
                              colors: [
                                AppColors.lightPrimary.withValues(alpha: 0.2),
                                AppColors.lightPrimaryContainer.withValues(
                                  alpha: 0.2,
                                ),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GlassCard(
                      backgroundColor:
                          (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              .withValues(alpha: 0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nivel ${profile.nivel}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.lightPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${profile.xp} XP totales',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? AppColors.darkOnSurfaceVariant
                                          : AppColors.lightOnSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkSecondary.withValues(
                                          alpha: 0.2,
                                        )
                                      : AppColors.lightSecondary.withValues(
                                          alpha: 0.2,
                                        ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_fire_department,
                                      color: isDark
                                          ? AppColors.darkSecondary
                                          : AppColors.lightSecondary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${profile.streak} días',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? AppColors.darkSecondary
                                            : AppColors.lightSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Progress to next level
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: (profile.xp % 1000) / 1000,
                              minHeight: 8,
                              backgroundColor: isDark
                                  ? AppColors.darkSurfaceContainerHighest
                                  : AppColors.lightSurfaceContainerHighest,
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${1000 - (profile.xp % 1000)} XP para el siguiente nivel',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkOnSurfaceVariant
                                  : AppColors.lightOnSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _StatChip(
                          label: 'Desbloqueados',
                          value: '$unlockedCount/${achievements.length}',
                          icon: Icons.emoji_events,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatChip(
                          label: 'XP Ganados',
                          value: totalXP.toString(),
                          icon: Icons.star,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Achievements Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final achievement = sortedAchievements[index];
                return _AchievementCard(
                  achievement: achievement,
                  isDark: isDark,
                );
              }, childCount: sortedAchievements.length),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkOnSurface
                      : AppColors.lightOnSurface,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant
                      : AppColors.lightOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isDark;

  const _AchievementCard({required this.achievement, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.desbloqueado;
    final primaryColor = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return GlassCard(
      backgroundColor: isUnlocked
          ? primaryColor.withValues(alpha: 0.1)
          : (isDark
                    ? AppColors.darkSurfaceContainer
                    : AppColors.lightSurfaceContainerHighest)
                .withValues(alpha: 0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? primaryColor.withValues(alpha: 0.2)
                  : (isDark
                            ? AppColors.darkSurfaceContainerHighest
                            : AppColors.lightSurfaceContainerHighest)
                        .withValues(alpha: 0.5),
              border: isUnlocked
                  ? Border.all(
                      color: primaryColor.withValues(alpha: 0.5),
                      width: 2,
                    )
                  : null,
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Icon(
                _getIconData(achievement.icono),
                color: isUnlocked
                    ? primaryColor
                    : (isDark
                              ? AppColors.darkOnSurfaceVariant
                              : AppColors.lightOnSurfaceVariant)
                          .withValues(alpha: 0.5),
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            achievement.titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isUnlocked
                  ? (isDark
                        ? AppColors.darkOnSurface
                        : AppColors.lightOnSurface)
                  : (isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.lightOnSurfaceVariant)
                        .withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '+${achievement.xpRecompensa} XP',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isUnlocked
                  ? primaryColor
                  : (isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.lightOnSurfaceVariant)
                        .withValues(alpha: 0.4),
            ),
          ),
          if (isUnlocked && achievement.desbloqueadoEn != null) ...[
            const SizedBox(height: 4),
            Text(
              _formatDate(achievement.desbloqueadoEn!),
              style: TextStyle(
                fontSize: 9,
                color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.lightOnSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'emoji_events':
        return Icons.emoji_events;
      case 'menu_book':
        return Icons.menu_book;
      case 'school':
        return Icons.school;
      case 'local_library':
        return Icons.local_library;
      case 'military_tech':
        return Icons.military_tech;
      case 'bolt':
        return Icons.bolt;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'whatshot':
        return Icons.whatshot;
      case 'star':
        return Icons.star;
      case 'flag':
        return Icons.flag;
      case 'insights':
        return Icons.insights;
      case 'nightlight':
        return Icons.nightlight;
      default:
        return Icons.emoji_events;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Hoy';
    } else if (diff.inDays == 1) {
      return 'Ayer';
    } else if (diff.inDays < 7) {
      return 'Hace ${diff.inDays} días';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
