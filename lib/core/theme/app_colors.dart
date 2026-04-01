import 'package:flutter/material.dart';

class AppColors {
  // ============================================
  // LIQUID NEBULA DESIGN SYSTEM
  // FASE 1: Glass Components & Neon Glows
  // ============================================

  // ============================================
  // SHADCN DESIGN TOKENS (New UI) - Updated to HTML Specs
  // ============================================

  // Background
  static const Color shadcnBackground = Color(0xFF060E20);
  static const Color shadcnForeground = Color(0xFFE2E8F0);
  static const Color shadcnCard = Color(0xFF0F1930);
  static const Color shadcnCardForeground = Color(0xFFE2E8F0);

  // Primary (Violet) - Updated to #ba9eff per HTML spec
  static const Color shadcnPrimary = Color(0xFFba9eff);
  static const Color shadcnPrimaryForeground = Color(0xFF000000);

  // Secondary (Cyan) - Updated to #3adffa per HTML spec
  static const Color shadcnSecondary = Color(0xFF3adffa);
  static const Color shadcnSecondaryForeground = Color(0xFF003a43);

  // Tertiary (Rose) - NEW per HTML spec
  static const Color shadcnTertiary = Color(0xFFff97b5);
  static const Color shadcnTertiaryForeground = Color(0xFF380018);

  // Accent colors
  static const Color shadcnAccent = Color(0xFFba9eff);
  static const Color shadcnAccentForeground = Color(0xFF000000);

  // Muted
  static const Color shadcnMuted = Color(0xFF1F2B49);
  static const Color shadcnMutedForeground = Color(0xFF94A3B8);

  // Borders
  static const Color shadcnBorder = Color(0xFF1F2B49);
  static const Color shadcnInput = Color(0xFF1F2B49);
  static const Color shadcnRing = Color(0xFFba9eff);

  // Destructive (Error) - Updated to #ff6e84 per HTML spec
  static const Color shadcnDestructive = Color(0xFFff6e84);
  static const Color shadcnDestructiveForeground = Color(0xFF490013);

  // Success
  static const Color shadcnSuccess = Color(0xFF22C55E);

  // Glows - Updated to new primary
  static const Color shadcnGlowPurple = Color(0xFFba9eff);
  static const Color shadcnGlowCyan = Color(0xFF3adffa);

  // ============================================
  // LIQUID NEBULA: GLASS EFFECT COLORS
  // Simulated glassmorphism with gradient overlays
  // ============================================

  // Glass backgrounds (15%, 10%, 5% white)
  static const Color glassHigh = Color(0x26FFFFFF); // 15% white
  static const Color glassMedium = Color(0x1AFFFFFF); // 10% white
  static const Color glassLow = Color(0x0DFFFFFF); // 5% white

  // Glass borders (20%, 10% white)
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white
  static const Color glassBorderLight = Color(0x1AFFFFFF); // 10% white

  // ============================================
  // LIQUID NEBULA: NEON GLOW COLORS - Updated
  // ============================================

  // Neon purple glow (30% opacity) - Updated to #ba9eff
  static const Color neonPurple = Color(0x4Dba9eff);

  // Neon cyan glow (30% opacity) - Updated to #3adffa
  static const Color neonCyan = Color(0x4D3adffa);

  // Strong neon glow (50% opacity) - Updated
  static const Color neonPurpleStrong = Color(0x80ba9eff);
  static const Color neonCyanStrong = Color(0x803adffa);

  // Inset glow for active states (10% opacity) - Updated
  static const Color insetPurple = Color(0x1Aba9eff);
  static const Color insetCyan = Color(0x1A3adffa);

  // Neon tertiary glow (30% opacity) - NEW
  static const Color neonTertiary = Color(0x4Dff97b5);

  // Neon tertiary strong (50% opacity) - NEW
  static const Color neonTertiaryStrong = Color(0x80ff97b5);

  // ============================================
  // DARK MODE COLORS (Primary Theme) - Updated to HTML Specs
  // ============================================

  // Primary palette - Updated to #ba9eff family
  static const Color darkPrimary = Color(0xFFba9eff);
  static const Color darkPrimaryDim = Color(0xFFae8dff);
  static const Color darkPrimaryContainer = Color(0xFFae8dff);
  static const Color darkOnPrimary = Color(0xFF39008c);
  static const Color darkOnPrimaryFixed = Color(0xFF000000);
  static const Color darkOnPrimaryFixedVariant = Color(0xFF370086);
  static const Color darkOnPrimaryContainer = Color(0xFF2b006e);
  static const Color darkPrimaryFixed = Color(0xFFae8dff);
  static const Color darkPrimaryFixedDim = Color(0xFFa27cff);

  // Secondary palette - Updated to #3adffa family
  static const Color darkSecondary = Color(0xFF3adffa);
  static const Color darkSecondaryDim = Color(0xFF1ad0eb);
  static const Color darkSecondaryContainer = Color(0xFF006877);
  static const Color darkOnSecondary = Color(0xFF004b56);
  static const Color darkOnSecondaryContainer = Color(0xFFeafbff);
  static const Color darkSecondaryFixed = Color(0xFF48e4ff);
  static const Color darkSecondaryFixedDim = Color(0xFF29d6f1);
  static const Color darkOnSecondaryFixed = Color(0xFF003a43);
  static const Color darkOnSecondaryFixedVariant = Color(0xFF005966);

  // Tertiary palette - Updated to #ff97b5 family per HTML spec
  static const Color darkTertiary = Color(0xFFff97b5);
  static const Color darkTertiaryDim = Color(0xFFf0779d);
  static const Color darkTertiaryContainer = Color(0xFFfd81a8);
  static const Color darkOnTertiary = Color(0xFF6a0934);
  static const Color darkOnTertiaryContainer = Color(0xFF59002a);
  static const Color darkTertiaryFixed = Color(0xFFff8eb0);
  static const Color darkTertiaryFixedDim = Color(0xFFf67ca3);
  static const Color darkOnTertiaryFixed = Color(0xFF380018);
  static const Color darkOnTertiaryFixedVariant = Color(0xFF701039);

  // Surface palette
  static const Color darkSurface = Color(0xFF060E20);
  static const Color darkSurfaceDim = Color(0xFF060E20);
  static const Color darkSurfaceBright = Color(0xFF1F2B49);
  static const Color darkSurfaceContainer = Color(0xFF0F1930);
  static const Color darkSurfaceContainerLow = Color(0xFF091328);
  static const Color darkSurfaceContainerHigh = Color(0xFF141F38);
  static const Color darkSurfaceContainerHighest = Color(0xFF192540);
  static const Color darkSurfaceContainerLowest = Color(0xFF000000);
  static const Color darkSurfaceTint = Color(0xFFB79FFF);

  // Background
  static const Color darkBackground = Color(0xFF060E20);
  static const Color darkOnBackground = Color(0xFFDEE5FF);

  // On Surface
  static const Color darkOnSurface = Color(0xFFDEE5FF);
  static const Color darkOnSurfaceVariant = Color(0xFFA3AAC4);

  // Error palette - Updated to #ff6e84 per HTML spec
  static const Color darkError = Color(0xFFff6e84);
  static const Color darkErrorDim = Color(0xFFd73357);
  static const Color darkErrorContainer = Color(0xFFa70138);
  static const Color darkOnError = Color(0xFF490013);
  static const Color darkOnErrorContainer = Color(0xFFffb2b9);

  // Outline
  static const Color darkOutline = Color(0xFF6D758C);
  static const Color darkOutlineVariant = Color(0xFF40485D);

  // Inverse
  static const Color darkInverseSurface = Color(0xFFFAF8FF);
  static const Color darkInverseOnSurface = Color(0xFF4D556B);
  static const Color darkInversePrimary = Color(0xFF684CB6);

  // ============================================
  // LIGHT MODE COLORS
  // ============================================

  // Primary palette
  static const Color lightPrimary = Color(0xFF6200EE);
  static const Color lightPrimaryDim = Color(0xFF7C4DFF);
  static const Color lightPrimaryContainer = Color(0xFFE8DEF8);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnPrimaryContainer = Color(0xFF21005D);

  // Secondary palette
  static const Color lightSecondary = Color(0xFF03DAC6);
  static const Color lightSecondaryDim = Color(0xFF4DB6AC);
  static const Color lightSecondaryContainer = Color(0xFFCEFAF8);
  static const Color lightOnSecondary = Color(0xFF003731);
  static const Color lightOnSecondaryContainer = Color(0xFF00201C);

  // Tertiary palette
  static const Color lightTertiary = Color(0xFF7C4DFF);
  static const Color lightTertiaryContainer = Color(0xFFE8DEF8);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightOnTertiaryContainer = Color(0xFF22005D);

  // Surface palette
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceDim = Color(0xFFF5F5F7);
  static const Color lightSurfaceBright = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainer = Color(0xFFF3EDF7);
  static const Color lightSurfaceContainerLow = Color(0xFFFCFCFF);
  static const Color lightSurfaceContainerHigh = Color(0xFFECE6F0);
  static const Color lightSurfaceContainerHighest = Color(0xFFE6E0E9);
  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceTint = Color(0xFF6200EE);

  // Background
  static const Color lightBackground = Color(0xFFF5F5F7);
  static const Color lightOnBackground = Color(0xFF1C1B1F);

  // On Surface
  static const Color lightOnSurface = Color(0xFF1C1B1F);
  static const Color lightOnSurfaceVariant = Color(0xFF49454F);

  // Error palette
  static const Color lightError = Color(0xFFB00020);
  static const Color lightErrorContainer = Color(0xFFF9DEDC);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightOnErrorContainer = Color(0xFF410E0B);

  // Outline
  static const Color lightOutline = Color(0xFF79747E);
  static const Color lightOutlineVariant = Color(0xFFCAC4D0);

  // Inverse
  static const Color lightInverseSurface = Color(0xFF313033);
  static const Color lightInverseOnSurface = Color(0xFFF4EFF4);
  static const Color lightInversePrimary = Color(0xFFBB86FC);

  // ============================================
  // GRADIENTS
  // ============================================

  static const LinearGradient liquidGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkPrimary, darkPrimaryContainer],
  );

  static const LinearGradient liquidGradientReverse = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkPrimaryContainer, darkPrimary],
  );

  // ============================================
  // LIQUID NEBULA: GRADIENT HELPERS
  // ============================================

  // Glass gradient for cards
  static LinearGradient get glassGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassHigh, glassLow],
  );

  // Brand gradient (violet to cyan)
  static LinearGradient get brandGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [shadcnPrimary, shadcnSecondary],
  );

  // Purple to transparent gradient
  static LinearGradient purpleGlowGradient(double opacity) => LinearGradient(
    colors: [
      shadcnPrimary.withAlpha((opacity * 255).toInt()),
      Colors.transparent,
    ],
  );

  // Cyan to transparent gradient
  static LinearGradient cyanGlowGradient(double opacity) => LinearGradient(
    colors: [
      shadcnSecondary.withAlpha((opacity * 255).toInt()),
      Colors.transparent,
    ],
  );

  // ============================================
  // LIQUID NEBULA: BOX SHADOW HELPERS
  // ============================================

  // Purple neon glow (default)
  static List<BoxShadow> get purpleGlow => [
    BoxShadow(
      color: neonPurple,
      blurRadius: 15,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  // Purple neon glow (strong)
  static List<BoxShadow> get purpleGlowStrong => [
    BoxShadow(
      color: neonPurpleStrong,
      blurRadius: 20,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: shadcnPrimary.withAlpha(77),
      blurRadius: 30,
      spreadRadius: 0,
    ),
  ];

  // Cyan neon glow (default)
  static List<BoxShadow> get cyanGlow => [
    BoxShadow(
      color: neonCyan,
      blurRadius: 15,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  // Cyan neon glow (strong)
  static List<BoxShadow> get cyanGlowStrong => [
    BoxShadow(
      color: neonCyanStrong,
      blurRadius: 20,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: shadcnSecondary.withAlpha(77),
      blurRadius: 30,
      spreadRadius: 0,
    ),
  ];

  // ============================================
  // LEGACY GLASS EFFECT COLORS (Backward compatibility)
  // ============================================

  // Legacy dark glass (for backward compatibility)
  static Color get glassDark => const Color(0x66091E28);
  static Color get glassBorderDark => const Color(0x2640485D);
  static Color get glassHighlightDark => const Color(0x1AFFFFFF);

  // Legacy light glass (for backward compatibility)
  static Color get glassLight => const Color(0x80FFFFFF);
  static Color get legacyGlassBorderLight => const Color(0x14000000);
  static Color get legacyGlassHighlightLight => const Color(0x1A000000);

  // ============================================
  // BACKWARD COMPATIBILITY SHORTCUTS
  // These default to dark theme values
  // ============================================

  // Primary colors
  static Color primary = darkPrimary;
  static Color secondary = darkSecondary;
  static Color tertiary = darkTertiary;
  static Color surface = darkSurface;
  static Color background = darkBackground;
  static Color onPrimary = darkOnPrimary;
  static Color onSecondary = darkOnSecondary;
  static Color onSurface = darkOnSurface;
  static Color onBackground = darkOnBackground;
  static Color error = darkError;

  // Material 3 tokens
  static Color primaryContainer = darkPrimaryContainer;
  static Color onSurfaceVariant = darkOnSurfaceVariant;
  static Color surfaceContainerHighest = darkSurfaceContainerHighest;
  static Color outlineVariant = darkOutlineVariant;
  static Color onPrimaryContainer = darkOnPrimaryContainer;
  static Color onSecondaryContainer = darkOnSecondaryContainer;
  static Color onTertiaryContainer = darkTertiaryContainer;
  static Color errorContainer = darkErrorContainer;
  static Color onErrorContainer = darkOnErrorContainer;

  // Surface containers
  static Color surfaceContainer = darkSurfaceContainer;
  static Color surfaceContainerLow = darkSurfaceContainerLow;
  static Color surfaceContainerHigh = darkSurfaceContainerHigh;
  static Color surfaceBright = darkSurfaceBright;
  static Color surfaceDim = darkSurfaceDim;

  // Surface tints
  static Color surfaceTint = darkSurfaceTint;

  // Inverse
  static Color inverseSurface = darkInverseSurface;
  static Color inverseOnSurface = darkInverseOnSurface;
  static Color inversePrimary = darkInversePrimary;

  // On error
  static Color onError = darkOnError;

  // Outline
  static Color outline = darkOutline;

  // Legacy glass colors (for backward compatibility)
  static Color get glassSurfaceLight =>
      darkSurfaceContainer.withValues(alpha: 0.4);
  static Color get glassSurfaceDark =>
      darkSurfaceContainer.withValues(alpha: 0.4);
  static Color get legacyGlassBorder => darkOutlineVariant;

  // ============================================
  // LIQUID NEBULA: GLASS CARD CONFIG
  // Glass effect configuration matching HTML specs
  // ============================================

  /// Configuration class for Glass Card effects
  /// Matches the CSS glass-card class from HTML designs:
  /// background: linear-gradient(135deg, rgba(255,255,255,0.1), rgba(255,255,255,0.05))
  /// backdrop-filter: blur(25px)
  /// border: 1.5px solid rgba(255,255,255,0.1)
  static const GlassCardConfig glassCard = GlassCardConfig();
}

/// Glass Card effect configuration matching HTML design specs
class GlassCardConfig {
  const GlassCardConfig();

  /// Blur sigma for simulated backdrop-filter
  static const double blurSigma = 25.0;

  /// Border radius (xl = 0.75rem = 12px)
  static const double borderRadius = 12.0;

  /// Border radius large (1rem = 16px)
  static const double borderRadiusLarge = 16.0;

  /// Border width (1.5px)
  static const double borderWidth = 1.5;

  /// Glass gradient colors
  /// Glass light (15% white)
  static const Color glassLight = Color(0x26FFFFFF);

  /// Glass medium (10% white)
  static const Color glassMedium = Color(0x1AFFFFFF);

  /// Glass dark (5% white)
  static const Color glassDark = Color(0x0DFFFFFF);

  /// Glass border (20% white)
  static const Color glassBorder = Color(0x33FFFFFF);

  /// Glass border subtle (10% white)
  static const Color glassBorderSubtle = Color(0x1AFFFFFF);

  /// Primary glow color (30% primary)
  static const Color glowPrimary = Color(0x4Dba9eff);

  /// Secondary glow color (30% secondary)
  static const Color glowSecondary = Color(0x4D3adffa);

  /// Tertiary glow color (30% tertiary)
  static const Color glowTertiary = Color(0x4Dff97b5);

  /// Error glow color (30% error)
  static const Color glowError = Color(0x4Dff6e84);

  /// Standard glass gradient (15% -> 5% white)
  static LinearGradient get glassGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassLight, glassDark],
  );

  /// Elevated glass gradient (20% -> 10% white)
  static LinearGradient get glassGradientElevated => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33FFFFFF), Color(0x1AFFFFFF)],
  );

  /// Glass gradient with subtle primary tint
  static LinearGradient get glassGradientPrimary => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0x26FFFFFF),
      const Color(0x1AFFFFFF),
      const Color(0x0Dba9eff).withAlpha(26),
    ],
    stops: const [0.0, 0.7, 1.0],
  );

  /// Get glow shadow list for primary color
  static List<BoxShadow> glowPrimaryShadow({double intensity = 1.0}) => [
    BoxShadow(
      color: glowPrimary.withAlpha((0x4D * intensity).toInt()),
      blurRadius: 15 * intensity,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  /// Get glow shadow list for secondary color
  static List<BoxShadow> glowSecondaryShadow({double intensity = 1.0}) => [
    BoxShadow(
      color: glowSecondary.withAlpha((0x4D * intensity).toInt()),
      blurRadius: 15 * intensity,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  /// Get strong glow shadow list (dual layer)
  static List<BoxShadow> glowPrimaryStrong({double intensity = 1.0}) => [
    BoxShadow(
      color: const Color(0x80ba9eff).withAlpha((0x80 * intensity).toInt()),
      blurRadius: 20 * intensity,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0x33ba9eff).withAlpha((0x33 * intensity).toInt()),
      blurRadius: 40 * intensity,
      spreadRadius: 0,
    ),
  ];

  /// Get strong glow shadow list for secondary (cyan)
  static List<BoxShadow> glowSecondaryStrong({double intensity = 1.0}) => [
    BoxShadow(
      color: const Color(0x803adffa).withAlpha((0x80 * intensity).toInt()),
      blurRadius: 20 * intensity,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0x333adffa).withAlpha((0x33 * intensity).toInt()),
      blurRadius: 40 * intensity,
      spreadRadius: 0,
    ),
  ];

  /// Brand gradient (primary to secondary)
  static LinearGradient get brandGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFba9eff), Color(0xFF3adffa)],
  );

  /// Primary gradient (primary to primary-dim)
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFba9eff), Color(0xFFae8dff)],
  );

  /// Secondary gradient (secondary to secondary-dim)
  static LinearGradient get secondaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3adffa), Color(0xFF1ad0eb)],
  );

  /// Tertiary gradient (tertiary to tertiary-dim)
  static LinearGradient get tertiaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFff97b5), Color(0xFFf0779d)],
  );

  /// Error gradient
  static LinearGradient get errorGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFff6e84), Color(0xFFd73357)],
  );

  /// Success gradient
  static LinearGradient get successGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
  );
}
