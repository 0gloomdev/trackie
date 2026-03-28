import 'package:flutter/material.dart';

class AppColors {
  // Light mode colors
  static const Color lightPrimary = Color(0xFF6200EE);
  static const Color lightSecondary = Color(0xFF03DAC6);
  static const Color lightSurface = Color(0xFFE6E6E6); // 90% opacity white
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFF000000);
  static const Color lightOnSurface = Color(0xFF000000);
  static const Color lightError = Color(0xFFB00020);

  // Dark mode colors
  static const Color darkPrimary = Color(0xFFBB86FC);
  static const Color darkSecondary = Color(0xFF03DAC6);
  static const Color darkSurface = Color(0xFF333333); // 80% opacity black
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkOnSecondary = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkError = Color(0xFFCF6679);

  // Common colors (Material 3 defaults)
  static const Color primary = lightPrimary;
  static const Color secondary = lightSecondary;
  static const Color tertiary = Color(0xFF7C4DFF);
  static const Color primaryContainer = Color(0xFFE8DEF8);
  static const Color onSurfaceVariant = Color(0xFF49454F);
  static const Color surfaceContainerHighest = Color(0xFFE7E0EC);
  static const Color outlineVariant = Color(0xFFCAC4D0);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color error = lightError;

  // Glass effect colors
  static const Color glassSurfaceLight = Color(0x33FFFFFF); // 0.2 opacity white
  static const Color glassSurfaceDark = Color(0x14FFFFFF); // 0.08 opacity white
  static const Color glassTintLight = Color(0x66FFFFFF); // 0.4 opacity white
  static const Color glassTintDark = Color(0x1AFFFFFF); // 0.1 opacity white
  static const Color glassBorder = Color(0x33FFFFFF); // 0.2 opacity white
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightSurface,
        onPrimary: AppColors.lightOnPrimary,
        onSecondary: AppColors.lightOnSecondary,
        onSurface: AppColors.lightOnSurface,
        error: AppColors.lightError,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        surface: AppColors.darkSurface,
        onPrimary: AppColors.darkOnPrimary,
        onSecondary: AppColors.darkOnSecondary,
        onSurface: AppColors.darkOnSurface,
        error: AppColors.darkError,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  static BoxDecoration glassCard({
    required bool isDark,
    double blurSigma = 20.0,
    double borderRadius = 16.0,
  }) {
    return BoxDecoration(
      color: isDark ? AppColors.glassSurfaceDark : AppColors.glassSurfaceLight,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AppColors.glassBorder, width: 1.0),
    );
  }

  static BoxDecoration glassCardHover({
    required bool isDark,
    double blurSigma = 20.0,
    double borderRadius = 16.0,
  }) {
    return BoxDecoration(
      color: isDark
          ? AppColors.glassSurfaceDark.withValues(alpha: 0.12)
          : AppColors.glassSurfaceLight.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: AppColors.glassBorder.withValues(alpha: 0.3),
        width: 1.0,
      ),
    );
  }
}
