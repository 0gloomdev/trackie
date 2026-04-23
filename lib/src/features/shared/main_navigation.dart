import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/page_transitions.dart';
import '../../core/utils/translations.dart';
import '../achievements/presentation/achievements_screen.dart';
import '../community/presentation/community_screen.dart';
import '../editor/presentation/editor_screen.dart';
import '../help/presentation/help_screen.dart';
import '../home/presentation/home_screen.dart';
import '../learning/presentation/courses_screen.dart';
import '../library/presentation/library_screen.dart';
import '../notes/presentation/notes_screen.dart';
import '../notes/presentation/reminders/reminders_screen.dart';
import '../pomodoro/presentation/pomodoro_screen.dart';
import '../progress/presentation/analytics/analytics_screen.dart';
import '../search/presentation/search_screen.dart';
import '../settings/presentation/settings_screen.dart';
import 'main_sidebar.dart';
import 'main_top_bar.dart';
import 'main_fab.dart';
import '../../services/models/models.dart';
import 'providers/drift_providers.dart';

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
    final settingsAsync = ref.watch(settingsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titles = _getTitles(ref);

    if (isDesktop) {
      return settingsAsync.when(
        data: (settings) =>
            _buildDesktopLayout(context, isDark, titles, settings),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      );
    } else {
      return _buildMobileLayout(context, isDark);
    }
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    bool isDark,
    List<String> titles,
    AppSettingsTableData? settings,
  ) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            currentIndex: _currentIndex,
            onItemSelected: (index) => setState(() => _currentIndex = index),
            isDark: isDark,
            titles: titles,
          ),
          Expanded(
            child: Column(
              children: [
                TopBar(
                  title: titles[_currentIndex],
                  isDark: isDark,
                  locale: settings.locale,
                  onSearchTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  ),
                  onCreateTap: () => Navigator.push(
                    context,
                    SlidePageRoute(page: const EditorScreen()),
                  ),
                  onPomodoroTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PomodoroScreen()),
                  ),
                ),
                Expanded(
                  child: IndexedStack(index: _currentIndex, children: _screens),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _currentIndex < 5
          ? DesktopFAB(
              onPressed: () => Navigator.push(
                context,
                SlidePageRoute(page: const EditorScreen()),
              ),
              isDark: isDark,
            )
          : null,
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    final titles = _getTitles(ref);
    return Scaffold(
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex < 4 ? _currentIndex : 0,
        onDestinationSelected: (index) {
          if (index < 4) {
            setState(() => _currentIndex = index);
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: titles[0],
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: titles[1],
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: titles[2],
          ),
          NavigationDestination(
            icon: Icon(Icons.military_tech_outlined),
            selectedIcon: Icon(Icons.military_tech),
            label: titles[3],
          ),
        ],
      ),
      floatingActionButton: _currentIndex < 4
          ? EnhancedFAB(
              onPressed: () => Navigator.push(
                context,
                SlidePageRoute(page: const EditorScreen()),
              ),
              isDark: isDark,
            )
          : null,
    );
  }
}
