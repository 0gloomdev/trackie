# UI Improvement Plan - Mobile & Desktop

## Overview
This document outlines the UI improvement strategy for the Trackie app across mobile and desktop platforms, following the Liquid Nebula Design System.

---

## 1. Mobile Optimizations

### 1.1 Layout Adjustments
- **Single Column Layout**: Replace Row-based layouts with Column on screens < 600px
- **Bottom Navigation**: Use bottom nav bar for primary tabs on mobile
- **Full-width Cards**: Cards should span full width with 16px margins
- **Stacked Stats**: Convert horizontal stat grids to 2x2 or vertical stacks

### 1.2 Touch Targets
- Minimum tap target: 44x44px (Material guideline)
- Increase spacing between interactive elements to 12px minimum
- Add haptic feedback on key interactions (toggle switches, buttons)

### 1.3 Navigation
- Replace sidebar with bottom navigation bar or drawer
- Use modal bottom sheets for dialogs and forms
- Implement swipe gestures for list item actions

### 1.4 Performance
- Use `ListView.builder` for all scrollable lists
- Implement lazy loading for large datasets
- Cache chart data to avoid rebuilds
- Use `const` constructors wherever possible

### 1.5 Specific Screen Improvements

#### Home Screen
- Stack stat cards in 2x2 grid instead of horizontal row
- Reduce hero section text size from 42px to 32px
- Make weekly chart scrollable if data exceeds viewport

#### Settings Screen
- Convert sidebar+content layout to single column with segmented tabs
- Use bottom sheet for theme picker
- Simplify custom domains list with expandable cards

#### Analytics Screen
- Stack charts vertically instead of side-by-side
- Use full-width stat cards
- Simplify heat map for small screens

---

## 2. Desktop Enhancements

### 2.1 Layout Adjustments
- **Multi-column Layouts**: Use Row-based layouts on screens >= 1024px
- **Sidebar Navigation**: Persistent sidebar with icons + labels
- **Max Content Width**: Cap content at 1200px for readability
- **Responsive Grid**: Use GridView with dynamic crossAxisCount

### 2.2 Keyboard Shortcuts
- `Ctrl+N`: New item
- `Ctrl+S`: Save
- `Ctrl+F`: Search
- `Ctrl+P`: Pomodoro timer
- `Ctrl+,`: Settings
- `Esc`: Close dialogs

### 2.3 Hover Effects
- Add hover states to all interactive elements
- Card elevation on hover
- Subtle background color change on list items
- Tooltip on icon buttons

### 2.4 Specific Screen Improvements

#### Settings Screen
- Keep sidebar + content split layout (current implementation)
- Add search within settings
- Use tabs for sub-sections within each category

#### Analytics Screen
- Side-by-side chart layout (current implementation)
- Add date range picker
- Export chart as image functionality

#### Home Screen
- 4-column stat grid (current implementation)
- Add quick action floating action button
- Recent items horizontal scroll with snap

---

## 3. Responsive Breakpoints

```dart
class Breakpoints {
  static const double mobile = 600;   // < 600px: Mobile
  static const double tablet = 1024;  // 600-1024px: Tablet
  // >= 1024px: Desktop
}
```

### Implementation Pattern
```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isMobile = constraints.maxWidth < Breakpoints.mobile;
    final isDesktop = constraints.maxWidth >= Breakpoints.tablet;
    
    return isDesktop ? DesktopLayout() : MobileLayout();
  },
)
```

---

## 4. Liquid Nebula Design System Compliance

### 4.1 Color Usage
- Primary (#ba9eff): Main actions, active states, gradients
- Secondary (#3adffa): Accents, highlights, secondary actions
- Tertiary (#ff97b5): Warnings, special highlights
- Success (#22C55E): Positive states, completion
- Destructive (#EF4444): Delete actions, errors

### 4.2 Typography
- Hero titles: 40px, w900, -1 letter spacing (desktop)
- Section titles: 18px, bold
- Body text: 14px, regular
- Captions: 12px, medium

### 4.3 Spacing Scale
- 4px: Tight spacing
- 8px: Standard gap
- 12px: Section gap
- 16px: Card padding
- 24px: Page padding
- 32px: Major section gap

### 4.4 Border Radius
- Small (buttons, inputs): 8px
- Medium (cards): 12px
- Large (modals, sheets): 16px
- Circle (avatars, badges): 50%

### 4.5 Animations
- Duration: 200-400ms
- Curves: Curves.easeOut for entrance, Curves.easeInOut for transitions
- Stagger delays: 50-100ms between elements
- Avoid animations in compact mode

---

## 5. Priority Implementation Order

1. **High Priority**
   - Mobile responsive settings screen
   - Bottom navigation for mobile
   - Touch target sizing

2. **Medium Priority**
   - Keyboard shortcuts for desktop
   - Hover effects
   - Responsive breakpoints system

3. **Low Priority**
   - Export functionality
   - Advanced animations
   - Haptic feedback

---

## 6. Files to Modify

### Core
- `lib/core/responsive/responsive.dart` - Breakpoint utilities
- `lib/core/widgets/responsive_layout.dart` - Responsive wrapper widget

### Screens
- `lib/presentation/screens/settings/settings_screen.dart` - Mobile layout
- `lib/presentation/screens/home/home_screen.dart` - Mobile optimizations
- `lib/presentation/screens/analytics/analytics_screen.dart` - Mobile layout

### Navigation
- `lib/presentation/widgets/mobile_nav_bar.dart` - New mobile nav component
- `lib/presentation/widgets/desktop_sidebar.dart` - New desktop sidebar component
