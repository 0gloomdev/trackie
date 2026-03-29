import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../utils/translations.dart';
import '../../domain/providers/providers.dart';

class ShadcnLayout extends ConsumerWidget {
  final int currentIndex;
  final List<Widget> screens;
  final Function(int) onNavigate;
  final Widget? floatingActionButton;
  final bool isDesktop;
  final String title;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCreateTap;

  const ShadcnLayout({
    super.key,
    required this.currentIndex,
    required this.screens,
    required this.onNavigate,
    this.floatingActionButton,
    required this.isDesktop,
    this.title = 'Trackie',
    this.onSearchTap,
    this.onCreateTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isDesktop) {
      return _buildDesktopLayout(context, ref);
    }
    return _buildMobileLayout(context, ref);
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      body: Row(
        children: [
          // Sidebar
          _ShadcnSidebar(
            currentIndex: currentIndex,
            onNavigate: onNavigate,
            isExpanded: true,
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                _ShadcnTopBar(
                  title: title,
                  onSearchTap: onSearchTap,
                  onCreateTap: onCreateTap,
                ),
                Expanded(
                  child: IndexedStack(index: currentIndex, children: screens),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      body: Stack(
        children: [
          // Background Glows
          _AmbientGlows(),
          // Main Content
          Column(
            children: [
              _ShadcnTopBar(
                title: title,
                onSearchTap: onSearchTap,
                compact: true,
              ),
              Expanded(
                child: IndexedStack(
                  index: currentIndex < 4 ? currentIndex : 0,
                  children: screens.take(4).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _ShadcnBottomNav(
        currentIndex: currentIndex < 4 ? currentIndex : 0,
        onNavigate: (i) {
          if (i < 4) onNavigate(i);
        },
        onCreateTap: onCreateTap,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

class _AmbientGlows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Purple glow - top left
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.shadcnGlowPurple.withAlpha(26),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Cyan glow - bottom right
            Positioned(
              bottom: -100,
              right: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.shadcnGlowCyan.withAlpha(26),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShadcnSidebar extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onNavigate;
  final bool isExpanded;

  const _ShadcnSidebar({
    required this.currentIndex,
    required this.onNavigate,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final t = Translations(settings.locale);
    final items = [
      {'icon': Icons.dashboard_rounded, 'label': t.dashboard, 'path': 0},
      {'icon': Icons.auto_stories_rounded, 'label': t.library, 'path': 1},
      {'icon': Icons.school_rounded, 'label': t.courses, 'path': 2},
      {'icon': Icons.emoji_events_rounded, 'label': t.achievements, 'path': 3},
      {'icon': Icons.people_rounded, 'label': t.community, 'path': 4},
    ];

    return Container(
      width: isExpanded ? 260 : 88,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white.withAlpha(13), Colors.transparent],
        ),
        border: Border(
          right: BorderSide(color: Colors.white.withAlpha(26), width: 1.5),
        ),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.shadcnPrimary,
                        AppColors.shadcnSecondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadcnPrimary.withAlpha(102),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.layers,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 12),
                  const Text(
                    'TRACKIE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(color: Color(0x1AFFFFFF), height: 1),
          // Nav Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isActive = currentIndex == item['path'];

                return _NavItem(
                  icon: item['icon'] as IconData,
                  label: item['label'] as String,
                  isActive: isActive,
                  isExpanded: isExpanded,
                  onTap: () => onNavigate(item['path'] as int),
                );
              },
            ),
          ),
          // Pro Card
          if (isExpanded)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.shadcnPrimary.withAlpha(51),
                    AppColors.shadcnSecondary.withAlpha(26),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.shadcnPrimary.withAlpha(77),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Plan Pro',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sincronización en la nube ilimitada.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(153),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.shadcnPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Actualizar',
                        style: TextStyle(fontWeight: FontWeight.bold),
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

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isExpanded;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: 200.ms,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isExpanded ? 16 : 12,
            vertical: 14,
          ),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: widget.isActive
                ? Colors.white.withAlpha(26)
                : (_isHovered
                      ? Colors.white.withAlpha(13)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: AppColors.shadcnSecondary.withAlpha(26),
                      blurRadius: 20,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              if (widget.isActive)
                Container(
                  width: 4,
                  height: 24,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.shadcnSecondary,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadcnSecondary.withAlpha(128),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              Icon(
                widget.icon,
                color: widget.isActive
                    ? AppColors.shadcnSecondary
                    : (Colors.white.withAlpha(179)),
                size: 24,
              ),
              if (widget.isExpanded) ...[
                const SizedBox(width: 12),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.isActive
                        ? Colors.white
                        : (Colors.white.withAlpha(179)),
                    fontWeight: widget.isActive
                        ? FontWeight.bold
                        : FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ShadcnTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCreateTap;
  final bool compact;

  const _ShadcnTopBar({
    required this.title,
    this.onSearchTap,
    this.onCreateTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: AppColors.shadcnBackground.withAlpha(204),
        border: Border(bottom: BorderSide(color: Colors.white.withAlpha(26))),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          if (!compact) ...[
            // Search Bar
            GestureDetector(
              onTap: onSearchTap,
              child: Container(
                width: 280,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(13),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withAlpha(26)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white.withAlpha(128),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Buscar en el universo...',
                      style: TextStyle(
                        color: Colors.white.withAlpha(128),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.shadcnPrimary.withAlpha(128),
                width: 2,
              ),
              color: Colors.white.withAlpha(26),
            ),
            child: const Icon(Icons.person, color: Colors.white70, size: 24),
          ),
        ],
      ),
    );
  }
}

class _ShadcnBottomNav extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onNavigate;
  final VoidCallback? onCreateTap;

  const _ShadcnBottomNav({
    required this.currentIndex,
    required this.onNavigate,
    this.onCreateTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final t = Translations(settings.locale);
    final items = [
      {'icon': Icons.dashboard_rounded, 'label': t.dashboard},
      {'icon': Icons.auto_stories_rounded, 'label': t.library},
      {'icon': Icons.school_rounded, 'label': t.courses},
      {'icon': Icons.settings_rounded, 'label': t.settings},
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.shadcnBackground.withAlpha(230),
            AppColors.shadcnBackground,
          ],
        ),
        border: Border(top: BorderSide(color: Colors.white.withAlpha(26))),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = currentIndex == index;

              return GestureDetector(
                onTap: () => onNavigate(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: isActive
                            ? AppColors.shadcnSecondary
                            : Colors.white.withAlpha(128),
                        size: isActive ? 28 : 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: isActive
                              ? AppColors.shadcnSecondary
                              : Colors.white.withAlpha(128),
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          // FAB
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onCreateTap,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.shadcnPrimary,
                        AppColors.shadcnSecondary,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadcnPrimary.withAlpha(128),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
