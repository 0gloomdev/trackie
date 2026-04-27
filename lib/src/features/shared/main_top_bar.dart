import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';

class TopBar extends ConsumerWidget {
  final String title;
  final bool isDark;
  final String locale;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCreateTap;
  final VoidCallback? onPomodoroTap;

  const TopBar({super.key, 
    required this.title,
    required this.isDark,
    required this.locale,
    this.onSearchTap,
    this.onCreateTap,
    this.onPomodoroTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onSurface = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    final onSurfaceVariant = isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;

    // Use variables to avoid warnings
    onSurface.hashCode;
    onSurfaceVariant.hashCode;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceContainer.withValues(alpha: 0.3)
            : AppColors.lightSurface.withValues(alpha: 0.4),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.darkOutlineVariant.withValues(alpha: 0.1)
                : AppColors.lightOutlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: onSurface,
            ),
          ),
          const Spacer(),
          _GlassIconButton(
            icon: Icons.search,
            onTap: onSearchTap,
            tooltip: 'Search (Ctrl+K)',
            isDark: isDark,
          ),
          _GlassIconButton(
            icon: Icons.timer_outlined,
            onTap: onPomodoroTap,
            tooltip: 'Pomodoro (Ctrl+P)',
            isDark: isDark,
          ),
          _GlassIconButton(
            icon: Icons.add_box_outlined,
            onTap: onCreateTap,
            tooltip: 'Create (Ctrl+N)',
            isDark: isDark,
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDark ? AppColors.brandGradient : null,
              color: isDark ? null : AppColors.lightPrimaryContainer,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'U',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool isDark;

  const _GlassIconButton({
    required this.icon,
    this.onTap,
    this.tooltip,
    required this.isDark,
  });

  @override
  State<_GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<_GlassIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final onSurfaceVariant = widget.isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.secondary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered
                  ? AppColors.secondary.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: _isHovered ? AppColors.secondary : onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
