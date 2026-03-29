import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/utils/page_transitions.dart';
import 'core/utils/translations.dart';
import 'data/repositories/repositories.dart';
import 'domain/providers/providers.dart';

import 'presentation/screens/home/home_screen.dart' show HomeTab;
import 'presentation/screens/library/library_screen.dart' show LibraryTab;
import 'presentation/screens/courses/courses_screen.dart';
import 'presentation/screens/achievements/achievements_screen.dart';
import 'presentation/screens/community/community_screen.dart';
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

  final settingsBox = await Hive.openBox('settings');
  final itemsBox = await Hive.openBox('items');
  final achievementsBox = await Hive.openBox('achievements');
  final profileBox = await Hive.openBox('profile');
  final communityBox = await Hive.openBox('community');
  final notesBox = await Hive.openBox('notes');
  final remindersBox = await Hive.openBox('reminders');
  final sessionsBox = await Hive.openBox('sessions');

  final settingsRepo = SettingsRepository();
  settingsRepo.init(settingsBox);
  final learningRepo = LearningRepository();
  learningRepo.init(itemsBox);
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
    final isDark =
        settings.theme == 'dark' ||
        (settings.theme == 'system' &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    AppColors.primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    AppColors.secondary = isDark
        ? AppColors.darkSecondary
        : AppColors.lightSecondary;
    AppColors.surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    AppColors.background = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    AppColors.onSurface = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    AppColors.onPrimary = isDark
        ? AppColors.darkOnPrimary
        : AppColors.lightOnPrimary;
    AppColors.error = isDark ? AppColors.darkError : AppColors.lightError;
    AppColors.primaryContainer = isDark
        ? AppColors.darkPrimaryContainer
        : AppColors.lightPrimaryContainer;
    AppColors.onSurfaceVariant = isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;
    AppColors.surfaceContainerHighest = isDark
        ? AppColors.darkSurfaceContainerHighest
        : AppColors.lightSurfaceContainerHighest;
    AppColors.outlineVariant = isDark
        ? AppColors.darkOutlineVariant
        : AppColors.lightOutlineVariant;
    AppColors.outline = isDark ? AppColors.darkOutline : AppColors.lightOutline;
    AppColors.surfaceContainer = isDark
        ? AppColors.darkSurfaceContainer
        : AppColors.lightSurfaceContainer;
    AppColors.surfaceContainerLow = isDark
        ? AppColors.darkSurfaceContainerLow
        : AppColors.lightSurfaceContainerLow;
    AppColors.surfaceContainerHigh = isDark
        ? AppColors.darkSurfaceContainerHigh
        : AppColors.lightSurfaceContainerHigh;
    AppColors.surfaceBright = isDark
        ? AppColors.darkSurfaceBright
        : AppColors.lightSurfaceBright;
    AppColors.surfaceDim = isDark
        ? AppColors.darkSurfaceDim
        : AppColors.lightSurfaceDim;
    AppColors.surfaceTint = isDark
        ? AppColors.darkSurfaceTint
        : AppColors.lightSurfaceTint;
    AppColors.inverseSurface = isDark
        ? AppColors.darkInverseSurface
        : AppColors.lightInverseSurface;
    AppColors.inverseOnSurface = isDark
        ? AppColors.darkInverseOnSurface
        : AppColors.lightInverseOnSurface;
    AppColors.inversePrimary = isDark
        ? AppColors.darkInversePrimary
        : AppColors.lightInversePrimary;
    AppColors.onError = isDark ? AppColors.darkOnError : AppColors.lightOnError;
    AppColors.errorContainer = isDark
        ? AppColors.darkErrorContainer
        : AppColors.lightErrorContainer;
    AppColors.onErrorContainer = isDark
        ? AppColors.darkOnErrorContainer
        : AppColors.lightOnErrorContainer;
    AppColors.onPrimaryContainer = isDark
        ? AppColors.darkOnPrimaryContainer
        : AppColors.lightOnPrimaryContainer;
    AppColors.onSecondaryContainer = isDark
        ? AppColors.darkOnSecondaryContainer
        : AppColors.lightOnSecondaryContainer;
    AppColors.onTertiaryContainer = isDark
        ? AppColors.darkOnTertiaryContainer
        : AppColors.lightOnTertiaryContainer;
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
      t.help,
      t.settings,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titles = _getTitles(ref);

    if (isDesktop) {
      return _buildDesktopLayout(context, isDark, titles);
    } else {
      return _buildMobileLayout(context, isDark);
    }
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    bool isDark,
    List<String> titles,
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
                        ? AppColors.darkSurfaceContainer.withValues(alpha: 0.6)
                        : AppColors.lightSurface,
                    border: Border(
                      right: BorderSide(
                        color: isDark
                            ? AppColors.darkOutlineVariant.withValues(
                                alpha: 0.2,
                              )
                            : AppColors.lightOutlineVariant,
                      ),
                    ),
                  ),
                  child: _Sidebar(
                    currentIndex: _currentIndex,
                    onItemSelected: (index) =>
                        setState(() => _currentIndex = index),
                    isDark: isDark,
                    titles: titles,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(
                        title: titles[_currentIndex],
                        isDark: isDark,
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
                ? FloatingActionButton(
                    key: const ValueKey('main_fab'),
                    heroTag: 'main_fab_hero',
                    onPressed: () => _showCreateItemSheet(context),
                    backgroundColor: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    child: Icon(
                      Icons.add,
                      color: isDark
                          ? AppColors.darkOnPrimary
                          : AppColors.lightOnPrimary,
                    ),
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
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceContainer.withValues(alpha: 0.9)
              : AppColors.lightSurface,
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppColors.darkOutlineVariant.withValues(alpha: 0.2)
                  : AppColors.lightOutlineVariant,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex < 4 ? _currentIndex : 0,
          onDestinationSelected: (index) {
            if (index < 4) {
              setState(() => _currentIndex = index);
            }
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard),
              label: titles[0],
            ),
            NavigationDestination(
              icon: const Icon(Icons.auto_stories_outlined),
              selectedIcon: const Icon(Icons.auto_stories),
              label: titles[1],
            ),
            NavigationDestination(
              icon: const Icon(Icons.school_outlined),
              selectedIcon: const Icon(Icons.school),
              label: titles[2],
            ),
            NavigationDestination(
              icon: const Icon(Icons.military_tech_outlined),
              selectedIcon: const Icon(Icons.military_tech),
              label: titles[3],
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex < 4
          ? Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    isDark
                        ? AppColors.darkPrimaryContainer
                        : AppColors.lightPrimaryContainer,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton(
                key: const ValueKey('mobile_fab'),
                heroTag: 'mobile_fab_hero',
                onPressed: () => _showCreateItemSheet(context),
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            )
          : null,
    );
  }

  void _showCreateItemSheet(BuildContext context) {
    Navigator.push(context, SlidePageRoute(page: const EditorScreen()));
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
                        : const LinearGradient(
                            colors: [
                              AppColors.lightPrimary,
                              AppColors.lightPrimaryDim,
                            ],
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
            'Nivel ${profile.level} - ${profile.xp} XP',
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
  final VoidCallback? onSearchTap;
  final VoidCallback? onCreateTap;
  final VoidCallback? onPomodoroTap;

  const _TopBar({
    required this.title,
    required this.isDark,
    this.onSearchTap,
    this.onCreateTap,
    this.onPomodoroTap,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    final onSurfaceVariant = isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;
    final surfaceContainer = isDark
        ? AppColors.darkSurfaceContainer
        : AppColors.lightSurface;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: surfaceContainer.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.darkOutlineVariant.withValues(alpha: 0.1)
                : AppColors.lightOutlineVariant.withValues(alpha: 0.2),
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
          GestureDetector(
            onTap: onSearchTap,
            child: Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceContainerHighest.withValues(
                        alpha: 0.3,
                      )
                    : AppColors.lightSurfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, size: 20, color: onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    'Buscar...',
                    style: TextStyle(fontSize: 14, color: onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Pomodoro
          IconButton(
            icon: Icon(Icons.timer_outlined, color: onSurfaceVariant),
            onPressed: onPomodoroTap,
            tooltip: 'Pomodoro (Ctrl+P)',
          ),
          // Notifications
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: onSurfaceVariant),
            onPressed: () {},
          ),
          // Language Toggle
          Consumer(
            builder: (context, ref, _) {
              final settings = ref.watch(settingsProvider);
              return IconButton(
                icon: Icon(Icons.translate, color: onSurfaceVariant),
                onPressed: () {
                  final newLocale = settings.locale == 'en' ? 'es' : 'en';
                  ref.read(settingsProvider.notifier).setLocale(newLocale);
                },
                tooltip: settings.locale == 'en'
                    ? 'Switch to Spanish'
                    : 'Cambiar a inglés',
              );
            },
          ),
          // Profile
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.darkPrimaryContainer
                  : AppColors.lightPrimaryContainer,
            ),
            child: Center(
              child: Text(
                'U',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkOnPrimaryContainer
                      : AppColors.lightOnPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
