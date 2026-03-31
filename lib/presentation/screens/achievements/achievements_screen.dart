import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../core/utils/translations.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final t = Translations(settings.locale);
    final achievements = ref.watch(achievementsProvider);
    final profile = ref.watch(userProfileProvider);

    final unlockedCount = achievements.where((a) => a.desbloqueado).length;
    final totalXP = achievements
        .where((a) => a.desbloqueado)
        .fold(0, (sum, a) => sum + a.xpRecompensa);

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
      backgroundColor: AppColors.shadcnBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(
                    title: t.achievements,
                    subtitle: settings.locale == 'en'
                        ? 'Unlock achievements by completing tasks'
                        : 'Desbloquea logros completando tareas',
                  ),
                  const SizedBox(height: 24),
                  _XPStatsCard(
                    unlockedCount: unlockedCount,
                    totalXP: totalXP,
                    level: profile.nivel,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                childAspectRatio: 0.85,
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
  final String title;
  final String subtitle;

  const _Header({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: Colors.white,
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
        const SizedBox(height: 4),
        Text(
          subtitle,
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

class _XPStatsCard extends StatelessWidget {
  final int unlockedCount;
  final int totalXP;
  final int level;

  const _XPStatsCard({
    required this.unlockedCount,
    required this.totalXP,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$unlockedCount de 20 logros',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+$totalXP XP ganados',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.shadcnSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.military_tech, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  'Nivel $level',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
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
    final isUnlocked = achievement.desbloqueado;

    return ShadcnCard(
          padding: const EdgeInsets.all(16),
          hoverEffect: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: isUnlocked
                      ? LinearGradient(
                          colors: [
                            AppColors.shadcnPrimary,
                            AppColors.shadcnSecondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isUnlocked ? null : Colors.white.withAlpha(13),
                  shape: BoxShape.circle,
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: AppColors.shadcnPrimary.withAlpha(77),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  _getAchievementIcon(achievement.tipo),
                  size: 28,
                  color: isUnlocked ? Colors.white : Colors.white.withAlpha(77),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                achievement.titulo,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked
                      ? Colors.white
                      : Colors.white.withAlpha(128),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: 12,
                    color: isUnlocked
                        ? Colors.amber
                        : Colors.white.withAlpha(77),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '+${achievement.xpRecompensa} XP',
                    style: TextStyle(
                      fontSize: 11,
                      color: isUnlocked
                          ? Colors.amber
                          : Colors.white.withAlpha(77),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate(delay: (50 * index).ms)
        .fadeIn()
        .scale(begin: const Offset(0.9, 0.9));
  }

  IconData _getAchievementIcon(String tipo) {
    switch (tipo) {
      case 'streak':
        return Icons.local_fire_department;
      case 'items':
        return Icons.folder;
      case 'completion':
        return Icons.check_circle;
      case 'social':
        return Icons.people;
      case 'explorer':
        return Icons.explore;
      case 'master':
        return Icons.school;
      default:
        return Icons.emoji_events;
    }
  }
}
