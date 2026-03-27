import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryColor = Color(0xFFB79FFF);
  static const _secondaryColor = Color(0xFF62FAE3);
  static const _tertiaryColor = Color(0xFFFF86C3);

  static const _backgroundDark = Color(0xFF060E20);
  static const _surfaceDark = Color(0xFF0F1930);
  static const _surfaceContainerDark = Color(0xFF192540);
  static const _surfaceContainerHighDark = Color(0xFF141F38);

  static const _primaryContainer = Color(0xFFAB8FFE);
  static const _onPrimary = Color(0xFF361083);
  static const _onSurface = Color(0xFFDEE5FF);
  static const _onSurfaceVariant = Color(0xFFA3AAC4);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _tertiaryColor,
        surface: _surfaceDark,
        onPrimary: _onPrimary,
        onSecondary: Color(0xFF005C52),
        onTertiary: Color(0xFF5F003E),
        onSurface: _onSurface,
        onSurfaceVariant: _onSurfaceVariant,
        primaryContainer: _primaryContainer,
        secondaryContainer: Color(0xFF006B5F),
        tertiaryContainer: Color(0xFFF673B7),
        error: Color(0xFFFF6E84),
        surfaceContainerHighest: _surfaceContainerDark,
        surfaceContainerHigh: _surfaceContainerHighDark,
        surfaceContainer: _surfaceDark,
        surfaceContainerLow: Color(0xFF091328),
        surfaceContainerLowest: Color(0xFF000000),
        outline: Color(0xFF6D758C),
        outlineVariant: Color(0xFF40485D),
      ),
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _surfaceContainerDark.withValues(alpha: 0.4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceContainerDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        hintStyle: const TextStyle(color: _onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: _primaryColor,
          foregroundColor: _onPrimary,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: _primaryColor,
        foregroundColor: _onPrimary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 70,
        backgroundColor: _backgroundDark.withValues(alpha: 0.8),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorColor: _primaryColor.withValues(alpha: 0.2),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        backgroundColor: _surfaceDark,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: _surfaceDark,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: _surfaceContainerDark,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: _onSurface,
          fontWeight: FontWeight.w900,
        ),
        headlineMedium: TextStyle(
          color: _onSurface,
          fontWeight: FontWeight.w900,
        ),
        headlineSmall: TextStyle(
          color: _onSurface,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(color: _onSurface, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: _onSurface, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: _onSurface, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: _onSurface),
        bodyMedium: TextStyle(color: _onSurface),
        bodySmall: TextStyle(color: _onSurfaceVariant),
        labelLarge: TextStyle(color: _onSurface, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: _onSurfaceVariant),
        labelSmall: TextStyle(color: _onSurfaceVariant),
      ),
    );
  }

  static ThemeData get lightTheme => darkTheme;

  static BoxDecoration get glassCard => BoxDecoration(
    color: _surfaceContainerDark.withValues(alpha: 0.4),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: _primaryColor.withValues(alpha: 0.1)),
  );

  static BoxDecoration get glassCardHover => BoxDecoration(
    color: _surfaceContainerDark.withValues(alpha: 0.6),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: _primaryColor.withValues(alpha: 0.2)),
  );
}
