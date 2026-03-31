import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class ShadcnCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool hoverEffect;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? glowColor;

  const ShadcnCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.hoverEffect = false,
    this.onTap,
    this.borderRadius = 16,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  (isDark ? AppColors.shadcnCard : Colors.white),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color:
                    borderColor ??
                    (isDark ? const Color(0xFF1F2B49) : Colors.grey.shade200),
                width: 1.5,
              ),
              boxShadow: glowColor != null
                  ? [
                      BoxShadow(
                        color: glowColor!.withAlpha(51),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        )
        .animate(target: hoverEffect ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.02, 1.02),
          duration: 200.ms,
        );
  }
}

class ShadcnButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isDestructive;
  final Color? glowColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const ShadcnButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isDestructive = false,
    this.glowColor,
    this.borderRadius = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ??
        (isDestructive ? AppColors.shadcnDestructive : AppColors.shadcnPrimary);
    final fgColor =
        foregroundColor ??
        (isDestructive
            ? AppColors.shadcnDestructiveForeground
            : AppColors.shadcnPrimaryForeground);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: glowColor != null
              ? [
                  BoxShadow(
                    color: glowColor!.withAlpha(77),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: fgColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          child: child,
        ),
      ),
    );
  }
}

class ShadcnInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final int? maxLines;

  const ShadcnInput({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.autofocus = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autofocus,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0x80FFFFFF)),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class ShadcnChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  final IconData? icon;

  const ShadcnChip({
    super.key,
    required this.label,
    this.isActive = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.shadcnPrimary.withAlpha(51)
              : const Color(0x0DFFFFFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.shadcnPrimary.withAlpha(128)
                : const Color(0x1AFFFFFF),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isActive ? AppColors.shadcnSecondary : Color(0xB3FFFFFF),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.shadcnSecondary : Color(0xB3FFFFFF),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShadcnProgress extends StatelessWidget {
  final double value;
  final Color? color;
  final double height;
  final bool showLabel;

  const ShadcnProgress({
    super.key,
    required this.value,
    this.color,
    this.height = 8,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                color: Color(0xB3FFFFFF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0x1AFFFFFF),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color ?? AppColors.shadcnPrimary,
                    (color ?? AppColors.shadcnSecondary).withAlpha(204),
                  ],
                ),
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: [
                  BoxShadow(
                    color: (color ?? AppColors.shadcnPrimary).withAlpha(102),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ShadcnAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? fallback;
  final double size;
  final Color? borderColor;

  const ShadcnAvatar({
    super.key,
    this.imageUrl,
    this.fallback,
    this.size = 40,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? AppColors.shadcnPrimary.withAlpha(128),
          width: 2,
        ),
        color: const Color(0x1AFFFFFF),
      ),
      child: ClipOval(
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildFallback(),
              )
            : _buildFallback(),
      ),
    );
  }

  Widget _buildFallback() {
    return Center(
      child: Text(
        fallback?.substring(0, 1).toUpperCase() ?? '?',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ShadcnBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const ShadcnBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.shadcnPrimary.withAlpha(51),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (backgroundColor ?? AppColors.shadcnPrimary).withAlpha(77),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? AppColors.shadcnSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ShadcnToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  const ShadcnToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: 200.ms,
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value
              ? (activeColor ?? AppColors.shadcnPrimary)
              : const Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value
                ? (activeColor ?? AppColors.shadcnPrimary)
                : const Color(0x33FFFFFF),
          ),
        ),
        child: AnimatedAlign(
          duration: 200.ms,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShadcnSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const ShadcnSkeleton({
    super.key,
    this.width,
    this.height = 20,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0x1AFFFFFF),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1500.ms, color: const Color(0x4DFFFFFF));
  }
}
