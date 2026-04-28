import 'package:flutter/material.dart';

// ============================================
// RESPONSIVE BREAKPOINTS SYSTEM
// ============================================
// Single source of truth for all responsive behavior
// ============================================

enum DeviceType { mobile, tablet, desktop, wide }

class Responsive {
  // ============================================
  // BREAKPOINTS - Width thresholds
  // ============================================
  static const double mobile = 480.0;
  static const double tablet = 768.0;
  static const double desktop = 1024.0;
  static const double wide = 1440.0;

  // ============================================
  // GRID COLUMNS - Per device type
  // ============================================
  static const int gridColumnsMobile = 1;
  static const int gridColumnsTablet = 2;
  static const int gridColumnsDesktop = 4;
  static const int gridColumnsWide = 6;

  // ============================================
  // SPACING MULTIPLIERS - Base padding * multiplier
  // ============================================
  static const double spacingMobile = 1.0;
  static const double spacingTablet = 1.25;
  static const double spacingDesktop = 1.5;
  static const double spacingWide = 2.0;

  // ============================================
  // SPACING VALUES - Pre-calculated
  // ============================================
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double spaceXxl = 48.0;
  static const double spaceXxxl = 64.0;

  static const double basePadding = 16.0;

  static double padding(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return basePadding * spacingMobile;
      case DeviceType.tablet:
        return basePadding * spacingTablet;
      case DeviceType.desktop:
        return basePadding * spacingDesktop;
      case DeviceType.wide:
        return basePadding * spacingWide;
    }
  }

  static EdgeInsets paddingAll(DeviceType type) =>
      EdgeInsets.all(padding(type));

  static EdgeInsets paddingHorizontal(DeviceType type) =>
      EdgeInsets.symmetric(horizontal: padding(type));

  static EdgeInsets paddingVertical(DeviceType type) =>
      EdgeInsets.symmetric(vertical: padding(type));

  // ============================================
  // GRID HELPERS - Columns count
  // ============================================
  static int gridColumns(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return gridColumnsMobile;
      case DeviceType.tablet:
        return gridColumnsTablet;
      case DeviceType.desktop:
        return gridColumnsDesktop;
      case DeviceType.wide:
        return gridColumnsWide;
    }
  }

  // ============================================
  // CONTENT WIDTH - Max content widths
  // ============================================
  static const double maxContentMobile = 480.0;
  static const double maxContentTablet = 720.0;
  static const double maxContentDesktop = 1024.0;
  static const double maxContentWide = 1440.0;

  static double maxWidth(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return maxContentMobile;
      case DeviceType.tablet:
        return maxContentTablet;
      case DeviceType.desktop:
        return maxContentDesktop;
      case DeviceType.wide:
        return maxContentWide;
    }
  }

  // ============================================
  // NAVIGATION - Sidebar width
  // ============================================
  static const double sidebarWidth = 260.0;
  static const double sidebarCollapsedWidth = 72.0;

  // ============================================
  // DEVICE TYPE DETECTION
  // ============================================
  static DeviceType getDeviceType(double width) {
    if (width >= wide) return DeviceType.wide;
    if (width >= desktop) return DeviceType.desktop;
    if (width >= tablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  // ============================================
  // BOOLEAN HELPERS
  // ============================================
  static bool isMobile(double width) => width < tablet;
  static bool isTablet(double width) => width >= tablet && width < desktop;
  static bool isDesktop(double width) => width >= desktop && width < wide;
  static bool isWide(double width) => width >= wide;

  static bool isMobileType(DeviceType type) => type == DeviceType.mobile;
  static bool isTabletType(DeviceType type) => type == DeviceType.tablet;
  static bool isDesktopType(DeviceType type) => type == DeviceType.desktop;
  static bool isWideType(DeviceType type) => type == DeviceType.wide;

  static bool hasSidebar(DeviceType type) =>
      type == DeviceType.desktop || type == DeviceType.wide;

  static bool useGridLayout(DeviceType type) => type != DeviceType.mobile;
}

// ============================================
// EXTENSION - Easy access from BuildContext
// ============================================
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  DeviceType get deviceType => Responsive.getDeviceType(screenWidth);

  bool get isMobile => Responsive.isMobile(screenWidth);
  bool get isTablet => Responsive.isTablet(screenWidth);
  bool get isDesktop => Responsive.isDesktop(screenWidth);
  bool get isWide => Responsive.isWide(screenWidth);

  EdgeInsets get responsivePadding => Responsive.paddingAll(deviceType);
  int get gridColumns => Responsive.gridColumns(deviceType);
  double get maxContentWidth => Responsive.maxWidth(deviceType);
}

// ============================================
// RESPONSIVE BUILDER - Declarative widget
// ============================================
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType type) mobile;
  final Widget Function(BuildContext context, DeviceType type)? tablet;
  final Widget Function(BuildContext context, DeviceType type)? desktop;
  final Widget Function(BuildContext context, DeviceType type)? wide;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.wide,
  });

  @override
  Widget build(BuildContext context) {
    final type = context.deviceType;

    return switch (type) {
      DeviceType.mobile => mobile(context, type),
      DeviceType.tablet => (tablet ?? mobile)(context, type),
      DeviceType.desktop => (desktop ?? tablet ?? mobile)(context, type),
      DeviceType.wide => (wide ?? desktop ?? tablet ?? mobile)(context, type),
    };
  }
}

// ============================================
// LAYOUT BUILDER - Grid layout helper
// ============================================
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final columns = context.gridColumns;
    final type = context.deviceType;

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children.map((child) {
        final availableWidth = context.maxContentWidth;
        final childWidth =
            (availableWidth - (spacing * (columns - 1))) / columns;
        return SizedBox(
          width: childWidth,
          height: childWidth * childAspectRatio,
          child: child,
        );
      }).toList(),
    );
  }
}

// ============================================
// CONDITIONAL WIDGET - Show based on device
// ============================================
class ShowOn extends StatelessWidget {
  final Widget child;
  final bool showOnMobile;
  final bool showOnTablet;
  final bool showOnDesktop;
  final bool showOnWide;

  const ShowOn({
    super.key,
    required this.child,
    this.showOnMobile = false,
    this.showOnTablet = false,
    this.showOnDesktop = false,
    this.showOnWide = false,
  });

  @override
  Widget build(BuildContext context) {
    final type = context.deviceType;

    bool shouldShow = false;
    if (type == DeviceType.mobile) {
      shouldShow = showOnMobile;
    } else if (type == DeviceType.tablet) {
      shouldShow = showOnTablet;
    } else if (type == DeviceType.desktop) {
      shouldShow = showOnDesktop;
    } else if (type == DeviceType.wide) {
      shouldShow = showOnWide;
    }

    if (!shouldShow) return const SizedBox.shrink();
    return child;
  }
}

// ============================================
// PADDING BUILDER - Responsive padding wrapper
// ============================================
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;
  final EdgeInsets? widePadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
    this.widePadding,
  });

  @override
  Widget build(BuildContext context) {
    final type = context.deviceType;

    final padding = switch (type) {
      DeviceType.mobile => mobilePadding ?? Responsive.paddingAll(type),
      DeviceType.tablet =>
        tabletPadding ?? mobilePadding ?? Responsive.paddingAll(type),
      DeviceType.desktop =>
        desktopPadding ??
            tabletPadding ??
            mobilePadding ??
            Responsive.paddingAll(type),
      DeviceType.wide =>
        widePadding ??
            desktopPadding ??
            tabletPadding ??
            mobilePadding ??
            Responsive.paddingAll(type),
    };

    return Padding(padding: padding, child: child);
  }
}
