import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';

// ============================================
// LIQUID NEBULA DESIGN SYSTEM - FASE 1
// Glass Components & Neon Glows
// ============================================

// ============================================
// GLASS EFFECT HELPERS
// Simulated glassmorphism with gradient overlays
// ============================================

/// Liquid Nebula Glass Effect Colors
/// Used to simulate backdrop-filter blur effect
class LiquidGlass {
  // HTML spec glass colors
  static const Color glassBackground = Color(0xB3171F32); // rgba(23,31,50,0.7)
  static const Color glassHigh = Color(0x26FFFFFF);
  static const Color glassMedium = Color(0x1AFFFFFF);
  static const Color glassLow = Color(0x0DFFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF); // 10% top+left
  static const Color glassBorderLight = Color(0x1AFFFFFF);

  // HTML spec neon glows
  static const Color neonPurple = Color(0x4Dd3bfff);
  static const Color neonCyan = Color(0x4D5ce6ff);
  static const Color neonPurpleStrong = Color(0x80d3bfff);
  static const Color neonCyanStrong = Color(0x805ce6ff);

  static const Color insetPurple = Color(0x1Ad3bfff);
  static const Color insetCyan = Color(0x1A5ce6ff);

  static LinearGradient get glassGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassHigh, glassLow],
  );

  static LinearGradient get darkGlassGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.shadcnPrimary.withAlpha(13), Colors.transparent],
  );

  static List<BoxShadow> get purpleGlow => [
    const BoxShadow(
      color: neonPurple,
      blurRadius: 15,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get purpleGlowStrong => [
    BoxShadow(
      color: neonPurpleStrong,
      blurRadius: 20,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.shadcnPrimary.withAlpha(77),
      blurRadius: 30,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get cyanGlow => [
    const BoxShadow(
      color: neonCyan,
      blurRadius: 15,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get cyanGlowStrong => [
    BoxShadow(
      color: neonCyanStrong,
      blurRadius: 20,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.shadcnSecondary.withAlpha(77),
      blurRadius: 30,
      spreadRadius: 0,
    ),
  ];

  static LinearGradient get brandGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
  );
}

// ============================================
// SHADCN CARD - Glass Card Component
// ============================================

/// Glass card with liquid nebula effects
/// - Glass gradient background
/// - Subtle glass border
/// - Optional neon glow
/// - Hover lift effect
class ShadcnCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool hoverEffect;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? glowColor;
  final bool useGlassEffect;

  const ShadcnCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.hoverEffect = false,
    this.onTap,
    this.borderRadius = 12,
    this.glowColor,
    this.useGlassEffect = true,
  });

  @override
  State<ShadcnCard> createState() => _ShadcnCardState();
}

class _ShadcnCardState extends State<ShadcnCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(
            0.0,
            _isHovered && widget.hoverEffect ? -4.0 : 0.0,
            0.0,
          ),
          child: Stack(
            children: [
              // Main glass container - HTML spec: rgba(23,31,50,0.7)
              Container(
                decoration: BoxDecoration(
                  color: widget.useGlassEffect
                      ? (widget.backgroundColor ?? AppColors.glassBackground)
                      : (widget.backgroundColor ?? AppColors.shadcnCard),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  // HTML spec: directional border (top+left only)
                  border: widget.borderColor != null
                      ? Border.all(color: widget.borderColor!, width: 1.5)
                      : Border(
                          top: BorderSide(
                            color: AppColors.glassBorderTopLeft,
                            width: 1.5,
                          ),
                          left: BorderSide(
                            color: AppColors.glassBorderTopLeft,
                            width: 1.5,
                          ),
                        ),
                  boxShadow: _getCardShadow(),
                ),
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.all(16),
                  child: widget.child,
                ),
              ),
              // Glass highlight overlay (top-left gleam)
              if (widget.useGlassEffect)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0x14FFFFFF), Colors.transparent],
                          stops: [0.0, 0.5],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<BoxShadow>? _getCardShadow() {
    if (widget.glowColor != null) {
      return [
        BoxShadow(
          color: widget.glowColor!.withAlpha(51),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ];
    }

    if (_isHovered && widget.hoverEffect) {
      // Enhanced shadow on hover
      return [
        BoxShadow(
          color: AppColors.shadcnPrimary.withAlpha(26),
          blurRadius: 25,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: AppColors.shadcnSecondary.withAlpha(13),
          blurRadius: 40,
          spreadRadius: 0,
        ),
      ];
    }

    // Subtle default shadow
    return [
      BoxShadow(
        color: Colors.black.withAlpha(26),
        blurRadius: 10,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ];
  }
}

// ============================================
// SHADCN BUTTON - Neon Button Component
// ============================================

/// Button with neon glow effects
/// - Primary: Purple glow
/// - Secondary: Cyan glow
/// - Glass: Transparent with border
/// - Hover: Intensified glow
/// - Active: Scale down
class ShadcnButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isDestructive;
  final Color? glowColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool useNeonGlow;

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
    this.useNeonGlow = true,
  });

  @override
  State<ShadcnButton> createState() => _ShadcnButtonState();
}

class _ShadcnButtonState extends State<ShadcnButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Determine colors based on variant
    final bgColor =
        widget.backgroundColor ??
        (widget.isDestructive
            ? AppColors.shadcnDestructive
            : AppColors.shadcnPrimary);

    final fgColor =
        widget.foregroundColor ??
        (widget.isDestructive
            ? AppColors.shadcnDestructiveForeground
            : AppColors.shadcnPrimaryForeground);

    // Get neon glow based on color
    final glowColor =
        widget.glowColor ??
        (widget.isDestructive
            ? AppColors.shadcnDestructive
            : AppColors.shadcnPrimary);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transform: Matrix4.diagonal3Values(
            _isPressed ? 0.95 : (_isHovered ? 1.02 : 1.0),
            _isPressed ? 0.95 : (_isHovered ? 1.02 : 1.0),
            1.0,
          ),
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            // Gradient background
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bgColor, bgColor.withAlpha(204)],
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            // Neon glow effect
            boxShadow: widget.useNeonGlow ? _getButtonShadow(glowColor) : null,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: fgColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.2,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _getButtonShadow(Color glowColor) {
    if (_isHovered) {
      // Intense glow on hover
      return [
        BoxShadow(
          color: glowColor.withAlpha(128),
          blurRadius: 25,
          spreadRadius: 0,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: glowColor.withAlpha(77),
          blurRadius: 40,
          spreadRadius: 0,
        ),
      ];
    }
    // Default glow
    return [
      BoxShadow(
        color: glowColor.withAlpha(77),
        blurRadius: 15,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ];
  }
}

// ============================================
// SHADCN INPUT - Glass Input Component
// ============================================

/// Glass input field with focus glow effect
class ShadcnInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final int? maxLines;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  const ShadcnInput({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.autofocus = false,
    this.maxLines = 1,
    this.focusNode,
    this.onTap,
  });

  @override
  State<ShadcnInput> createState() => _ShadcnInputState();
}

class _ShadcnInputState extends State<ShadcnInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        // Glass background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _isFocused ? LiquidGlass.glassMedium : LiquidGlass.glassLow,
            _isFocused
                ? LiquidGlass.glassLow
                : LiquidGlass.glassLow.withAlpha(179),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        // Cyan glow on focus
        border: Border.all(
          color: _isFocused
              ? AppColors.shadcnSecondary.withAlpha(179)
              : LiquidGlass.glassBorder,
          width: _isFocused ? 2 : 1.5,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.shadcnSecondary.withAlpha(51),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
          widget.onTap?.call();
        },
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: AppColors.shadcnSecondary,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.white.withAlpha(128),
              fontSize: 14,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            border: InputBorder.none,
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

// ============================================
// SHADCN CHIP - Glass Chip Component
// ============================================

/// Glass chip with inset glow for active state
class ShadcnChip extends StatefulWidget {
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
  State<ShadcnChip> createState() => _ShadcnChipState();
}

class _ShadcnChipState extends State<ShadcnChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            // Glass background with active state
            gradient: isActive
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.shadcnPrimary.withAlpha(51),
                      AppColors.shadcnPrimary.withAlpha(26),
                    ],
                  )
                : (_isHovered
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            LiquidGlass.glassMedium,
                            LiquidGlass.glassLow,
                          ],
                        )
                      : null),
            color: !isActive && !_isHovered ? LiquidGlass.glassLow : null,
            borderRadius: BorderRadius.circular(20),
            // Glass border with active color
            border: Border.all(
              color: isActive
                  ? AppColors.shadcnPrimary.withAlpha(179)
                  : (_isHovered
                        ? LiquidGlass.glassBorder
                        : LiquidGlass.glassBorderLight),
              width: 1.5,
            ),
            // Inset glow for active state
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.shadcnPrimary.withAlpha(26),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 16,
                  color: isActive
                      ? AppColors.shadcnSecondary
                      : Colors.white.withAlpha(179),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: isActive
                      ? AppColors.shadcnSecondary
                      : Colors.white.withAlpha(179),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// SHADCN PROGRESS - Gradient Progress Bar
// ============================================

/// Progress bar with gradient fill and glow effect
class ShadcnProgress extends StatelessWidget {
  final double value;
  final Color? color;
  final double height;
  final bool showLabel;
  final bool useGradient;

  const ShadcnProgress({
    super.key,
    required this.value,
    this.color,
    this.height = 8,
    this.showLabel = false,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? AppColors.shadcnPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: TextStyle(
                    color: Colors.white.withAlpha(179),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${(value * 100).toInt()}%',
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        // Progress track
        Container(
          height: height,
          decoration: BoxDecoration(
            // Glass track background
            gradient: LinearGradient(
              colors: [
                LiquidGlass.glassLow,
                LiquidGlass.glassLow.withAlpha(128),
              ],
            ),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Progress fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: constraints.maxWidth * value.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      // Gradient fill with glow
                      gradient: useGradient
                          ? LinearGradient(
                              colors: [
                                progressColor,
                                AppColors.shadcnSecondary.withAlpha(204),
                              ],
                            )
                          : null,
                      color: useGradient ? null : progressColor,
                      borderRadius: BorderRadius.circular(height / 2),
                      boxShadow: [
                        BoxShadow(
                          color: progressColor.withAlpha(128),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================
// SHADCN AVATAR - Glass Avatar Component
// ============================================

/// Avatar with glass border effect
class ShadcnAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? fallback;
  final double size;
  final Color? borderColor;
  final bool showGlow;

  const ShadcnAvatar({
    super.key,
    this.imageUrl,
    this.fallback,
    this.size = 40,
    this.borderColor,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final glowColor = borderColor ?? AppColors.shadcnPrimary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? glowColor.withAlpha(179),
          width: 2,
        ),
        // Glass background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withAlpha(26), Colors.white.withAlpha(13)],
        ),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: glowColor.withAlpha(51),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ]
            : null,
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
    return Container(
      decoration: BoxDecoration(gradient: LiquidGlass.brandGradient),
      child: Center(
        child: Text(
          fallback?.substring(0, 1).toUpperCase() ?? '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ============================================
// SHADCN BADGE - Glass Badge Component
// ============================================

/// Badge with glass effect
class ShadcnBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final bool useGlassEffect;

  const ShadcnBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.useGlassEffect = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.shadcnPrimary;
    final fgColor = textColor ?? AppColors.shadcnSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // Glass background
        gradient: useGlassEffect
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bgColor.withAlpha(51), bgColor.withAlpha(26)],
              )
            : null,
        color: useGlassEffect ? null : bgColor.withAlpha(51),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bgColor.withAlpha(128), width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fgColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ============================================
// SHADCN TOGGLE - Neon Toggle Switch
// ============================================

/// Toggle switch with neon glow effect
class ShadcnToggle extends StatefulWidget {
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
  State<ShadcnToggle> createState() => _ShadcnToggleState();
}

class _ShadcnToggleState extends State<ShadcnToggle> {
  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? AppColors.shadcnPrimary;

    return GestureDetector(
      onTap: () => widget.onChanged?.call(!widget.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 52,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          // Glass background
          gradient: widget.value
              ? LinearGradient(
                  colors: [
                    activeColor.withAlpha(77),
                    activeColor.withAlpha(51),
                  ],
                )
              : null,
          color: widget.value ? null : LiquidGlass.glassLow,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: widget.value
                ? activeColor.withAlpha(204)
                : LiquidGlass.glassBorder,
            width: 1.5,
          ),
          boxShadow: widget.value
              ? [
                  BoxShadow(
                    color: activeColor.withAlpha(77),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: widget.value
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.value
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.white.withAlpha(230)],
                    )
                  : null,
              color: widget.value ? null : Colors.white.withAlpha(179),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 6,
                  spreadRadius: 0,
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

// ============================================
// SHADCN SKELETON - Loading Skeleton
// ============================================

/// Skeleton loading placeholder with shimmer effect
class ShadcnSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final bool useShimmer;

  const ShadcnSkeleton({
    super.key,
    this.width,
    this.height = 20,
    this.borderRadius = 8,
    this.useShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    final skeleton = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // Glass background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            LiquidGlass.glassLow,
            LiquidGlass.glassLow.withAlpha(128),
            LiquidGlass.glassLow,
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    if (useShimmer) {
      return skeleton
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 1500.ms, color: Colors.white.withAlpha(51));
    }

    return skeleton;
  }
}

// ============================================
// SHADCN DIVIDER - Glass Divider
// ============================================

/// Subtle glass divider
class ShadcnDivider extends StatelessWidget {
  final double height;
  final Color? color;

  const ShadcnDivider({super.key, this.height = 1, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            color ?? LiquidGlass.glassBorder,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// ============================================
// SHADCN TOOLTIP - Glass Tooltip
// ============================================

/// Tooltip with glass effect
class ShadcnTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final TooltipTriggerMode? triggerMode;

  const ShadcnTooltip({
    super.key,
    required this.message,
    required this.child,
    this.triggerMode,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      triggerMode: triggerMode ?? TooltipTriggerMode.longPress,
      decoration: BoxDecoration(
        // Glass background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.shadcnCard.withAlpha(230),
            AppColors.shadcnCard.withAlpha(204),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LiquidGlass.glassBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }
}

// ============================================
// END OF LIQUID NEBULA FASE 1
// ============================================
