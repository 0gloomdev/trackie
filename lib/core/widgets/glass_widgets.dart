import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// ============================================
/// GLASSAPPBAR - Custom App Bar Widget
/// ============================================

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
    this.elevation = 0,
    this.backgroundColor,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      title: Text(title, style: titleTextStyle),
      leading: leading,
      actions: actions,
      backgroundColor:
          backgroundColor ??
          (isDark ? Colors.grey[900]! : Colors.white).withValues(alpha: 0.7),
      elevation: elevation,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

/// ============================================
/// GLASSCARD - With States (Normal, Selected, Hover)
/// ============================================

enum GlassCardState { normal, selected, hover }

class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double blur;
  final double radius;
  final VoidCallback? onTap;
  final bool elevated;
  final Color? backgroundColor;
  final GlassCardState state;
  final bool enableHover;
  final Widget? trailing;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.blur = 20.0,
    this.radius = 16.0,
    this.onTap,
    this.elevated = false,
    this.backgroundColor,
    this.state = GlassCardState.normal,
    this.enableHover = true,
    this.trailing,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 20.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = widget.state == GlassCardState.selected;
    final showHover = widget.enableHover && widget.onTap != null && _isHovered;

    Color bgColor;
    Color borderColor;
    double borderWidth = 1;

    Color defaultBorderColor = isDark
        ? AppColors.glassBorderDark
        : AppColors.glassBorderLight;

    if (widget.backgroundColor != null) {
      bgColor = widget.backgroundColor!;
      borderColor = defaultBorderColor;
    } else if (isSelected) {
      bgColor = isDark
          ? AppColors.darkSurfaceContainerHighest.withValues(alpha: 0.6)
          : AppColors.lightSurfaceContainerHighest.withValues(alpha: 0.8);
      borderColor = AppColors.darkSecondary.withValues(alpha: 0.4);
      borderWidth = 2;
    } else if (showHover) {
      bgColor = isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.white.withValues(alpha: 0.1);
      borderColor = isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.black.withValues(alpha: 0.05);
    } else if (widget.elevated) {
      bgColor = isDark
          ? AppColors.darkSurfaceContainer.withValues(alpha: 0.6)
          : AppColors.lightSurfaceContainer.withValues(alpha: 0.6);
      borderColor = defaultBorderColor;
    } else {
      bgColor = isDark ? AppColors.glassDark : AppColors.glassLight;
      borderColor = defaultBorderColor;
    }

    Widget content = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, showHover ? -2 : 0),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                boxShadow: showHover
                    ? [
                        BoxShadow(
                          color: AppColors.darkPrimary.withValues(alpha: 0.1),
                          blurRadius: _shadowAnimation.value,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: child,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: widget.trailing != null
                ? Row(
                    children: [
                      Expanded(child: widget.child),
                      widget.trailing!,
                    ],
                  )
                : widget.child,
          ),
        ),
      ),
    );

    if (widget.onTap != null) {
      return MouseRegion(
        onEnter: (_) {
          if (widget.enableHover) {
            setState(() => _isHovered = true);
            _controller.forward();
          }
        },
        onExit: (_) {
          if (widget.enableHover) {
            setState(() => _isHovered = false);
            _controller.reverse();
          }
        },
        child: GestureDetector(onTap: widget.onTap, child: content),
      );
    }
    return content;
  }
}

/// Glass Button with gradient option
class GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isGradient;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool isLoading;

  const GlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isGradient = false,
    this.icon,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget content = Container(
      width: width,
      height: height ?? 48,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: isGradient
            ? (isDark ? AppColors.liquidGradient : null)
            : null,
        color: isGradient
            ? null
            : isPrimary
            ? cs.primary
            : isDark
            ? AppColors.darkSurfaceContainer.withValues(alpha: 0.4)
            : AppColors.lightSurfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: isGradient || isPrimary
            ? null
            : Border.all(
                color: isDark
                    ? AppColors.darkOutlineVariant.withValues(alpha: 0.3)
                    : AppColors.lightOutlineVariant,
                width: 1,
              ),
        boxShadow: isGradient
            ? [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isPrimary || isGradient
                          ? cs.onPrimary
                          : cs.onSurface,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 18,
                          color: isPrimary || isGradient
                              ? cs.onPrimary
                              : cs.onSurface,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isPrimary || isGradient
                              ? cs.onPrimary
                              : cs.onSurface,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );

    return content;
  }
}

/// Glass Chip for filters
class GlassChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;
  final IconData? icon;
  final Widget? leading;
  final bool showClose;

  const GlassChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
    this.icon,
    this.leading,
    this.showClose = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = activeColor ?? cs.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: icon != null || leading != null || showClose ? 12 : 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : isDark
              ? AppColors.darkSurfaceContainer.withValues(alpha: 0.3)
              : AppColors.lightSurfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.5)
                : isDark
                ? AppColors.darkOutlineVariant.withValues(alpha: 0.2)
                : AppColors.lightOutlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? color : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : cs.onSurfaceVariant,
              ),
            ),
            if (showClose) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onTap,
                child: Icon(Icons.close, size: 14, color: cs.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Glass Text Field with blur
class GlassTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final FocusNode? focusNode;
  final int? maxLines;
  final TextInputType? keyboardType;

  const GlassTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.focusNode,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          autofocus: autofocus,
          focusNode: focusNode,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(color: cs.onSurface, fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: cs.onSurfaceVariant, size: 20)
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isDark
                ? AppColors.darkSurfaceContainer.withValues(alpha: 0.3)
                : AppColors.lightSurfaceContainerHighest.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.darkOutlineVariant.withValues(alpha: 0.3)
                    : AppColors.lightOutlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.darkOutlineVariant.withValues(alpha: 0.3)
                    : AppColors.lightOutlineVariant,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}

/// Glass Progress Bar with animation
class GlassProgressBar extends StatelessWidget {
  final double value;
  final Color? color;
  final double height;
  final bool showLabel;
  final bool animated;

  const GlassProgressBar({
    super.key,
    required this.value,
    this.color,
    this.height = 6,
    this.showLabel = false,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: animated
              ? TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, animatedValue, child) {
                    return LinearProgressIndicator(
                      value: animatedValue,
                      minHeight: height,
                      backgroundColor: cs.surfaceContainerHighest,
                      color: color ?? cs.primary,
                    );
                  },
                )
              : LinearProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  minHeight: height,
                  backgroundColor: cs.surfaceContainerHighest,
                  color: color ?? cs.primary,
                ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            '${(value * 100).round()}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color ?? cs.primary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Glass Bottom Sheet
class GlassBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final double? height;
  final Widget? actions;

  const GlassBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.height,
    this.actions,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    double? height,
    bool isScrollControlled = true,
    Widget? actions,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassBottomSheet(
        title: title,
        height: height,
        actions: actions,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceContainer.withValues(alpha: 0.9)
                : AppColors.lightSurface.withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: isDark
                  ? AppColors.darkOutlineVariant.withValues(alpha: 0.2)
                  : AppColors.lightOutlineVariant,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (title != null) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        title!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const Spacer(),
                      ?actions,
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ] else
                const SizedBox(height: 12),
              Flexible(child: child),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

/// Glass Scaffold - Main container with optional top bar
class GlassScaffold extends StatelessWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool showBackButton;
  final VoidCallback? onBack;

  const GlassScaffold({
    super.key,
    this.title,
    this.leading,
    this.actions,
    required this.body,
    this.floatingActionButton,
    this.backgroundColor,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          backgroundColor ??
          (isDark ? AppColors.darkBackground : AppColors.lightBackground),
      appBar: title != null
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: showBackButton
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: onBack ?? () => Navigator.pop(context),
                    )
                  : leading,
              title: title is String
                  ? Text(
                      title as String,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    )
                  : title,
              actions: actions,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Animated Glass Card with hover effect
class AnimatedGlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double blur;
  final double radius;
  final VoidCallback? onTap;
  final bool elevated;

  const AnimatedGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.blur = 20.0,
    this.radius = 16.0,
    this.onTap,
    this.elevated = false,
  });

  @override
  State<AnimatedGlassCard> createState() => _AnimatedGlassCardState();
}

class _AnimatedGlassCardState extends State<AnimatedGlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        // ignore: deprecated_member_use
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..translate(0.0, _isHovered ? -4.0 : 0.0, 0.0),
        child: GlassCard(
          padding: widget.padding,
          width: widget.width,
          height: widget.height,
          blur: widget.blur,
          radius: widget.radius,
          onTap: widget.onTap,
          elevated: widget.elevated || _isHovered,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Loading shimmer effect for cards
class ShimmerGlassCard extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerGlassCard({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.radius = 16.0,
  });

  @override
  State<ShimmerGlassCard> createState() => _ShimmerGlassCardState();
}

class _ShimmerGlassCardState extends State<ShimmerGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: isDark
                  ? [Colors.grey[900]!, Colors.grey[800]!, Colors.grey[900]!]
                  : [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
            ),
          ),
        );
      },
    );
  }
}

/// Empty state with icon and message
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primaryContainer.withValues(alpha: 0.3),
              ),
              child: Icon(icon, size: 48, color: cs.primary),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Animated counter for stats
class AnimatedCounter extends StatelessWidget {
  final int value;
  final String? suffix;
  final TextStyle? style;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.suffix,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(suffix != null ? '$value$suffix' : '$value', style: style);
      },
    );
  }
}

// ============================================
// STATUS CHIPS - For content types
// ============================================

class StatusChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const StatusChip({
    super.key,
    required this.label,
    this.icon,
    required this.color,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.3)
              : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: isSelected ? 0.5 : 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
            ],
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// LIVE INDICATOR - Animated status dot
// ============================================

class LiveIndicator extends StatefulWidget {
  final String? label;
  final bool isLive;
  final Color? color;

  const LiveIndicator({super.key, this.label, this.isLive = true, this.color});

  @override
  State<LiveIndicator> createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<LiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicatorColor = widget.color ?? AppColors.darkSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isLive
                    ? indicatorColor.withValues(
                        alpha: 0.5 + (_controller.value * 0.5),
                      )
                    : indicatorColor.withValues(alpha: 0.3),
                boxShadow: widget.isLive
                    ? [
                        BoxShadow(
                          color: indicatorColor.withValues(alpha: 0.5),
                          blurRadius: 4 + (_controller.value * 4),
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            );
          },
        ),
        if (widget.label != null) ...[
          const SizedBox(width: 8),
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: indicatorColor,
            ),
          ),
        ],
      ],
    );
  }
}

// ============================================
// NEON BUTTON - Primary gradient button
// ============================================

class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isLoading;
  final double? width;

  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isLoading = false,
    this.width,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        // ignore: deprecated_member_use
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..scale(_isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0, 1.0),
        child: GestureDetector(
          onTap: widget.isLoading ? null : widget.onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              gradient: widget.isPrimary
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.darkPrimary,
                        AppColors.darkPrimaryContainer,
                      ],
                    )
                  : null,
              color: widget.isPrimary
                  ? null
                  : isDark
                  ? AppColors.darkSurfaceContainerHighest
                  : AppColors.lightSurfaceContainerHighest,
              borderRadius: BorderRadius.circular(28),
              boxShadow: widget.isPrimary
                  ? [
                      BoxShadow(
                        color: AppColors.darkPrimary.withValues(
                          alpha: _isHovered ? 0.5 : 0.3,
                        ),
                        blurRadius: _isHovered ? 30 : 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: 18,
                          color: widget.isPrimary
                              ? AppColors.darkOnPrimaryContainer
                              : AppColors.darkPrimary,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.isPrimary
                              ? AppColors.darkOnPrimaryContainer
                              : isDark
                              ? AppColors.darkOnSurface
                              : AppColors.lightOnSurface,
                        ),
                      ),
                      if (widget.icon == null && widget.isPrimary) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: AppColors.darkOnPrimaryContainer,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ============================================
// TEXTURE OVERLAY - Noise pattern
// ============================================

class TextureOverlay extends StatelessWidget {
  final double opacity;

  const TextureOverlay({super.key, this.opacity = 0.03});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: CustomPaint(
          painter: _NoisePainter(opacity: opacity),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  final double opacity;

  _NoisePainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    // Simple noise effect using random dots
    final paint = Paint()..color = Colors.white.withValues(alpha: opacity);
    final random = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < 500; i++) {
      final x = ((random * (i + 1) * 17) % size.width.toInt()).toDouble();
      final y = ((random * (i + 1) * 23) % size.height.toInt()).toDouble();
      canvas.drawCircle(Offset(x, y), 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================
// BENTO GRID ITEM - For analytics layouts
// ============================================

class BentoGridItem extends StatelessWidget {
  final int flex;
  final Widget child;
  final int? span;

  const BentoGridItem({
    super.key,
    this.flex = 1,
    required this.child,
    this.span,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurfaceContainerLow.withValues(alpha: 0.4)
            : AppColors.lightSurfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkOutlineVariant.withValues(alpha: 0.15)
              : AppColors.lightOutlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: child,
    );
  }
}

/// ============================================
/// SHIMMER LOADING WIDGET
/// ============================================

class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? AppColors.darkSurfaceContainerHighest
        : AppColors.lightSurfaceContainerHighest;
    final highlightColor = isDark
        ? AppColors.darkSurfaceContainerHighest.withValues(alpha: 0.5)
        : AppColors.lightSurfaceContainerHighest.withValues(alpha: 0.8);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [baseColor, highlightColor, baseColor],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double height;

  const ShimmerCard({super.key, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoading(width: 200, height: 20),
            const SizedBox(height: 12),
            ShimmerLoading(height: 14),
            const SizedBox(height: 8),
            ShimmerLoading(width: 150, height: 14),
          ],
        ),
      ),
    );
  }
}
