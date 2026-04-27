import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ============================================
// APP TYPOGRAPHY - HTML Spec Fonts
// Space Grotesk (headline), Manrope (body), Inter (label)
// ============================================

class AppTypography {
  // Font families
  static const String headlineFont = 'SpaceGrotesk';
  static const String bodyFont = 'Manrope';
  static const String labelFont = 'Inter';

  // ============================================
  // HEADLINE STYLES (Space Grotesk)
  // ============================================

  static TextStyle get heroTitle => const TextStyle(
    fontFamily: headlineFont,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    color: AppColors.onSurface,
  );

  static TextStyle get pageTitle => const TextStyle(
    fontFamily: headlineFont,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    color: AppColors.onSurface,
  );

  static TextStyle get sectionTitle => const TextStyle(
    fontFamily: headlineFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.onSurface,
  );

  static TextStyle get cardTitle => const TextStyle(
    fontFamily: headlineFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.onSurface,
  );

  static TextStyle get statValue => const TextStyle(
    fontFamily: headlineFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    color: AppColors.onSurface,
  );

  static TextStyle get statValueSmall => const TextStyle(
    fontFamily: headlineFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  // ============================================
  // BODY STYLES (Manrope)
  // ============================================

  static TextStyle get subtitle => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
  );

  static TextStyle get body => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.onSurface,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get caption => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
  );

  // ============================================
  // LABEL STYLES (Inter)
  // ============================================

  static TextStyle get label => const TextStyle(
    fontFamily: labelFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontFamily: labelFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get sectionLabel => const TextStyle(
    fontFamily: labelFont,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get typeBadge => const TextStyle(
    fontFamily: labelFont,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
    color: AppColors.onSurfaceVariant,
  );

  // ============================================
  // UTILITY STYLES
  // ============================================

  static TextStyle get gradientText => TextStyle(
    fontFamily: headlineFont,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    foreground: Paint()
      ..shader = AppColors.brandGradient.createShader(
        const Rect.fromLTWH(0, 0, 400, 40),
      ),
  );

  static TextStyle get transparentWithShadow => TextStyle(
    fontFamily: headlineFont,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    color: Colors.transparent,
    shadows: [
      Shadow(color: AppColors.secondary.withAlpha(128), offset: Offset.zero),
    ],
  );

  static TextStyle get monospace => const TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.secondary,
  );
}
