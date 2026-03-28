import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppGlass {
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusPill = 999.0;

  static InputDecoration inputDecoration({
    required String hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  static SnackBar snackBar(String message) {
    return SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    );
  }
}

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const GlassAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: leading,
      title: Text(title),
      actions: actions,
    );
  }
}

extension ThemeColors on BuildContext {
  ColorScheme get themeColors => Theme.of(this).colorScheme;
  Color get primary => themeColors.primary;
  Color get secondary => themeColors.secondary;
  Color get surface => themeColors.surface;
  Color get onPrimary => themeColors.onPrimary;
  Color get onSecondary => themeColors.onSecondary;
  Color get onSurface => themeColors.onSurface;
  Color get onSurfaceVariant => themeColors.onSurfaceVariant;
  Color get error => themeColors.error;
  Color get primaryContainer => themeColors.primaryContainer;
  Color get tertiary => themeColors.tertiary;
  Color get surfaceContainerHighest => themeColors.surfaceContainerHighest;
  Color get outlineVariant => themeColors.outlineVariant;
}
