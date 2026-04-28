import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/responsive.dart';
import '../../../shared/widgets/shadcn_widgets.dart';
import '../../../services/database/database.dart';
import '../../shared/providers/drift_providers.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(communityFeedProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final analyticsAsync = ref.watch(analyticsProvider);
    final achievementsAsync = ref.watch(achievementsProvider);
    final pollsAsync = ref.watch(pollsProvider);

    return feedAsync.when(
      data: (feed) => profileAsync.when(
        data: (profile) => analyticsAsync.when(
          data: (analytics) => achievementsAsync.when(
            data: (achievements) => pollsAsync.when(
              data: (polls) => _buildContent(
                context,
                ref,
                feed,
                profile ??
                    UserProfile(
                      id: 'default',
                      username: 'User',
                      level: 1,
                      xp: 0,
                      totalXp: 0,
                      streakDays: 0,
                      longestStreak: 0,
                      lastActiveAt: DateTime.now(),
                      createdAt: DateTime.now(),
                    ),
                analytics,
                achievements,
                polls,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) =>
                  Center(child: Text('Error loading polls: $e')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, stack) =>
                Center(child: Text('Error loading achievements: $e')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, stack) =>
              Center(child: Text('Error loading analytics: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error loading profile: $e')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text('Error loading feed: $e')),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<CommunityPost> feed,
    UserProfile profile,
    List<DailyActivity> analytics,
    List<Achievement> achievements,
    List<CommunityPost> polls,
  ) {
    final unlockedCount = achievements.where((a) => a.unlocked).length;
    final deviceType = context.deviceType;
    final isDesktop =
        deviceType == DeviceType.desktop || deviceType == DeviceType.wide;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: isDesktop
          ? Row(
              children: [
                Expanded(
                  child: _FeedContent(
                    feed: feed,
                    profile: profile,
                    polls: polls,
                  ),
                ),
                Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest.withAlpha(128),
                    border: Border(
                      left: BorderSide(color: Colors.white.withAlpha(13)),
                    ),
                  ),
                  child: _RightSidebar(
                    profile: profile,
                    analytics: analytics.firstWhere(
                      (a) => a.date.isAtSameMomentAs(DateTime.now()),
                      orElse: () => DailyActivity(
                        id: '',
                        date: DateTime.now(),
                        itemsCompleted: 0,
                        totalMinutes: 0,
                        xpEarned: 0,
                        pomodorosCompleted: 0,
                      ),
                    ),
                    unlockedCount: unlockedCount,
                  ),
                ),
              ],
            )
          : _FeedContent(feed: feed, profile: profile, polls: polls),
    );
  }
}

class _FeedContent extends StatefulWidget {
  final List<CommunityPost> feed;
  final UserProfile profile;
  final List<CommunityPost> polls;

  const _FeedContent({
    required this.feed,
    required this.profile,
    required this.polls,
  });

  @override
  State<_FeedContent> createState() => _FeedContentState();
}

class _FeedContentState extends State<_FeedContent> {
  String _activeFilter = 'Top Stories';

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _HeroBanner()),
        if (widget.polls.isNotEmpty)
          SliverToBoxAdapter(child: _PollsSection(polls: widget.polls)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                _FeedFilter(
                  label: 'Top Stories',
                  isActive: _activeFilter == 'Top Stories',
                  onTap: () => setState(() => _activeFilter = 'Top Stories'),
                ),
                const SizedBox(width: 8),
                _FeedFilter(
                  label: 'Recent',
                  isActive: _activeFilter == 'Recent',
                  onTap: () => setState(() => _activeFilter = 'Recent'),
                ),
                const SizedBox(width: 8),
                _FeedFilter(
                  label: 'My Circle',
                  isActive: _activeFilter == 'My Circle',
                  onTap: () => setState(() => _activeFilter = 'My Circle'),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _PostCard(post: widget.feed[index]),
              ),
              childCount: widget.feed.length,
            ),
          ),
        ),
        if (widget.feed.isEmpty)
          const SliverFillRemaining(hasScrollBody: false, child: _EmptyFeed()),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _PollsSection extends StatelessWidget {
  final List<CommunityPost> polls;
  const _PollsSection({required this.polls});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Community Polls', style: AppTypography.sectionTitle),
          const SizedBox(height: 16),
          ...polls.map(
            (poll) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _PollCard(poll: poll),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}

class _PollCard extends ConsumerWidget {
  final CommunityPost poll;
  const _PollCard({required this.poll});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      glowColor: AppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.poll,
                  color: AppColors.secondary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(poll.title, style: AppTypography.cardTitle)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: poll.isLiked
                      ? AppColors.tertiary.withAlpha(26)
                      : Colors.white.withAlpha(13),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  poll.isLiked ? 'Active' : 'Closed',
                  style: AppTypography.typeBadge.copyWith(
                    color: poll.isLiked
                        ? AppColors.tertiary
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Since we don't have PollOption in our drift schema yet,
          // we'll skip the options for now and just show the post
          const SizedBox(height: 8),
          Text(
            '${poll.likes} votes',
            style: AppTypography.caption.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withAlpha(26),
            AppColors.surface,
            AppColors.secondary.withAlpha(13),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.surfaceContainerLowest.withAlpha(204),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Community: ',
                    style: AppTypography.heroTitle.copyWith(
                      color: AppColors.onSurface,
                      fontSize: 36,
                    ),
                    children: [
                      TextSpan(
                        text: 'Galactic Scholars',
                        style: TextStyle(
                          fontFamily: AppTypography.headlineFont,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.5,
                          foreground: Paint()
                            ..shader = AppColors.brandGradient.createShader(
                              const Rect.fromLTWH(0, 0, 300, 40),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect with thousands of voyagers across the sector sharing knowledge and milestones.',
                  style: AppTypography.subtitle.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedFilter extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _FeedFilter({required this.label, required this.isActive, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.secondary.withAlpha(26)
              : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(999),
          border: isActive
              ? Border.all(color: AppColors.secondary.withAlpha(51))
              : null,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withAlpha(26),
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            fontWeight: FontWeight.w700,
            color: isActive ? AppColors.secondary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final CommunityPost post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(32),
      borderRadius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.brandGradient,
                  border: Border.all(color: AppColors.primary.withAlpha(51)),
                ),
                child: Center(
                  child: Text(
                    post.authorName.isNotEmpty
                        ? post.authorName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.authorName, style: AppTypography.cardTitle),
                    Text(
                      'UPDATE', // Since we don't have type in CommunityPosts table yet
                      style: AppTypography.typeBadge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${DateTime.now().difference(post.createdAt).inHours}h ago',
                style: AppTypography.caption,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Content
          Text(post.content, style: AppTypography.bodyLarge),
          const SizedBox(height: 24),
          // Actions
          Row(
            children: [
              _PostAction(
                icon: Icons.favorite,
                label: '${post.likes} Boosts',
                color: AppColors.tertiary,
                onTap: () {
                  // TODO: Toggle like on post
                },
              ),
              const SizedBox(width: 24),
              _PostAction(
                icon: Icons.mode_comment,
                label: '${post.comments} Comments',
                color: AppColors.secondary,
                onTap: () {
                  _showCommentsSheet(context, post);
                },
              ),
              const Spacer(),
              _PostAction(
                icon: Icons.share,
                label: '',
                color: AppColors.primary,
                onTap: () {
                  // TODO: Share post
                },
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  void _showCommentsSheet(BuildContext context, CommunityPost post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comments', style: AppTypography.cardTitle),
            const SizedBox(height: 16),
            // Since we don't have comments in CommunityPosts table yet,
            // we'll show a placeholder
            Text(
              'Comments feature coming soon!',
              style: AppTypography.body.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _PostAction({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RightSidebar extends StatelessWidget {
  final UserProfile profile;
  final DailyActivity analytics;
  final int unlockedCount;

  const _RightSidebar({
    required this.profile,
    required this.analytics,
    required this.unlockedCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // XP Leaderboard
          ShadcnCard(
            padding: const EdgeInsets.all(24),
            borderRadius: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'XP Leaderboard',
                      style: AppTypography.label.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Icon(
                      Icons.military_tech,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _LeaderboardItem(
                  rank: 1,
                  name: 'AstroLearner',
                  xp: '24.8k',
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                const _LeaderboardItem(
                  rank: 2,
                  name: 'StarGazer',
                  xp: '22.1k',
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 12),
                const _LeaderboardItem(
                  rank: 3,
                  name: 'NebulaRunner',
                  xp: '21.5k',
                  color: AppColors.tertiary,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'View Full Galaxy',
                    textAlign: TextAlign.center,
                    style: AppTypography.typeBadge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final String xp;
  final Color color;

  const _LeaderboardItem({
    required this.rank,
    required this.name,
    required this.xp,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$rank',
          style: AppTypography.typeBadge.copyWith(
            color: rank == 1 ? color : AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(51),
          ),
          child: Center(
            child: Text(
              name.substring(0, 2).toUpperCase(),
              style: AppTypography.typeBadge.copyWith(color: color),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          xp,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.group,
              size: 40,
              color: AppColors.primary.withAlpha(128),
            ),
          ),
          const SizedBox(height: 24),
          Text('No posts yet', style: AppTypography.sectionTitle),
          const SizedBox(height: 8),
          Text('Be the first to share something!', style: AppTypography.body),
        ],
      ),
    ).animate().fadeIn();
  }
}
