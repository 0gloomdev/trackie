import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';

class EnhancedFAB extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final bool isDark;

  const EnhancedFAB({required this.onPressed, required this.isDark});

  @override
  ConsumerState<EnhancedFAB> createState() => EnhancedFABState();
}

class EnhancedFABState extends ConsumerState<EnhancedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isPressed ? 0.92 : 1.0,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonPurpleStrong.withValues(
                      alpha: 0.5 * _glowAnimation.value,
                    ),
                    blurRadius: 25 * _glowAnimation.value,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.neonCyan.withValues(
                      alpha: 0.3 * _glowAnimation.value,
                    ),
                    blurRadius: 35 * _glowAnimation.value,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          );
        },
      ),
    );
  }
}

class DesktopFAB extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final bool isDark;

  const DesktopFAB({required this.onPressed, required this.isDark});

  @override
  ConsumerState<DesktopFAB> createState() => DesktopFABState();
}

class DesktopFABState extends ConsumerState<DesktopFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isHovered ? 1.05 : 1.0,
            child: FloatingActionButton(
              heroTag: 'main_fab_hero',
              onPressed: widget.onPressed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                      widget.isDark
                          ? AppColors.darkSecondary
                          : AppColors.lightSecondary,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonPurple.withValues(
                        alpha: 0.4 * _glowAnimation.value,
                      ),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: _isHovered ? 2 : 0,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppColors.neonCyan.withValues(
                        alpha: 0.2 * _glowAnimation.value,
                      ),
                      blurRadius: 30 * _glowAnimation.value,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: widget.isDark
                      ? AppColors.darkOnPrimary
                      : AppColors.lightOnPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
