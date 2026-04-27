import 'package:flutter/material.dart';

class DesignTokens {
  // ============================================
  // SPACING - Consistent spacing system
  // ============================================
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Spacing as EdgeInsets
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // ============================================
  // BORDER RADIUS - Multiple styles
  // ============================================
  static const double radiusNone = 0.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 24.0;
  static const double radiusFull = 999.0;

  // BorderRadius helpers
  static BorderRadius getRadius(double value) => BorderRadius.circular(value);
  static BorderRadius get radiusNoneB => BorderRadius.circular(radiusNone);
  static BorderRadius get radiusSmB => BorderRadius.circular(radiusSm);
  static BorderRadius get radiusMdB => BorderRadius.circular(radiusMd);
  static BorderRadius get radiusLgB => BorderRadius.circular(radiusLg);
  static BorderRadius get radiusXlB => BorderRadius.circular(radiusXl);
  static BorderRadius get radiusXxlB => BorderRadius.circular(radiusXxl);
  static BorderRadius get radiusFullB => BorderRadius.circular(radiusFull);

  static BorderRadius getBorderRadiusByStyle(String style) {
    switch (style) {
      case 'square':
        return radiusSmB;
      case 'pill':
        return radiusFullB;
      case 'rounded':
      default:
        return radiusLgB;
    }
  }

  // ============================================
  // ANIMATION DURATIONS
  // ============================================
  static const int animInstant = 50;
  static const int animFast = 150;
  static const int animNormal = 300;
  static const int animSlow = 500;
  static const int animVerySlow = 800;

  static Duration getDuration(int ms) => Duration(milliseconds: ms);
  static Duration get animInstantD => const Duration(milliseconds: animInstant);
  static Duration get animFastD => const Duration(milliseconds: animFast);
  static Duration get animNormalD => const Duration(milliseconds: animNormal);
  static Duration get animSlowD => const Duration(milliseconds: animSlow);
  static Duration get animVerySlowD => const Duration(milliseconds: animVerySlow);

  static Duration getDurationByStyle(String style, double speed) {
    int ms;
    switch (style) {
      case 'elastic':
        ms = 600;
        break;
      case 'bounce':
        ms = 500;
        break;
      case 'linear':
        ms = 200;
        break;
      case 'smooth':
      default:
        ms = animNormal;
    }
    return Duration(milliseconds: (ms / speed).round());
  }

  // Animation Curves
  static Curve getCurveByStyle(String style) {
    switch (style) {
      case 'elastic':
        return Curves.elasticOut;
      case 'bounce':
        return Curves.bounceOut;
      case 'linear':
        return Curves.linear;
      case 'smooth':
      default:
        return Curves.easeInOut;
    }
  }

  // ============================================
  // ELEVATION - Shadow levels
  // ============================================
  static const double elevNone = 0.0;
  static const double elevSm = 2.0;
  static const double elevMd = 4.0;
  static const double elevLg = 8.0;
  static const double elevXl = 16.0;
  static const double elevXxl = 24.0;

  static List<BoxShadow> getShadow(double elevation, {Color? color}) {
    if (elevation == 0) return [];
    final c = color ?? Colors.black;
    return [
      BoxShadow(
        color: c.withAlpha((elevation * 8).round().clamp(0, 50)),
        blurRadius: elevation * 2,
        offset: Offset(0, elevation),
      ),
    ];
  }

  // ============================================
  // ICON SIZES
  // ============================================
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double iconXxl = 48.0;

  static double getIconSize(double scale) => iconLg * scale;

  // ============================================
  // FONT SIZES
  // ============================================
  static const double fontXs = 10.0;
  static const double fontSm = 12.0;
  static const double fontMd = 14.0;
  static const double fontLg = 16.0;
  static const double fontXl = 20.0;
  static const double fontXxl = 24.0;
  static const double fontDisplay = 32.0;

  static double getFontSize(double baseSize, double scale) => baseSize * scale;

  // ============================================
  // TOUCH TARGETS - Accessibility
  // ============================================
  static const double touchTargetMin = 48.0;
  static const double touchTargetMd = 56.0;
  static const double touchTargetLg = 64.0;

  // ============================================
  // LAYOUT - Grid and max widths
  // ============================================
  static const double maxWidthMobile = 480.0;
  static const double maxWidthTablet = 768.0;
  static const double maxWidthDesktop = 1024.0;
  static const double maxWidthWide = 1440.0;

  static const int gridColumnsMobile = 2;
  static const int gridColumnsTablet = 4;
  static const int gridColumnsDesktop = 6;

  // ============================================
  // VISUAL DENSITY
  // ============================================
  static VisualDensity getVisualDensity(String density) {
    switch (density) {
      case 'compact':
        return const VisualDensity(horizontal: -1, vertical: -1);
      case 'spacious':
        return const VisualDensity(horizontal: 1, vertical: 1);
      case 'comfortable':
      default:
        return const VisualDensity(horizontal: 0, vertical: 0);
    }
  }
}

// ============================================
// CUSTOM COLOR HELPERS
// ============================================

extension ColorExtensions on Color {
  Color withIntensityMethod(double intensity) {
    return Color.fromARGB(
      (intensity * 255).round(),
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
    );
  }

  Color get lighter => Color.fromARGB(
    (a * 255).round(),
    ((r + ((1 - r) * 0.3)) * 255).round(),
    ((g + ((1 - g) * 0.3)) * 255).round(),
    ((b + ((1 - b) * 0.3)) * 255).round(),
  );

  Color get darker => Color.fromARGB(
    (a * 255).round(),
    (r * 0.7 * 255).round(),
    (g * 0.7 * 255).round(),
    (b * 0.7 * 255).round(),
  );

  Color withContrastMethod(Color background, double ratio) {
    final luminance = computeLuminance();
    final bgLuminance = background.computeLuminance();
    return luminance > bgLuminance ? darker : lighter;
  }
}
