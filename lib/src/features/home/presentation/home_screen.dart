import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/responsive.dart';
import '../../../shared/widgets/shadcn_widgets.dart';
import '../../../shared/widgets/glass_design.dart';
import '../../../services/models/models.dart';
import '../../shared/providers/drift_providers.dart';
import '../../shared/providers/customization_provider.dart';

import '../../achievements/presentation/achievements_screen.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activitiesProvider);
    final recentItems = ref.watch(recentInProgressItemsProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final customization = ref.watch(customizationProvider);
    final deviceType = context.deviceType;
    final isDesktop =
        deviceType == DeviceType.desktop || deviceType == DeviceType.wide;

    final effectivePadding = customization.compactMode
        ? Responsive.spaceSm
        : Responsive.padding(deviceType);

    return SingleChildScrollView(
      padding: EdgeInsets.all(effectivePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroSection(profileAsync: profileAsync),
          const SizedBox(height: DesignTokens.spaceXxl),
          if (isDesktop) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: activitiesAsync.when(
                    data: (weeklyActivity) =>
                        _WeeklyChart(weeklyActivity: weeklyActivity),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, _) => const SizedBox(),
                  ),
                ),
                const SizedBox(width: DesignTokens.spaceLg),
                const Expanded(flex: 1, child: _AchievementsPreview()),
              ],
            ),
          ] else ...[
            activitiesAsync.when(
              data: (weeklyActivity) =>
                  _WeeklyChart(weeklyActivity: weeklyActivity),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox(),
            ),
            const SizedBox(height: DesignTokens.spaceLg),
            const _AchievementsPreview(),
          ],
          const SizedBox(height: DesignTokens.spaceLg),
          if (recentItems.isNotEmpty) _RecentItemsSection(items: recentItems),
          const SizedBox(height: DesignTokens.spaceXxxl),
        ],
      ),
    ).animate().fadeIn(duration: DesignTokens.fadeIn);
  }
}

class _HeroSection extends StatelessWidget {
  final AsyncValue<UserProfile?> profileAsync;

  const _HeroSection({required this.profileAsync});

  @override
  Widget build(BuildContext context) {
    final profile = profileAsync.when(
      data: (p) => p,
      loading: () => null,
      error: (_, _) => null,
    );
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 18) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Ambient glow orbs
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.neonPurple.withAlpha(26),
                  AppColors.neonPurple.withAlpha(13),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.neonCyanStrong.withAlpha(26),
                  AppColors.neonCyan.withAlpha(13),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Content
        GlassContainer(
          borderRadius: 32,
          padding: const EdgeInsets.all(48),
          opacity: 0.1,
          blur: 15,
          borderColor: Colors.white.withAlpha(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System Online badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.primary.withAlpha(51)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(128),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'System Online',
                      style: AppTypography.typeBadge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '$greeting,',
                style: AppTypography.subtitle.copyWith(
                  color: AppColors.onSurface.withAlpha(179),
                ),
              ),
              const SizedBox(height: 8),
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.brandGradient.createShader(bounds),
                child: Text(
                  '${profile?.username.isNotEmpty == true ? profile!.username : 'User'}!',
                  style: AppTypography.heroTitle.copyWith(
                    color: Colors.white,
                    fontSize: 56,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your celestial synchronization is at 94%. We\'ve identified 3 new archives for your Navigation Theory course. Ready to transcend?',
                style: AppTypography.body.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: DesignTokens.slideIn).slideY(begin: -0.1, end: 0);
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<DailyActivity> weeklyActivity;

  const _WeeklyChart({required this.weeklyActivity});

  @override
  Widget build(BuildContext context) {
    final data = weeklyActivity.isEmpty
        ? List.generate(7, (i) => 0.0)
        : weeklyActivity.map((a) => a.itemsCompleted.toDouble()).toList();

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return ShadcnCard(
          padding: const EdgeInsets.all(32),
          borderRadius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weekly Activity', style: AppTypography.cardTitle),
                      const SizedBox(height: 4),
                      Text(
                        'Learning metrics across the sector',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      _ChartFilterButton(label: 'Daily', isActive: false),
                      SizedBox(width: 8),
                      _ChartFilterButton(label: 'Weekly', isActive: true),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 256,
                child: _BarChart(data: data, labels: days),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: DesignTokens.animFast, duration: DesignTokens.animSlow)
        .slideY(begin: 0.1, end: 0);
  }
}

class _ChartFilterButton extends StatelessWidget {
  final String label;
  final bool isActive;

  const _ChartFilterButton({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.secondary : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.secondary.withAlpha(51),
                  blurRadius: 15,
                ),
              ]
            : null,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.typeBadge.copyWith(
          color: isActive ? AppColors.onSecondary : AppColors.onSurface,
        ),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;

  const _BarChart({required this.data, required this.labels});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.isEmpty ? 10.0 : data.reduce((a, b) => a > b ? a : b);
    final maxIndex = data.indexOf(maxVal);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(labels.length, (i) {
        final heightPercent = maxVal > 0 ? (data[i] / maxVal).toDouble() : 0.0;
        final isMax = i == maxIndex && data[i] > 0;

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
                        color: AppColors.secondary.withAlpha(
                          [26, 102, 255, 51, 153, 204, 26][i],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        boxShadow: isMax
                            ? [
                                BoxShadow(
                                  color: AppColors.secondary.withAlpha(102),
                                  blurRadius: 15,
                                  offset: const Offset(0, -5),
                                ),
                              ]
                            : null,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  labels[i].toUpperCase(),
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
    );
  }
}

class _RecentItemsSection extends StatefulWidget {
  final List<LearningItem> items;

  const _RecentItemsSection({required this.items});

  @override
  State<_RecentItemsSection> createState() => _RecentItemsSectionState();
}

class _RecentItemsSectionState extends State<_RecentItemsSection> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Archives', style: AppTypography.sectionTitle),
                const SizedBox(height: 4),
                Text(
                  'Jump back into the stream',
                  style: AppTypography.typeBadge.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _ScrollButton(
                  icon: Icons.chevron_left,
                  onTap: () => _scrollController.animateTo(
                    _scrollController.offset - 344,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
                const SizedBox(width: 8),
                _ScrollButton(
                  icon: Icons.chevron_right,
                  onTap: () => _scrollController.animateTo(
                    _scrollController.offset + 344,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 280,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return _RecentItemCard(item: item, index: index, onTap: () {});
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }
}

class _ScrollButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ScrollButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
      ),
    );
  }
}

class _RecentItemCard extends StatelessWidget {
  final LearningItem item;
  final int index;
  final VoidCallback? onTap;

  const _RecentItemCard({required this.item, required this.index, this.onTap});

  Color _getTypeColor() {
    switch (item.type.toLowerCase()) {
      case 'course':
        return AppColors.primary;
      case 'video':
        return AppColors.secondary;
      case 'book':
        return AppColors.tertiary;
      case 'pdf':
        return AppColors.primary;
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  IconData _getTypeIcon() {
    switch (item.type.toLowerCase()) {
      case 'course':
        return Icons.school;
      case 'video':
        return Icons.play_circle;
      case 'book':
        return Icons.menu_book;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor();

    return Container(
      width: 320,
      margin: EdgeInsets.only(right: index < 3 ? 24 : 0),
      child: ShadcnCard(
        padding: EdgeInsets.zero,
        borderRadius: 24,
        hoverEffect: true,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Container(
              height: 160,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Center(
                      child: Icon(
                        _getTypeIcon(),
                        size: 64,
                        color: typeColor.withAlpha(77),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.surfaceContainerLow.withAlpha(204),
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withAlpha(204),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.type.toUpperCase(),
                        style: AppTypography.typeBadge.copyWith(
                          color: typeColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTypography.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('Last modified: recently', style: AppTypography.caption),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.open_in_new,
                        size: 20,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.1);
  }
}

class _AchievementsPreview extends StatelessWidget {
  const _AchievementsPreview();

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(32),
      borderRadius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Milestones', style: AppTypography.cardTitle),
          const SizedBox(height: 4),
          Text('Unlocked achievements', style: AppTypography.bodySmall),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: const [
              _MilestoneCard(
                icon: Icons.wb_sunny,
                title: 'Early Bird',
                subtitle: '7-day morning streak',
                color: AppColors.primary,
                isUnlocked: true,
              ),
              _MilestoneCard(
                icon: Icons.auto_stories,
                title: 'Bookworm',
                subtitle: '50 items read',
                color: AppColors.secondary,
                isUnlocked: true,
              ),
              _MilestoneCard(
                icon: Icons.star,
                title: 'Supernova',
                subtitle: 'Elite performance',
                color: AppColors.tertiary,
                isUnlocked: true,
              ),
              _MilestoneCard(
                icon: Icons.psychology,
                title: 'Mastermind',
                subtitle: 'Advanced logic unit',
                color: AppColors.onSurfaceVariant,
                isUnlocked: false,
              ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AchievementsScreen()),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withAlpha(51)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'View Repository',
                textAlign: TextAlign.center,
                style: AppTypography.typeBadge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}

class _MilestoneCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isUnlocked;

  const _MilestoneCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isUnlocked,
  });

  @override
  State<_MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends State<_MilestoneCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isUnlocked
              ? AppColors.surfaceContainer.withAlpha(128)
              : AppColors.surfaceContainerHighest.withAlpha(128),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isUnlocked
                ? widget.color.withAlpha(51)
                : Colors.white.withAlpha(13),
          ),
          boxShadow: widget.isUnlocked
              ? [
                  BoxShadow(
                    color: widget.color.withAlpha(26),
                    blurRadius: _isHovered ? 30 : 20,
                    spreadRadius: _isHovered ? 4 : 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isUnlocked
                    ? widget.color.withAlpha(51)
                    : AppColors.surfaceContainerHighest,
                boxShadow: widget.isUnlocked
                    ? [
                        BoxShadow(
                          color: widget.color.withAlpha(26),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                widget.icon,
                color: widget.isUnlocked
                    ? widget.color
                    : AppColors.onSurfaceVariant,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: widget.isUnlocked
                    ? AppColors.onSurface
                    : AppColors.onSurface.withAlpha(128),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
