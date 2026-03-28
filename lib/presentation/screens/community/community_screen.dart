import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../domain/providers/providers.dart';
import '../../../data/models/models.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final feed = ref.watch(communityFeedProvider);
    final userPosts = feed.where((p) => p.isUserPost).toList();
    final profile = ref.watch(userProfileProvider);

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
                    'Mi Actividad',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User Stats Card
                  GlassCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? AppColors.darkPrimaryContainer
                                    : AppColors.lightPrimaryContainer,
                              ),
                              child: Center(
                                child: Text(
                                  profile.nombre.isNotEmpty
                                      ? profile.nombre[0].toUpperCase()
                                      : 'U',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppColors.darkOnPrimaryContainer
                                        : AppColors.lightPrimaryContainer,
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
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AppColors.darkOnSurface
                                          : AppColors.lightOnSurface,
                                    ),
                                  ),
                                  Text(
                                    'Nivel ${profile.nivel}',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.lightPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              label: 'XP Total',
                              value: '${profile.xp}',
                              isDark: isDark,
                            ),
                            _StatItem(
                              label: 'Racha',
                              value: '${profile.streak} días',
                              isDark: isDark,
                            ),
                            _StatItem(
                              label: 'Posts',
                              value: '${userPosts.length}',
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // GitHub Connection (Future)
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.code,
                                color: Colors.black87,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'GitHub',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.darkOnSurface
                                          : AppColors.lightOnSurface,
                                    ),
                                  ),
                                  Text(
                                    'Conectar en el futuro',
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
                            Icon(
                              Icons.link_off,
                              color: isDark
                                  ? AppColors.darkOnSurfaceVariant
                                  : AppColors.lightOnSurfaceVariant,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Conecta tu cuenta de GitHub para compartir tu progreso automáticamente y ver la actividad de otros usuarios.',
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

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Historial de Actividad',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkOnSurface
                              : AppColors.lightOnSurface,
                        ),
                      ),
                      if (userPosts.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            ref.read(communityFeedProvider.notifier).refresh();
                          },
                          child: const Text('Actualizar'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // User Activity Feed
          userPosts.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GlassCard(
                      child: Column(
                        children: [
                          Icon(
                            Icons.history,
                            size: 48,
                            color: isDark
                                ? AppColors.darkOnSurfaceVariant
                                : AppColors.lightOnSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sin actividad todavía',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkOnSurface
                                  : AppColors.lightOnSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Completa items o desbloquea logros para ver tu actividad aquí',
                            textAlign: TextAlign.center,
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
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final post = userPosts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ActivityCard(post: post, isDark: isDark),
                      );
                    }, childCount: userPosts.length),
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatItem({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppColors.darkOnSurfaceVariant
                : AppColors.lightOnSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final CommunityPost post;
  final bool isDark;

  const _ActivityCard({required this.post, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getTypeColor().withValues(alpha: 0.1),
            ),
            child: Icon(_getTypeIcon(), color: _getTypeColor(), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTypeLabel(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getTypeColor(),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  post.contenido,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkOnSurface
                        : AppColors.lightOnSurface,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(post.timestamp),
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

  String _getTypeLabel() {
    switch (post.tipo) {
      case 'item_completed':
        return 'Item completado';
      case 'achievement_unlocked':
        return 'Logro desbloqueado';
      case 'item_added':
        return 'Item añadido';
      case 'streak_milestone':
        return 'Racha milestone';
      case 'level_up':
        return 'Subió de nivel';
      default:
        return 'Actividad';
    }
  }

  IconData _getTypeIcon() {
    switch (post.tipo) {
      case 'item_completed':
        return Icons.check_circle;
      case 'achievement_unlocked':
        return Icons.emoji_events;
      case 'item_added':
        return Icons.add_circle;
      case 'streak_milestone':
        return Icons.local_fire_department;
      case 'level_up':
        return Icons.arrow_upward;
      default:
        return Icons.info;
    }
  }

  Color _getTypeColor() {
    switch (post.tipo) {
      case 'item_completed':
        return Colors.green;
      case 'achievement_unlocked':
        return Colors.amber;
      case 'item_added':
        return Colors.blue;
      case 'streak_milestone':
        return Colors.orange;
      case 'level_up':
        return Colors.purple;
      default:
        return isDark
            ? AppColors.darkOnSurfaceVariant
            : AppColors.lightOnSurfaceVariant;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}
