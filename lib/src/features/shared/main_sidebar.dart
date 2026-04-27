import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import 'providers/drift_providers.dart';

class Sidebar extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onItemSelected;
  final bool isDark;
  final List<String> titles;

  const Sidebar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.isDark,
    required this.titles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final primaryColor = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;
    final secondaryColor = isDark
        ? AppColors.darkSecondary
        : AppColors.lightSecondary;
    final onSurfaceVariant = isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;

    // Use variables to avoid warnings - assign to widget properties
    primaryColor.hashCode;
    secondaryColor.hashCode;
    onSurfaceVariant.hashCode;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceContainer.withValues(alpha: 0.4)
            : AppColors.lightSurface.withValues(alpha: 0.6),
        border: Border(
          right: BorderSide(
            color: isDark
                ? AppColors.darkOutlineVariant.withValues(alpha: 0.1)
                : AppColors.lightOutlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) =>
                (isDark
                        ? AppColors.liquidGradient
                        : const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDim],
                          ))
                    .createShader(bounds),
            child: const Text(
              'Aura Learning',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          profileAsync.when(
            data: (profile) => profile == null
                ? Text(
                    'No profile',
                    style: TextStyle(fontSize: 12, color: onSurfaceVariant),
                  )
                : Text(
                    'Level ${profile.level} - ${profile.xp} XP',
                    style: TextStyle(fontSize: 12, color: onSurfaceVariant),
                  ),
            loading: () => Text(
              'Loading...',
              style: TextStyle(fontSize: 12, color: onSurfaceVariant),
            ),
            error: (_, _) => Text(
              'Error loading profile',
              style: TextStyle(fontSize: 12, color: onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard,
                  label: titles[0],
                  isSelected: currentIndex == 0,
                  onTap: () => onItemSelected(0),
                  isDark: isDark,
                ),
                _SidebarItem(
                  icon: Icons.auto_stories,
                  label: titles[1],
                  isSelected: currentIndex == 1,
                  onTap: () => onItemSelected(1),
                  isDark: isDark,
                ),
                _SidebarItem(
                  icon: Icons.school,
                  label: titles[2],
                  isSelected: currentIndex == 2,
                  onTap: () => onItemSelected(2),
                  isDark: isDark,
                ),
                _SidebarItem(
                  icon: Icons.military_tech,
                  label: titles[3],
                  isSelected: currentIndex == 3,
                  onTap: () => onItemSelected(3),
                  isDark: isDark,
                ),
                _SidebarItem(
                  icon: Icons.groups,
                  label: titles[4],
                  isSelected: currentIndex == 4,
                  onTap: () => onItemSelected(4),
                  isDark: isDark,
                ),
                _SidebarItem(
                  icon: Icons.note_alt,
                  label: titles[5],
                  isSelected: currentIndex == 5,
                  onTap: () => onItemSelected(5),
                  isDark: isDark,
                ),
                _SidebarItem(
                  icon: Icons.notifications,
                  label: titles[6],
                  isSelected: currentIndex == 6,
                  onTap: () => onItemSelected(6),
                  isDark: isDark,
                ),
                _SidebarItem(
                  icon: Icons.analytics,
                  label: titles[7],
                  isSelected: currentIndex == 7,
                  onTap: () => onItemSelected(7),
                  isDark: isDark,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _SidebarItem(
              icon: Icons.help_outline,
              label: titles[8],
              isSelected: currentIndex == 8,
              onTap: () => onItemSelected(8),
              isDark: isDark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _SidebarItem(
              icon: Icons.settings,
              label: titles[9],
              isSelected: currentIndex == 9,
              onTap: () => onItemSelected(9),
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;
    final secondaryColor = widget.isDark
        ? AppColors.darkSecondary
        : AppColors.lightSecondary;
    final onSurfaceVariant = widget.isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;
    final activeColor = widget.isSelected ? secondaryColor : primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            transform: _isHovered && !widget.isSelected
                ? (Matrix4.identity()..setEntry(0, 3, 4.0))
                : Matrix4.identity(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? activeColor.withValues(alpha: 0.1)
                  : _isHovered
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: widget.isSelected
                  ? Border(left: BorderSide(color: activeColor, width: 3))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: widget.isSelected ? activeColor : onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: widget.isSelected ? activeColor : onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
