import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/utils/page_transitions.dart';
import 'core/utils/translations.dart';
import 'data/models/models.dart';
import 'data/repositories/repositories.dart';
import 'domain/providers/providers.dart';
import 'domain/providers/customization_provider.dart';

import 'presentation/screens/home/home_screen.dart' show HomeTab;
import 'presentation/screens/library/library_screen.dart' show LibraryTab;
import 'presentation/screens/courses/courses_screen.dart';
import 'presentation/screens/achievements/achievements_screen.dart';
import 'presentation/screens/community/community_screen.dart';
import 'presentation/screens/analytics/analytics_screen.dart';
import 'presentation/screens/help/help_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/editor/editor_screen.dart';
import 'presentation/screens/search/search_screen.dart';
import 'presentation/screens/notes/notes_screen.dart';
import 'presentation/screens/reminders/reminders_screen.dart';
import 'presentation/screens/timer/pomodoro_screen.dart';

class NavigateTabIntent extends Intent {
  final int tabIndex;
  const NavigateTabIntent(this.tabIndex);
}

class OpenPomodoroIntent extends Intent {
  const OpenPomodoroIntent();
}

class OpenSearchIntent extends Intent {
  const OpenSearchIntent();
}

class CreateItemIntent extends Intent {
  const CreateItemIntent();
}

class ToggleThemeIntent extends Intent {
  const ToggleThemeIntent();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await Hive.initFlutter('/home/gloom/.trackie/data');

  await Hive.openBox('settings');
  await Hive.openBox('items');
  final achievementsBox = await Hive.openBox('achievements');
  final profileBox = await Hive.openBox('profile');
  final communityBox = await Hive.openBox('community');
  final notesBox = await Hive.openBox('notes');
  final remindersBox = await Hive.openBox('reminders');
  final sessionsBox = await Hive.openBox('sessions');
  final domainsBox = await Hive.openBox('domains');

  final settingsRepo = SettingsRepository();
  await settingsRepo.init();
  final learningRepo = LearningRepository();
  await learningRepo.init();
  final achievementsRepo = AchievementsRepository();
  achievementsRepo.init(achievementsBox);
  final profileRepo = ProfileRepository();
  profileRepo.init(profileBox);
  final communityRepo = CommunityRepository();
  communityRepo.init(communityBox);
  final notesRepo = NotesRepository();
  notesRepo.init(notesBox);
  final remindersRepo = RemindersRepository();
  remindersRepo.init(remindersBox);
  final sessionsRepo = LearningSessionsRepository();
  sessionsRepo.init(sessionsBox);

  final customizationRepo = CustomizationRepository();
  await customizationRepo.init();

  runApp(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(settingsRepo),
        learningRepositoryProvider.overrideWithValue(learningRepo),
        achievementsRepositoryProvider.overrideWithValue(achievementsRepo),
        profileRepositoryProvider.overrideWithValue(profileRepo),
        communityRepositoryProvider.overrideWithValue(communityRepo),
        notesRepositoryProvider.overrideWithValue(notesRepo),
        remindersRepositoryProvider.overrideWithValue(remindersRepo),
        learningSessionsRepositoryProvider.overrideWithValue(sessionsRepo),
        customDomainsBoxProvider.overrideWithValue(domainsBox),
        customizationRepositoryProvider.overrideWithValue(customizationRepo),
      ],
      child: const AuraLearningApp(),
    ),
  );
}

class AuraLearningApp extends ConsumerWidget {
  const AuraLearningApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    // Update backward compatibility colors based on theme
    // No longer needed - using unified HTML spec colors
    final isDark =
        settings.theme == 'dark' ||
        (settings.theme == 'system' &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    AppColors.tertiary = isDark
        ? AppColors.darkTertiary
        : AppColors.lightTertiary;

    return MaterialApp(
      title: 'Aura Learning',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.theme == 'system'
          ? ThemeMode.system
          : settings.theme == 'dark'
          ? ThemeMode.dark
          : ThemeMode.light,
      themeAnimationDuration: const Duration(milliseconds: 400),
      themeAnimationCurve: Curves.easeInOut,
      home: settings.hasCompletedOnboarding
          ? const MainNavigation()
          : const OnboardingScreen(),
    );
  }
}

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const LibraryTab(),
    const CoursesScreen(),
    const AchievementsScreen(),
    const CommunityScreen(),
    const NotesScreen(),
    const RemindersScreen(),
    const AnalyticsScreen(),
    const HelpScreen(),
    const SettingsScreen(),
  ];

  List<String> _getTitles(WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    return [
      t.dashboard,
      t.library,
      t.courses,
      t.achievements,
      t.community,
      t.notes,
      t.reminders,
      'Analytics',
      t.help,
      t.settings,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titles = _getTitles(ref);

    if (isDesktop) {
      return _buildDesktopLayout(context, isDark, titles, settings);
    } else {
      return _buildMobileLayout(context, isDark);
    }
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    bool isDark,
    List<String> titles,
    AppSettings settings,
  ) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.digit1, control: true):
            const NavigateTabIntent(0),
        const SingleActivator(LogicalKeyboardKey.digit2, control: true):
            const NavigateTabIntent(1),
        const SingleActivator(LogicalKeyboardKey.digit3, control: true):
            const NavigateTabIntent(2),
        const SingleActivator(LogicalKeyboardKey.digit4, control: true):
            const NavigateTabIntent(3),
        const SingleActivator(LogicalKeyboardKey.digit5, control: true):
            const NavigateTabIntent(4),
        const SingleActivator(LogicalKeyboardKey.digit6, control: true):
            const NavigateTabIntent(5),
        const SingleActivator(LogicalKeyboardKey.digit7, control: true):
            const NavigateTabIntent(6),
        const SingleActivator(LogicalKeyboardKey.digit8, control: true):
            const NavigateTabIntent(7),
        const SingleActivator(LogicalKeyboardKey.digit9, control: true):
            const NavigateTabIntent(8),
        const SingleActivator(LogicalKeyboardKey.keyF, control: true):
            const OpenSearchIntent(),
        const SingleActivator(LogicalKeyboardKey.keyP, control: true):
            const OpenPomodoroIntent(),
        const SingleActivator(LogicalKeyboardKey.keyN, control: true):
            const CreateItemIntent(),
        const SingleActivator(LogicalKeyboardKey.keyT, control: true):
            const ToggleThemeIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          NavigateTabIntent: CallbackAction<NavigateTabIntent>(
            onInvoke: (intent) {
              setState(() => _currentIndex = intent.tabIndex);
              return null;
            },
          ),
          OpenSearchIntent: CallbackAction<OpenSearchIntent>(
            onInvoke: (_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
              return null;
            },
          ),
          OpenPomodoroIntent: CallbackAction<OpenPomodoroIntent>(
            onInvoke: (_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PomodoroScreen()),
              );
              return null;
            },
          ),
          CreateItemIntent: CallbackAction<CreateItemIntent>(
            onInvoke: (_) {
              _showCreateItemSheet(context);
              return null;
            },
          ),
          ToggleThemeIntent: CallbackAction<ToggleThemeIntent>(
            onInvoke: (_) {
              ref.read(settingsProvider.notifier).toggleTheme();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            body: Row(
              children: [
                Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceContainer.withValues(alpha: 0.4)
                        : AppColors.lightSurface.withValues(alpha: 0.6),
                    border: Border(
                      right: BorderSide(
                        color: isDark
                            ? AppColors.darkOutlineVariant.withValues(
                                alpha: 0.1,
                              )
                            : AppColors.lightOutlineVariant.withValues(
                                alpha: 0.5,
                              ),
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: _Sidebar(
                        currentIndex: _currentIndex,
                        onItemSelected: (index) =>
                            setState(() => _currentIndex = index),
                        isDark: isDark,
                        titles: titles,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(
                        title: titles[_currentIndex],
                        isDark: isDark,
                        locale: settings.locale,
                        onSearchTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchScreen(),
                          ),
                        ),
                        onCreateTap: () => _showCreateItemSheet(context),
                        onPomodoroTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PomodoroScreen(),
                          ),
                        ),
                        onNotificationsTap: () =>
                            _showNotificationsPanel(context),
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: _currentIndex,
                          children: _screens,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: _currentIndex < 5
                ? _DesktopFAB(
                    onPressed: () => _showCreateItemSheet(context),
                    isDark: isDark,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    final titles = _getTitles(ref);
    return Scaffold(
      // LIQUID NEBULA: Fade-through transition between tabs
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: IndexedStack(index: _currentIndex, children: _screens),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceContainer.withValues(alpha: 0.4)
              : AppColors.lightSurface.withValues(alpha: 0.6),
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppColors.darkOutlineVariant.withValues(alpha: 0.1)
                  : AppColors.lightOutlineVariant.withValues(alpha: 0.5),
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceContainer.withValues(alpha: 0.4)
                : AppColors.lightSurface.withValues(alpha: 0.6),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? AppColors.darkOutlineVariant.withValues(alpha: 0.1)
                    : AppColors.lightOutlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: NavigationBar(
                selectedIndex: _currentIndex < 4 ? _currentIndex : 0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                onDestinationSelected: (index) {
                  if (index < 4) {
                    setState(() => _currentIndex = index);
                  }
                },
                destinations: [
                  NavigationDestination(
                    icon: Icon(
                      Icons.dashboard_outlined,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                    selectedIcon: Icon(
                      Icons.dashboard,
                      color: AppColors.secondary,
                    ),
                    label: titles[0],
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.auto_stories_outlined,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                    selectedIcon: Icon(
                      Icons.auto_stories,
                      color: AppColors.secondary,
                    ),
                    label: titles[1],
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.school_outlined,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                    selectedIcon: Icon(
                      Icons.school,
                      color: AppColors.secondary,
                    ),
                    label: titles[2],
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.military_tech_outlined,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                    selectedIcon: Icon(
                      Icons.military_tech,
                      color: AppColors.secondary,
                    ),
                    label: titles[3],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _currentIndex < 4
          ? _EnhancedFAB(
              onPressed: () => _showCreateItemSheet(context),
              isDark: isDark,
            )
          : null,
    );
  }

  void _showCreateItemSheet(BuildContext context) {
    Navigator.push(context, SlidePageRoute(page: const EditorScreen()));
  }

  void _showNotificationsPanel(BuildContext context) {
    final panelIsDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: panelIsDark
              ? AppColors.darkSurfaceContainer
              : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: panelIsDark
                        ? AppColors.darkOnSurface
                        : AppColors.lightOnSurface,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: panelIsDark
                        ? AppColors.darkOnSurfaceVariant
                        : AppColors.lightOnSurfaceVariant,
                  ),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.shadcnPrimary.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.shadcnPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Push notifications are currently enabled. Configure in Settings > Notifications.',
                      style: TextStyle(
                        color: panelIsDark
                            ? AppColors.darkOnSurface
                            : AppColors.lightOnSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _currentIndex = 8); // Settings index
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.shadcnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Open Settings',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _Sidebar extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onItemSelected;
  final bool isDark;
  final List<String> titles;

  const _Sidebar({
    required this.currentIndex,
    required this.onItemSelected,
    required this.isDark,
    required this.titles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Column(
      children: [
        const SizedBox(height: 24),
        // Logo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ShaderMask(
            shaderCallback: (bounds) =>
                (isDark
                        ? AppColors.liquidGradient
                        : LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDim],
                          ))
                    .createShader(bounds),
            child: const Text(
              'Aura Learning',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Level ${profile.level} - ${profile.xp} XP',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.lightOnSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Navigation Items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _SidebarItem(
                icon: Icons.dashboard,
                label: titles[0],
                isSelected: currentIndex == 0,
                onTap: () => onItemSelected(0),
                isDark: isDark,
              ),
              _SidebarItem(
                icon: Icons.auto_stories,
                label: titles[1],
                isSelected: currentIndex == 1,
                onTap: () => onItemSelected(1),
                isDark: isDark,
              ),
              _SidebarItem(
                icon: Icons.school,
                label: titles[2],
                isSelected: currentIndex == 2,
                onTap: () => onItemSelected(2),
                isDark: isDark,
              ),
              _SidebarItem(
                icon: Icons.military_tech,
                label: titles[3],
                isSelected: currentIndex == 3,
                onTap: () => onItemSelected(3),
                isDark: isDark,
              ),
              _SidebarItem(
                icon: Icons.groups,
                label: titles[4],
                isSelected: currentIndex == 4,
                onTap: () => onItemSelected(4),
                isDark: isDark,
              ),
              _SidebarItem(
                icon: Icons.note_alt,
                label: titles[5],
                isSelected: currentIndex == 5,
                onTap: () => onItemSelected(5),
                isDark: isDark,
              ),
              _SidebarItem(
                icon: Icons.notifications,
                label: titles[6],
                isSelected: currentIndex == 6,
                onTap: () => onItemSelected(6),
                isDark: isDark,
              ),
              _SidebarItem(
                icon: Icons.help_outline,
                label: titles[7],
                isSelected: currentIndex == 7,
                onTap: () => onItemSelected(7),
                isDark: isDark,
              ),
            ],
          ),
        ),

        // Settings
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _SidebarItem(
            icon: Icons.settings,
            label: titles[8],
            isSelected: currentIndex == 8,
            onTap: () => onItemSelected(8),
            isDark: isDark,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;
    final secondaryColor = widget.isDark
        ? AppColors.darkSecondary
        : AppColors.lightSecondary;
    final onSurfaceVariant = widget.isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;

    final activeColor = widget.isSelected ? secondaryColor : primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            // ignore: deprecated_member_use
            transform: Matrix4.identity()
              // ignore: deprecated_member_use
              ..translate(
                _isHovered && !widget.isSelected ? 4.0 : 0.0,
                0.0,
                0.0,
              ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? activeColor.withValues(alpha: 0.1)
                  : _isHovered
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: widget.isSelected
                  ? Border(left: BorderSide(color: activeColor, width: 3))
                  : null,
              boxShadow: _isHovered && !widget.isSelected
                  ? [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: widget.isSelected ? activeColor : onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: widget.isSelected ? activeColor : onSurfaceVariant,
                    letterSpacing: 0.05,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final bool isDark;
  final String locale;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCreateTap;
  final VoidCallback? onPomodoroTap;
  final VoidCallback? onNotificationsTap;

  const _TopBar({
    required this.title,
    required this.isDark,
    required this.locale,
    this.onSearchTap,
    this.onCreateTap,
    this.onPomodoroTap,
    this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    final onSurfaceVariant = isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceContainer.withValues(alpha: 0.3)
            : AppColors.lightSurface.withValues(alpha: 0.4),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.darkOutlineVariant.withValues(alpha: 0.1)
                : AppColors.lightOutlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: onSurface,
            ),
          ),
          const Spacer(),
          // Search
          Container(
            width: 280,
            height: 38,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(Icons.search, size: 18, color: onSurfaceVariant),
                const SizedBox(width: 8),
                Text(
                  'Search...',
                  style: TextStyle(fontSize: 13, color: onSurfaceVariant),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Ctrl+K',
                    style: TextStyle(fontSize: 10, color: onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Pomodoro
          _GlassIconButton(
            icon: Icons.timer_outlined,
            onTap: onPomodoroTap,
            tooltip: 'Pomodoro (Ctrl+P)',
            isDark: isDark,
          ),
          // Notifications
          _GlassIconButton(
            icon: Icons.notifications_outlined,
            onTap: onNotificationsTap,
            tooltip: 'Notifications',
            isDark: isDark,
          ),
          // Language Toggle
          Consumer(
            builder: (context, ref, _) {
              return _GlassIconButton(
                icon: Icons.translate,
                onTap: () {
                  ref.read(settingsProvider.notifier).setLocale('en');
                },
                tooltip: 'Language: English',
                isDark: isDark,
              );
            },
          ),
          // Profile
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDark ? AppColors.brandGradient : null,
              color: isDark ? null : AppColors.lightPrimaryContainer,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'U',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// LIQUID NEBULA: Enhanced FAB with neon glow effect
class _EnhancedFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isDark;

  const _EnhancedFAB({required this.onPressed, required this.isDark});

  @override
  State<_EnhancedFAB> createState() => _EnhancedFABState();
}

class _EnhancedFABState extends State<_EnhancedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isPressed ? 0.92 : 1.0,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
                ),
                shape: BoxShape.circle,
                // LIQUID NEBULA: Enhanced neon glow
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonPurpleStrong.withValues(
                      alpha: 0.5 * _glowAnimation.value,
                    ),
                    blurRadius: 25 * _glowAnimation.value,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.neonCyan.withValues(
                      alpha: 0.3 * _glowAnimation.value,
                    ),
                    blurRadius: 35 * _glowAnimation.value,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: AppColors.shadcnPrimary.withValues(
                      alpha: 0.4 * _glowAnimation.value,
                    ),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          );
        },
      ),
    );
  }
}

// LIQUID NEBULA: Desktop FAB with neon glow
class _GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool isDark;

  const _GlassIconButton({
    required this.icon,
    this.onTap,
    this.tooltip,
    required this.isDark,
  });

  @override
  State<_GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<_GlassIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final onSurfaceVariant = widget.isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.secondary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered
                  ? AppColors.secondary.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: -5,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: _isHovered ? AppColors.secondary : onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _DesktopFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isDark;

  const _DesktopFAB({required this.onPressed, required this.isDark});

  @override
  State<_DesktopFAB> createState() => _DesktopFABState();
}

class _DesktopFABState extends State<_DesktopFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isHovered ? 1.05 : 1.0,
            child: FloatingActionButton(
              key: const ValueKey('main_fab'),
              heroTag: 'main_fab_hero',
              onPressed: widget.onPressed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                      widget.isDark
                          ? AppColors.darkSecondary
                          : AppColors.lightSecondary,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonPurple.withValues(
                        alpha: 0.4 * _glowAnimation.value,
                      ),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: _isHovered ? 2 : 0,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppColors.neonCyan.withValues(
                        alpha: 0.2 * _glowAnimation.value,
                      ),
                      blurRadius: 30 * _glowAnimation.value,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: widget.isDark
                      ? AppColors.darkOnPrimary
                      : AppColors.lightOnPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
