import 'package:flutter/material.dart';

class AppColors {
  // ============================================
  // LIQUID NEBULA DESIGN SYSTEM - HTML SPEC
  // ============================================

  // ============================================
  // CORE SURFACE COLORS (HTML Spec)
  // ============================================

  static const Color surface = Color(0xFF0b1325);
  static const Color surfaceDim = Color(0xFF0b1325);
  static const Color surfaceBright = Color(0xFF31394d);
  static const Color surfaceContainer = Color(0xFF171f32);
  static const Color surfaceContainerLow = Color(0xFF131b2e);
  static const Color surfaceContainerHigh = Color(0xFF222a3d);
  static const Color surfaceContainerHighest = Color(0xFF2d3448);
  static const Color surfaceContainerLowest = Color(0xFF060e20);
  static const Color surfaceVariant = Color(0xFF2d3448);
  static const Color surfaceTint = Color(0xFFd0bcff);

  // ============================================
  // PRIMARY PALETTE (HTML Spec: #d3bfff)
  // ============================================

  static const Color primary = Color(0xFFd3bfff);
  static const Color primaryDim = Color(0xFFc4abff);
  static const Color primaryContainer = Color(0xFFba9eff);
  static const Color onPrimary = Color(0xFF391b77);
  static const Color onPrimaryContainer = Color(0xFF4b2f89);
  static const Color primaryFixed = Color(0xFFe9ddff);
  static const Color primaryFixedDim = Color(0xFFd0bcff);
  static const Color onPrimaryFixed = Color(0xFF23005c);
  static const Color onPrimaryFixedVariant = Color(0xFF50358f);

  // ============================================
  // SECONDARY PALETTE (HTML Spec: #5ce6ff)
  // ============================================

  static const Color secondary = Color(0xFF5ce6ff);
  static const Color secondaryDim = Color(0xFF2fd9f4);
  static const Color secondaryContainer = Color(0xFF00cbe5);
  static const Color onSecondary = Color(0xFF00363e);
  static const Color onSecondaryContainer = Color(0xFF00515d);
  static const Color secondaryFixed = Color(0xFFa2eeff);
  static const Color secondaryFixedDim = Color(0xFF2fd9f4);
  static const Color onSecondaryFixed = Color(0xFF001f25);
  static const Color onSecondaryFixedVariant = Color(0xFF004e5a);

  // ============================================
  // TERTIARY PALETTE (HTML Spec: #ffb5c8)
  // ============================================

  static const Color tertiary = Color(0xFFffb5c8);
  static const Color tertiaryDim = Color(0xFFf0779d);
  static const Color tertiaryContainer = Color(0xFFf58fad);
  static const Color onTertiary = Color(0xFF5c1330);
  static const Color onTertiaryContainer = Color(0xFF722541);
  static const Color tertiaryFixed = Color(0xFFffd9e1);
  static const Color tertiaryFixedDim = Color(0xFFffb1c5);
  static const Color onTertiaryFixed = Color(0xFF3f001b);
  static const Color onTertiaryFixedVariant = Color(0xFF792b46);

  // ============================================
  // NEUTRAL / TEXT
  // ============================================

  static const Color onSurface = Color(0xFFdae2fc);
  static const Color onSurfaceVariant = Color(0xFFcbc4d3);
  static const Color onBackground = Color(0xFFdae2fc);
  static const Color inverseSurface = Color(0xFFdae2fc);
  static const Color inverseOnSurface = Color(0xFF283044);
  static const Color inversePrimary = Color(0xFF684ea8);

  // ============================================
  // OUTLINE
  // ============================================

  static const Color outline = Color(0xFF948e9c);
  static const Color outlineVariant = Color(0xFF494551);

  // ============================================
  // ERROR (HTML Spec)
  // ============================================

  static const Color error = Color(0xFFffb4ab);
  static const Color errorContainer = Color(0xFF93000a);
  static const Color onError = Color(0xFF690005);
  static const Color onErrorContainer = Color(0xFFffdad6);

  // ============================================
  // SUCCESS
  // ============================================

  static const Color success = Color(0xFF22C55E);
  static const Color successDim = Color(0xFF16A34A);

  // ============================================
  // SHADCN TOKENS (HTML Aligned)
  // ============================================

  static const Color shadcnBackground = Color(0xFF060E20);
  static const Color shadcnForeground = Color(0xFFE2E8F0);
  static const Color shadcnCard = Color(0xFF171F32);
  static const Color shadcnCardForeground = Color(0xFFE2E8F0);

  static const Color shadcnPrimary = Color(0xFFd3bfff);
  static const Color shadcnPrimaryForeground = Color(0xFF000000);

  static const Color shadcnSecondary = Color(0xFF5ce6ff);
  static const Color shadcnSecondaryForeground = Color(0xFF003a43);

  static const Color shadcnTertiary = Color(0xFFffb5c8);
  static const Color shadcnTertiaryForeground = Color(0xFF380018);

  static const Color shadcnAccent = Color(0xFFd3bfff);
  static const Color shadcnAccentForeground = Color(0xFF000000);

  static const Color shadcnMuted = Color(0xFF1F2B49);
  static const Color shadcnMutedForeground = Color(0xFF94A3B8);

  static const Color shadcnBorder = Color(0xFF1F2B49);
  static const Color shadcnInput = Color(0xFF1F2B49);
  static const Color shadcnRing = Color(0xFFd3bfff);

  static const Color shadcnDestructive = Color(0xFFffb4ab);
  static const Color shadcnDestructiveForeground = Color(0xFF690005);

  static const Color shadcnSuccess = Color(0xFF22C55E);

  // ============================================
  // GLASS EFFECT (HTML Spec)
  // rgba(23,31,50,0.7) = 0xB3171F32
  // ============================================

  static const Color glassBackground = Color(0xB3171F32);
  static const Color glassHigh = Color(0x26FFFFFF);
  static const Color glassMedium = Color(0x1AFFFFFF);
  static const Color glassLow = Color(0x0DFFFFFF);
  static const Color glassBorderTopLeft = Color(0x1AFFFFFF);
  static const Color glassBorderAll = Color(0x33FFFFFF);
  static const Color glassBorderLight = Color(0x1AFFFFFF);

  // ============================================
  // NEON GLOWS (HTML Derived)
  // ============================================

  static const Color neonPurple = Color(0x4Dd3bfff);
  static const Color neonCyan = Color(0x4D5ce6ff);
  static const Color neonPurpleStrong = Color(0x80d3bfff);
  static const Color neonCyanStrong = Color(0x805ce6ff);
  static const Color neonTertiary = Color(0x4Dffb5c8);
  static const Color neonTertiaryStrong = Color(0x80ffb5c8);
  static const Color insetPurple = Color(0x1Ad3bfff);
  static const Color insetCyan = Color(0x1A5ce6ff);

  // ============================================
  // GRADIENTS
  // ============================================

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryContainer],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryContainer],
  );

  static const LinearGradient tertiaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [tertiary, tertiaryDim],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, successDim],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [error, Color(0xFFd73357)],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassHigh, glassLow],
  );

  static const LinearGradient glassGradientElevated = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33FFFFFF), Color(0x1AFFFFFF)],
  );

  // ============================================
  // BOX SHADOWS
  // ============================================

  static List<BoxShadow> get purpleGlow => [
    const BoxShadow(
      color: neonPurple,
      blurRadius: 15,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get purpleGlowStrong => [
    const BoxShadow(
      color: neonPurpleStrong,
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
    BoxShadow(color: primary.withAlpha(77), blurRadius: 30, spreadRadius: 0),
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
    const BoxShadow(
      color: neonCyanStrong,
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
    BoxShadow(color: secondary.withAlpha(77), blurRadius: 30, spreadRadius: 0),
  ];

  // ============================================
  // BACKWARD COMPAT (dark/light unified)
  // ============================================

  static Color get darkPrimary => primary;
  static Color get darkPrimaryDim => primaryDim;
  static Color get darkPrimaryContainer => primaryContainer;
  static Color get darkOnPrimary => onPrimary;
  static Color get darkOnPrimaryFixed => onPrimaryFixed;
  static Color get darkOnPrimaryFixedVariant => onPrimaryFixedVariant;
  static Color get darkOnPrimaryContainer => onPrimaryContainer;
  static Color get darkPrimaryFixed => primaryFixed;
  static Color get darkPrimaryFixedDim => primaryFixedDim;

  static Color get darkSecondary => secondary;
  static Color get darkSecondaryDim => secondaryDim;
  static Color get darkSecondaryContainer => secondaryContainer;
  static Color get darkOnSecondary => onSecondary;
  static Color get darkOnSecondaryContainer => onSecondaryContainer;
  static Color get darkSecondaryFixed => secondaryFixed;
  static Color get darkSecondaryFixedDim => secondaryFixedDim;
  static Color get darkOnSecondaryFixed => onSecondaryFixed;
  static Color get darkOnSecondaryFixedVariant => onSecondaryFixedVariant;

  static Color get darkTertiary => tertiary;
  static Color get darkTertiaryDim => tertiaryDim;
  static Color get darkTertiaryContainer => tertiaryContainer;
  static Color get darkOnTertiary => onTertiary;
  static Color get darkOnTertiaryContainer => onTertiaryContainer;
  static Color get darkTertiaryFixed => tertiaryFixed;
  static Color get darkTertiaryFixedDim => tertiaryFixedDim;
  static Color get darkOnTertiaryFixed => onTertiaryFixed;
  static Color get darkOnTertiaryFixedVariant => onTertiaryFixedVariant;

  static Color get darkSurface => surface;
  static Color get darkSurfaceDim => surfaceDim;
  static Color get darkSurfaceBright => surfaceBright;
  static Color get darkSurfaceContainer => surfaceContainer;
  static Color get darkSurfaceContainerLow => surfaceContainerLow;
  static Color get darkSurfaceContainerHigh => surfaceContainerHigh;
  static Color get darkSurfaceContainerHighest => surfaceContainerHighest;
  static Color get darkSurfaceContainerLowest => surfaceContainerLowest;
  static Color get darkSurfaceTint => surfaceTint;

  static Color get darkBackground => surface;
  static Color get darkOnBackground => onBackground;
  static Color get darkOnSurface => onSurface;
  static Color get darkOnSurfaceVariant => onSurfaceVariant;

  static Color get darkError => error;
  static Color get darkErrorDim => const Color(0xFFd73357);
  static Color get darkErrorContainer => errorContainer;
  static Color get darkOnError => onError;
  static Color get darkOnErrorContainer => onErrorContainer;

  static Color get darkOutline => outline;
  static Color get darkOutlineVariant => outlineVariant;

  static Color get darkInverseSurface => inverseSurface;
  static Color get darkInverseOnSurface => inverseOnSurface;
  static Color get darkInversePrimary => inversePrimary;

  // Light mode aliases
  static Color get lightPrimary => primary;
  static Color get lightPrimaryDim => primaryDim;
  static Color get lightPrimaryContainer => primaryContainer;
  static Color get lightOnPrimary => onPrimary;
  static Color get lightOnPrimaryContainer => onPrimaryContainer;

  static Color get lightSecondary => secondary;
  static Color get lightSecondaryDim => secondaryDim;
  static Color get lightSecondaryContainer => secondaryContainer;
  static Color get lightOnSecondary => onSecondary;
  static Color get lightOnSecondaryContainer => onSecondaryContainer;

  static Color get lightTertiary => tertiary;
  static Color get lightTertiaryContainer => tertiaryContainer;
  static Color get lightOnTertiary => onTertiary;
  static Color get lightOnTertiaryContainer => onTertiaryContainer;

  static Color get lightSurface => surface;
  static Color get lightSurfaceDim => surfaceDim;
  static Color get lightSurfaceBright => surfaceBright;
  static Color get lightSurfaceContainer => surfaceContainer;
  static Color get lightSurfaceContainerLow => surfaceContainerLow;
  static Color get lightSurfaceContainerHigh => surfaceContainerHigh;
  static Color get lightSurfaceContainerHighest => surfaceContainerHighest;
  static Color get lightSurfaceContainerLowest => surfaceContainerLowest;
  static Color get lightSurfaceTint => surfaceTint;

  static Color get lightBackground => surface;
  static Color get lightOnBackground => onBackground;
  static Color get lightOnSurface => onSurface;
  static Color get lightOnSurfaceVariant => onSurfaceVariant;

  static Color get lightError => error;
  static Color get lightErrorContainer => errorContainer;
  static Color get lightOnError => onError;
  static Color get lightOnErrorContainer => onErrorContainer;

  static Color get lightOutline => outline;
  static Color get lightOutlineVariant => outlineVariant;

  static Color get lightInverseSurface => inverseSurface;
  static Color get lightInverseOnSurface => inverseOnSurface;
  static Color get lightInversePrimary => inversePrimary;

  // Legacy gradient
  static const LinearGradient liquidGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryContainer],
  );

  static const LinearGradient liquidGradientReverse = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryContainer, primary],
  );

  // Legacy setters
  static set primary(Color c) {}
  static set secondary(Color c) {}
  static set tertiary(Color c) {}
  static set surface(Color c) {}
  static set background(Color c) {}
  static set onPrimary(Color c) {}
  static set onSecondary(Color c) {}
  static set onSurface(Color c) {}
  static set onBackground(Color c) {}
  static set error(Color c) {}

  // Legacy compat
  static Color get glassDark => const Color(0x66091E28);
  static Color get glassBorderDark => const Color(0x2640485D);
  static Color get glassHighlightDark => const Color(0x1AFFFFFF);
  static Color get glassLight => const Color(0x80FFFFFF);
  static Color get glassSurfaceLight => surfaceContainer.withAlpha(102);
  static Color get glassSurfaceDark => surfaceContainer.withAlpha(102);
  static Color get legacyGlassBorder => outlineVariant;

  // Legacy getters
  static Color get primaryColor => primary;
  static Color get secondaryColor => secondary;
  static Color get tertiaryColor => tertiary;
  static Color get surfaceColor => surface;
  static Color get backgroundColor => surface;
  static Color get onPrimaryColor => onPrimary;
  static Color get onSecondaryColor => onSecondary;
  static Color get onSurfaceColor => onSurface;
  static Color get onBackgroundColor => onBackground;
  static Color get errorColor => error;
  static Color get primaryContainerColor => primaryContainer;
  static Color get onSurfaceVariantColor => onSurfaceVariant;
  static Color get surfaceContainerHighestColor => surfaceContainerHighest;
  static Color get outlineVariantColor => outlineVariant;
  static Color get onPrimaryContainerColor => onPrimaryContainer;
  static Color get onSecondaryContainerColor => onSecondaryContainer;
  static Color get onTertiaryContainerColor => onTertiaryContainer;
  static Color get errorContainerColor => errorContainer;
  static Color get onErrorContainerColor => onErrorContainer;
  static Color get surfaceContainerColor => surfaceContainer;
  static Color get surfaceContainerLowColor => surfaceContainerLow;
  static Color get surfaceContainerHighColor => surfaceContainerHigh;
  static Color get surfaceBrightColor => surfaceBright;
  static Color get surfaceDimColor => surfaceDim;
  static Color get surfaceTintColor => surfaceTint;
  static Color get inverseSurfaceColor => inverseSurface;
  static Color get inverseOnSurfaceColor => inverseOnSurface;
  static Color get inversePrimaryColor => inversePrimary;
  static Color get onErrorColor => onError;
  static Color get outlineColor => outline;

  // ============================================
  // GLASS CARD CONFIG
  // ============================================

  static const GlassCardConfig glassCard = GlassCardConfig();
}

class GlassCardConfig {
  const GlassCardConfig();

  static const double blurSigma = 25.0;
  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 20.0;
  static const double borderRadiusHero = 32.0;
  static const double borderWidth = 1.5;

  static const Color glassLight = Color(0x26FFFFFF);
  static const Color glassMedium = Color(0x1AFFFFFF);
  static const Color glassDark = Color(0x0DFFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);
  static const Color glassBorderSubtle = Color(0x1AFFFFFF);

  static const Color glowPrimary = Color(0x4Dd3bfff);
  static const Color glowSecondary = Color(0x4D5ce6ff);
  static const Color glowTertiary = Color(0x4Dffb5c8);
  static const Color glowError = Color(0x4Dffb4ab);

  static LinearGradient get glassGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassLight, glassDark],
  );

  static LinearGradient get glassGradientElevated => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33FFFFFF), Color(0x1AFFFFFF)],
  );

  static LinearGradient get glassGradientPrimary => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0x26FFFFFF),
      const Color(0x1AFFFFFF),
      const Color(0x0Dd3bfff).withAlpha(26),
    ],
    stops: const [0.0, 0.7, 1.0],
  );

  static List<BoxShadow> glowPrimaryShadow({double intensity = 1.0}) => [
    BoxShadow(
      color: glowPrimary.withAlpha((0x4D * intensity).toInt()),
      blurRadius: 15 * intensity,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> glowSecondaryShadow({double intensity = 1.0}) => [
    BoxShadow(
      color: glowSecondary.withAlpha((0x4D * intensity).toInt()),
      blurRadius: 15 * intensity,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> glowPrimaryStrong({double intensity = 1.0}) => [
    BoxShadow(
      color: const Color(0x80d3bfff).withAlpha((0x80 * intensity).toInt()),
      blurRadius: 20 * intensity,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0x33d3bfff).withAlpha((0x33 * intensity).toInt()),
      blurRadius: 40 * intensity,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> glowSecondaryStrong({double intensity = 1.0}) => [
    BoxShadow(
      color: const Color(0x805ce6ff).withAlpha((0x80 * intensity).toInt()),
      blurRadius: 20 * intensity,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0x335ce6ff).withAlpha((0x33 * intensity).toInt()),
      blurRadius: 40 * intensity,
      spreadRadius: 0,
    ),
  ];

  static LinearGradient get brandGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFd3bfff), Color(0xFF5ce6ff)],
  );

  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFd3bfff), Color(0xFFba9eff)],
  );

  static LinearGradient get secondaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5ce6ff), Color(0xFF2fd9f4)],
  );

  static LinearGradient get tertiaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFffb5c8), Color(0xFFf0779d)],
  );

  static LinearGradient get errorGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFffb4ab), Color(0xFFd73357)],
  );

  static LinearGradient get successGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
  );
}
