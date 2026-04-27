import 'dart:ui';
import 'package:flutter/material.dart';

// ============================================
// DESIGN TOKENS - Aligned with DESIGN.md
// Cosmic Nebula Theme
// ============================================

class DesignTokens {
  // Spacing (8px base unit)
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double spaceXxl = 48;
  static const double spaceXxxl = 64;

  // Border Radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 20;
  static const double radiusXl = 32;
  static const double radiusFull = 999;

  // Animation Durations
  static const Duration fadeIn = Duration(milliseconds: 400);
  static const Duration slideUp = Duration(milliseconds: 300);
  static const Duration scale = Duration(milliseconds: 200);
  static const Duration glowPulse = Duration(milliseconds: 1500);
  static const Duration tabSwitch = Duration(milliseconds: 300);
  static const Duration slideIn = Duration(milliseconds: 600);
  static const Duration stagger = Duration(milliseconds: 100);
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);

  // Glass Effect
  static const double glassBlur = 25.0;
  static const double glassOpacity = 0.7;
  static const Color glassBorder = Color(0x1AFFFFFF);
  static const Color glassBackground = Color(0xB3171F32);
}

// ============================================
// DESIGN SYSTEM COMPONENTS
// ============================================

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final Color? glowColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = DesignTokens.radiusLg,
    this.padding = const EdgeInsets.all(20),
    this.blur = DesignTokens.glassBlur,
    this.opacity = 0.15,
    this.borderColor,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: glowColor != null
            ? [
                BoxShadow(
                  color: glowColor!.withAlpha(77),
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((opacity * 255).round()),
              borderRadius: BorderRadius.circular(borderRadius),
              border: borderColor != null
                  ? Border.all(color: borderColor!, width: 1)
                  : Border.all(color: Colors.white.withAlpha(26), width: 1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class NeonCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double borderRadius;
  final EdgeInsets padding;

  const NeonCard({
    super.key,
    required this.child,
    this.glowColor = const Color(0xFF5ce6ff),
    this.borderRadius = DesignTokens.radiusLg,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [glowColor.withAlpha(26), glowColor.withAlpha(13)],
        ),
        border: Border.all(color: glowColor.withAlpha(77), width: 1),
        boxShadow: [
          BoxShadow(
            color: glowColor.withAlpha(51),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class GlassButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;
  final bool isLoading;
  final GlassButtonStyle style;
  final bool fullWidth;

  const GlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF5ce6ff),
    this.icon,
    this.isLoading = false,
    this.style = GlassButtonStyle.primary,
    this.fullWidth = false,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

enum GlassButtonStyle { primary, secondary, outline, ghost }

class _GlassButtonState extends State<GlassButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  Color get _backgroundColor {
    if (widget.style == GlassButtonStyle.primary) {
      if (_isPressed) return widget.color.withAlpha(102);
      if (_isHovered) return widget.color.withAlpha(77);
      return widget.color.withAlpha(51);
    }
    if (widget.style == GlassButtonStyle.secondary) {
      return _isPressed
          ? Colors.white.withAlpha(51)
          : (_isHovered
                ? Colors.white.withAlpha(38)
                : Colors.white.withAlpha(26));
    }
    if (widget.style == GlassButtonStyle.outline) {
      return _isPressed ? widget.color.withAlpha(26) : Colors.transparent;
    }
    return Colors.transparent;
  }

  Color get _borderColor {
    if (widget.style == GlassButtonStyle.outline ||
        widget.style == GlassButtonStyle.primary) {
      return _isHovered ? widget.color : widget.color.withAlpha(128);
    }
    return Colors.white.withAlpha(51);
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = widget.style == GlassButtonStyle.secondary
        ? Colors.white
        : widget.color;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: 1),
            boxShadow: _isHovered && widget.style != GlassButtonStyle.ghost
                ? [
                    BoxShadow(
                      color: widget.color.withAlpha(77),
                      blurRadius: 15,
                      spreadRadius: -5,
                    ),
                  ]
                : null,
          ),
          child: widget.isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(labelColor),
                  ),
                )
              : Row(
                  mainAxisSize: widget.fullWidth
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: labelColor, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: labelColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class NeonIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;
  final bool showGlow;
  final bool isCircle;

  const NeonIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = const Color(0xFF5ce6ff),
    this.size = 24,
    this.showGlow = true,
    this.isCircle = true,
  });

  @override
  State<NeonIconButton> createState() => _NeonIconButtonState();
}

class _NeonIconButtonState extends State<NeonIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(widget.isCircle ? 12 : 8),
        decoration: BoxDecoration(
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
          color: _isPressed ? widget.color.withAlpha(51) : Colors.transparent,
          borderRadius: widget.isCircle ? null : BorderRadius.circular(8),
          border: Border.all(
            color: _isPressed ? widget.color : Colors.white.withAlpha(51),
            width: 1,
          ),
          boxShadow: widget.showGlow && _isPressed
              ? [
                  BoxShadow(
                    color: widget.color.withAlpha(128),
                    blurRadius: 15,
                    spreadRadius: -5,
                  ),
                ]
              : null,
        ),
        child: Icon(widget.icon, color: widget.color, size: widget.size),
      ),
    );
  }
}

class GlassFloatingActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;

  const GlassFloatingActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = const Color(0xFF5ce6ff),
    this.size = 56,
  });

  @override
  State<GlassFloatingActionButton> createState() =>
      _GlassFloatingActionButtonState();
}

class _GlassFloatingActionButtonState extends State<GlassFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
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
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              if (_isPressed)
                widget.color.withAlpha(77)
              else
                widget.color.withAlpha(51),
              if (_isPressed)
                widget.color.withAlpha(102)
              else
                widget.color.withAlpha(26),
            ],
          ),
          border: Border.all(
            color: _isPressed ? widget.color : widget.color.withAlpha(77),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color.withAlpha(77),
              blurRadius: _isPressed ? 20 : 10,
              spreadRadius: _isPressed ? 2 : 0,
            ),
          ],
        ),
        child: Icon(widget.icon, color: widget.color, size: widget.size * 0.45),
      ),
    );
  }
}

class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2 * _controller.value, 0),
              end: Alignment(1.0 + 2 * _controller.value, 0),
              colors: [
                Colors.white.withAlpha(26),
                Colors.white.withAlpha(77),
                Colors.white.withAlpha(26),
              ],
            ),
          ),
        );
      },
    );
  }
}
