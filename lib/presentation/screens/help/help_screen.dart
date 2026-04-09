import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../core/widgets/glass_design.dart';
import '../../../domain/providers/customization_provider.dart';

class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  int? _expandedFaq;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _jumpToFaq(int index) {
    setState(() => _expandedFaq = index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;
    final customization = ref.watch(customizationProvider);
    final effectivePadding = customization.compactMode
        ? (isDesktop ? 24.0 : 16.0)
        : (isDesktop ? 48.0 : 24.0);

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(effectivePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Navigation Terminal',
                        style: AppTypography.typeBadge.copyWith(
                          color: AppColors.secondary,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Help Center: ',
                          style: TextStyle(
                            fontFamily: AppTypography.headlineFont,
                            fontSize: isDesktop ? 56 : 36,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.0,
                            color: AppColors.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: 'Your Celestial Navigator',
                              style: TextStyle(
                                fontFamily: AppTypography.headlineFont,
                                fontSize: isDesktop ? 56 : 36,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1.0,
                                foreground: Paint()
                                  ..shader =
                                      LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          AppColors.secondary,
                                          AppColors.tertiary,
                                        ],
                                      ).createShader(
                                        const Rect.fromLTWH(0, 0, 500, 60),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isDesktop)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'System Status: ',
                        style: AppTypography.body.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Operational',
                        style: AppTypography.body.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Orbiting 0.12.4-A',
                        style: AppTypography.monospace.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 64),
            // Hero Search
            Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withAlpha(51),
                          AppColors.secondary.withAlpha(51),
                        ],
                      ),
                    ),
                  ),
                ),
                ShadcnCard(
                  padding: const EdgeInsets.all(48),
                  borderRadius: 16,
                  child: Column(
                    children: [
                      Text(
                        'How can we illuminate your path?',
                        style: AppTypography.sectionTitle,
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _searchController,
                        style: AppTypography.subtitle,
                        decoration: InputDecoration(
                          hintText: 'Search help in the universe...',
                          hintStyle: AppTypography.subtitle.copyWith(
                            color: AppColors.onSurfaceVariant.withAlpha(128),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.primary,
                            size: 32,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _KbdBadge(label: '⌘'),
                              const SizedBox(width: 4),
                              _KbdBadge(label: 'K'),
                            ],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide(
                              color: AppColors.outlineVariant.withAlpha(77),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide(
                              color: AppColors.outlineVariant.withAlpha(77),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                        ),
                        onSubmitted: (value) {
                          if (value.toLowerCase().contains('sync')) {
                            _jumpToFaq(0);
                          } else if (value.toLowerCase().contains('domain')) {
                            _jumpToFaq(1);
                          } else if (value.toLowerCase().contains('pomodoro')) {
                            _jumpToFaq(2);
                          } else if (value.toLowerCase().contains('export')) {
                            _jumpToFaq(3);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        children: [
                          Text('Popular:', style: AppTypography.bodySmall),
                          _PopularLink(
                            label: 'Sync Issues',
                            onTap: () => _jumpToFaq(0),
                          ),
                          _PopularLink(
                            label: 'API Access',
                            onTap: () => _jumpToFaq(1),
                          ),
                          _PopularLink(
                            label: 'Billing Orbit',
                            onTap: () => _jumpToFaq(3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
            // Content Grid
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: _FaqSection(
                      expandedFaq: _expandedFaq,
                      onExpanded: (i) => setState(() => _expandedFaq = i),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(flex: 5, child: _RightPanel()),
                ],
              )
            else
              Column(
                children: [
                  _FaqSection(
                    expandedFaq: _expandedFaq,
                    onExpanded: (i) => setState(() => _expandedFaq = i),
                  ),
                  const SizedBox(height: 32),
                  _RightPanel(),
                ],
              ),
            const SizedBox(height: 64),
            // Footer Stats
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white.withAlpha(13)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _FooterStat(value: '24/7', label: 'Ground Control'),
                      const SizedBox(width: 48),
                      _FooterStat(value: '99.9%', label: 'Uptime Signal'),
                      const SizedBox(width: 48),
                      _FooterStat(value: '1.2M', label: 'Navigators'),
                    ],
                  ),
                  Row(
                    children: [
                      _FooterLink(
                        label: 'Documentation',
                        onTap: () {
                          // TODO: Open documentation URL
                        },
                      ),
                      const SizedBox(width: 24),
                      _FooterLink(
                        label: 'System Status',
                        onTap: () {
                          // TODO: Open system status URL
                        },
                      ),
                      const SizedBox(width: 24),
                      _FooterLink(
                        label: 'Changelog',
                        onTap: () {
                          // TODO: Open changelog URL
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KbdBadge extends StatelessWidget {
  final String label;
  const _KbdBadge({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: AppTypography.monospace.copyWith(fontSize: 10)),
    );
  }
}

class _PopularLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _PopularLink({required this.label, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.secondary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _FaqSection extends StatelessWidget {
  final int? expandedFaq;
  final ValueChanged<int?> onExpanded;
  const _FaqSection({this.expandedFaq, required this.onExpanded});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'q': 'How do I earn XP?',
        'a':
            'Complete tasks, study sessions, and unlock achievements to earn XP. Each completed item gives you experience points based on difficulty.',
      },
      {
        'q': 'How do I set up custom domains?',
        'a':
            'Navigate to Settings > Custom Domains. From there, you can add your domain and configure DNS records. Full documentation is available in the advanced technical logs.',
      },
      {
        'q': 'What is the Pomodoro timer?',
        'a':
            'The Pomodoro timer helps you focus with 25-minute work sessions followed by 5-minute breaks. It tracks your focus periods and total flow time.',
      },
      {
        'q': 'Can I export my flight data?',
        'a':
            'Yes! Go to Settings > Data & Sync to export your data as JSON. You can also import data from a previous backup.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.forum, color: AppColors.tertiary),
            const SizedBox(width: 12),
            Text(
              'Frequent Transmissions (FAQ)',
              style: AppTypography.sectionTitle,
            ),
          ],
        ),
        const SizedBox(height: 24),
        ...faqs.asMap().entries.map((entry) {
          final i = entry.key;
          final faq = entry.value;
          final isExpanded = expandedFaq == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassContainer(
              borderRadius: 16,
              padding: const EdgeInsets.all(24),
              glowColor: isExpanded ? AppColors.primary : null,
              borderColor: isExpanded
                  ? AppColors.primary.withAlpha(128)
                  : Colors.white.withAlpha(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          faq['q'] as String,
                          style: AppTypography.cardTitle.copyWith(
                            color: isExpanded
                                ? AppColors.primary
                                : AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more,
                          color: isExpanded
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 16),
                    Text(
                      faq['a'] as String,
                      style: AppTypography.body.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(delay: (i * 100).ms),
          );
        }),
      ],
    );
  }
}

class _RightPanel extends StatelessWidget {
  const _RightPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _QuickLinkCard(
              icon: Icons.play_circle,
              title: 'Tutorials',
              subtitle: 'Visual guides to the galaxy.',
              color: AppColors.secondary,
            ),
            _QuickLinkCard(
              icon: Icons.contact_support,
              title: 'Contact Support',
              subtitle: 'Connect with a navigator.',
              color: AppColors.primary,
            ),
            _QuickLinkCard(
              icon: Icons.reviews,
              title: 'Rate Us',
              subtitle: 'Share your signal strength.',
              color: AppColors.tertiary,
            ),
            _QuickLinkCard(
              icon: Icons.policy,
              title: 'Terms of Service',
              subtitle: 'Laws of the celestial body.',
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          height: 256,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withAlpha(51),
                AppColors.surfaceContainerLowest,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'New Log',
                        style: AppTypography.typeBadge.copyWith(
                          color: AppColors.onSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mastering Orbit Controls: The 2024 Productivity Guide',
                      style: AppTypography.cardTitle,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        // TODO: Open external documentation
                      },
                      child: Row(
                        children: [
                          Text(
                            'Read Protocol',
                            style: AppTypography.label.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickLinkCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _QuickLinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  State<_QuickLinkCard> createState() => _QuickLinkCardState();
}

class _QuickLinkCardState extends State<_QuickLinkCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isHovered
                ? [widget.color.withAlpha(26), widget.color.withAlpha(13)]
                : [Colors.white.withAlpha(13), Colors.white.withAlpha(5)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? widget.color.withAlpha(77)
                : Colors.white.withAlpha(26),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.color.withAlpha(51),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ]
              : null,
        ),
        transform: Matrix4.diagonal3Values(
          _isHovered ? 1.02 : 1.0,
          _isHovered ? 1.02 : 1.0,
          1.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.color.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: widget.color, size: 24),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: AppTypography.cardTitle.copyWith(
                    color: _isHovered ? widget.color : AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(widget.subtitle, style: AppTypography.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterStat extends StatelessWidget {
  final String value;
  final String label;
  const _FooterStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.statValueSmall.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: AppTypography.typeBadge.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _FooterLink({required this.label, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: AppTypography.body.copyWith(color: AppColors.onSurfaceVariant),
      ),
    );
  }
}
