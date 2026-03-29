import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../core/utils/translations.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final t = Translations(settings.locale);
    final feed = ref.watch(communityFeedProvider);
    final userPosts = feed.where((p) => p.isUserPost).toList();
    final profile = ref.watch(userProfileProvider);
    final analytics = ref.watch(analyticsProvider);
    final achievements = ref.watch(achievementsProvider);
    final unlockedCount = achievements.where((a) => a.desbloqueado).length;

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
                  _Header(title: t.community, subtitle: t.yourActivity),
                  const SizedBox(height: 24),
                  _UserStatsCard(
                    profile: profile,
                    postsCount: userPosts.length,
                  ),
                  const SizedBox(height: 32),
                  _SectionTitle(title: t.myProgress),
                  const SizedBox(height: 16),
                  _ProgressCards(profile: profile),
                  const SizedBox(height: 32),
                  _SectionTitle(title: 'Estadísticas'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1.3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate([
                _StatCard(
                  icon: Icons.folder,
                  value: '${analytics.completedItems}',
                  label: 'Items completados',
                  color: AppColors.shadcnPrimary,
                ),
                _StatCard(
                  icon: Icons.check_circle,
                  value: '${profile.streak}',
                  label: 'Días de racha',
                  color: Colors.orange,
                ),
                _StatCard(
                  icon: Icons.star,
                  value: '${profile.xp}',
                  label: 'XP Total',
                  color: Colors.amber,
                ),
                _StatCard(
                  icon: Icons.emoji_events,
                  value: '$unlockedCount',
                  label: t.achievements,
                  color: Colors.purple,
                ),
              ]),
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

class _UserStatsCard extends StatelessWidget {
  final UserProfile profile;
  final int postsCount;

  const _UserStatsCard({required this.profile, required this.postsCount});

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
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
              ),
            ),
            child: Center(
              child: Text(
                profile.nombre.isNotEmpty
                    ? profile.nombre[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                  profile.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _LevelBadge(level: profile.nivel),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${profile.streak} días',
                      style: TextStyle(fontSize: 14, color: Colors.orange),
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

class _LevelBadge extends StatelessWidget {
  final int level;

  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Nivel $level',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
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

class _ProgressCards extends StatelessWidget {
  final UserProfile profile;

  const _ProgressCards({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ProgressCard(
            title: 'Nivel',
            current: profile.nivel,
            max: 10,
            color: AppColors.shadcnPrimary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ProgressCard(
            title: 'XP',
            current: profile.xp,
            max: 1000,
            color: Colors.amber,
          ),
        ),
      ],
    ).animate(delay: 200.ms).fadeIn();
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final int current;
  final int max;
  final Color color;

  const _ProgressCard({
    required this.title,
    required this.current,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(179),
                ),
              ),
              Text(
                '$current / $max',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ShadcnProgress(value: current / max, color: color),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withAlpha(128),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
