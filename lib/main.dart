import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_glass.dart';
import 'data/repositories/repositories.dart';
import 'domain/providers/providers.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/library/library_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await Hive.initFlutter();

  final learningRepo = LearningRepository();
  final categoryRepo = CategoryRepository();
  final tagRepo = TagRepository();
  final settingsRepo = SettingsRepository();

  await learningRepo.init();
  await categoryRepo.init();
  await tagRepo.init();
  await settingsRepo.init();

  runApp(
    ProviderScope(
      overrides: [
        learningRepositoryProvider.overrideWithValue(learningRepo),
        categoryRepositoryProvider.overrideWithValue(categoryRepo),
        tagRepositoryProvider.overrideWithValue(tagRepo),
        settingsRepositoryProvider.overrideWithValue(settingsRepo),
      ],
      child: const TrackieApp(),
    ),
  );
}

class TrackieApp extends ConsumerWidget {
  const TrackieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    ThemeMode themeMode;
    switch (settings.theme) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    return MaterialApp(
      title: 'Trackie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: settings.showOnboarding
          ? const OnboardingScreen()
          : const MainScreen(),
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    LibraryTab(),
    StatsTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = constraints.maxWidth > 900;
        return isLarge ? _buildDesktop() : _buildMobile();
      },
    );
  }

  Widget _buildDesktop() {
    return Scaffold(
      body: Row(
        children: [
          _Sidebar(
            currentIndex: _currentIndex,
            onItemSelected: (i) => setState(() => _currentIndex = i),
          ),
          Expanded(
            child: IndexedStack(index: _currentIndex, children: _screens),
          ),
        ],
      ),
    );
  }

  Widget _buildMobile() {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            height: 70,
            indicatorColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.2),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.dashboard_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                selectedIcon: Icon(
                  Icons.dashboard,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Panel',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.local_library_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                selectedIcon: Icon(
                  Icons.local_library,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Biblioteca',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.bar_chart_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                selectedIcon: Icon(
                  Icons.bar_chart,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Stats',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.settings_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                selectedIcon: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Ajustes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;
  const _Sidebar({required this.currentIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.95),
        border: Border(
          right: BorderSide(color: cs.primary.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) => LinearGradient(
                    colors: [cs.primary, cs.secondary],
                  ).createShader(b),
                  child: const Text(
                    'Trackie',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'GESTIÓN DE APRENDIZAJE',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _SidebarItem(
            icon: Icons.dashboard,
            label: 'Panel',
            isSelected: currentIndex == 0,
            onTap: () => onItemSelected(0),
          ),
          _SidebarItem(
            icon: Icons.local_library,
            label: 'Biblioteca',
            isSelected: currentIndex == 1,
            onTap: () => onItemSelected(1),
          ),
          _SidebarItem(
            icon: Icons.bar_chart,
            label: 'Estadísticas',
            isSelected: currentIndex == 2,
            onTap: () => onItemSelected(2),
          ),
          _SidebarItem(
            icon: Icons.settings,
            label: 'Ajustes',
            isSelected: currentIndex == 3,
            onTap: () => onItemSelected(3),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: _SidebarItem(
              icon: Icons.help_outline,
              label: 'Ayuda',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: isSelected
              ? Border(right: BorderSide(color: context.primary, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? context.primary : context.onSurfaceVariant,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? context.primary : context.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsTab extends ConsumerWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statisticsProvider);
    final items = ref.watch(learningItemsProvider);
    final byType = stats['byType'] as Map<String, int>;
    final total = items.length;
    final completed = stats['completed'] as int;
    final inProgress = stats['inProgress'] as int;
    final pending = stats['pending'] as int;
    final completionRate = total > 0 ? (completed / total * 100).round() : 0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 100,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.9),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ).createShader(bounds),
                child: const Text(
                  'ESTADÍSTICAS',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (items.isEmpty)
                  _EmptyStats()
                else ...[
                  // Hero Stats
                  _StatsHeroSection(
                    completionRate: completionRate,
                    total: total,
                    completed: completed,
                    inProgress: inProgress,
                  ),

                  const SizedBox(height: 24),

                  // Distribution by Type
                  _SectionLabel(label: 'DISTRIBUCIÓN POR TIPO'),
                  const SizedBox(height: 12),
                  ...byType.entries.map((e) {
                    final typeColor = _getTypeColor(context, e.key);
                    final percentage = total > 0
                        ? (e.value / total * 100).round()
                        : 0;
                    return _TypeDistributionBar(
                      type: e.key,
                      count: e.value,
                      percentage: percentage,
                      color: typeColor,
                    );
                  }),

                  const SizedBox(height: 24),

                  // Status Distribution
                  _SectionLabel(label: 'DISTRIBUCIÓN POR ESTADO'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatusCard(
                          label: 'Completados',
                          value: '$completed',
                          color: AppColors.secondary,
                          icon: Icons.check_circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatusCard(
                          label: 'En Progreso',
                          value: '$inProgress',
                          color: AppColors.tertiary,
                          icon: Icons.play_circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatusCard(
                          label: 'Pendientes',
                          value: '$pending',
                          color: AppColors.onSurfaceVariant,
                          icon: Icons.schedule,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(BuildContext context, String type) {
    final tc = context.themeColors;
    switch (type) {
      case 'course':
        return tc.primary;
      case 'book':
        return const Color(0xFF8B4513);
      case 'pdf':
        return const Color(0xFFE53935);
      case 'video':
        return const Color(0xFFFF5722);
      case 'audio':
        return tc.secondary;
      case 'article':
        return const Color(0xFF9C27B0);
      default:
        return tc.primaryContainer;
    }
  }
}

class _StatsHeroSection extends StatelessWidget {
  final int completionRate;
  final int total;
  final int completed;
  final int inProgress;

  const _StatsHeroSection({
    required this.completionRate,
    required this.total,
    required this.completed,
    required this.inProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TASA DE COMPLETADO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '$completionRate%',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionRate / 100,
              minHeight: 10,
              backgroundColor: AppColors.surfaceContainerHighest,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _HeroStat(
                label: 'Total',
                value: '$total',
                color: AppColors.onSurface,
              ),
              Container(width: 1, height: 30, color: AppColors.outlineVariant),
              _HeroStat(
                label: 'Completados',
                value: '$completed',
                color: AppColors.secondary,
              ),
              Container(width: 1, height: 30, color: AppColors.outlineVariant),
              _HeroStat(
                label: 'En Progreso',
                value: '$inProgress',
                color: AppColors.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _HeroStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: context.onSurfaceVariant,
      ),
    );
  }
}

class _TypeDistributionBar extends StatelessWidget {
  final String type;
  final int count;
  final int percentage;
  final Color color;

  const _TypeDistributionBar({
    required this.type,
    required this.count,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    type.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                '$count ($percentage%)',
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 6,
              backgroundColor: context.surfaceContainerHighest,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatusCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: context.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmptyStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bar_chart,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sin datos aún',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Agrega elementos a tu biblioteca\npara ver estadísticas',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 100,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.9),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ).createShader(bounds),
                child: const Text(
                  'AJUSTES',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Profile Section
                _ProfileHeader(),

                const SizedBox(height: 24),

                // Appearance
                _SectionLabel(label: 'APARIENCIA'),
                const SizedBox(height: 12),
                _SettingsList(
                  children: [
                    _ThemeSelector(currentTheme: settings.theme, ref: ref),
                    _ViewSelector(currentView: settings.defaultView, ref: ref),
                  ],
                ),

                const SizedBox(height: 24),

                // Data
                _SectionLabel(label: 'DATOS'),
                const SizedBox(height: 12),
                _SettingsList(
                  children: [
                    _SettingsTile(
                      icon: Icons.download,
                      title: 'Exportar datos',
                      subtitle: 'Descargar como JSON',
                      color: AppColors.secondary,
                      onTap: () => _exportData(ref),
                    ),
                    _SettingsTile(
                      icon: Icons.upload,
                      title: 'Importar datos',
                      subtitle: 'Cargar desde JSON',
                      color: AppColors.primary,
                      onTap: () => _importData(ref),
                    ),
                    _SettingsTile(
                      icon: Icons.delete_outline,
                      title: 'Borrar todos los datos',
                      subtitle: 'Eliminar permanentemente',
                      color: AppColors.error,
                      onTap: () => _showDeleteConfirmation(context, ref),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // About
                _SectionLabel(label: 'ACERCA DE'),
                const SizedBox(height: 12),
                _SettingsList(
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final tapCount = ref.watch(versionTapProvider);
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(versionTapProvider.notifier)
                                .update((state) => state + 1);
                            if (ref.read(versionTapProvider) >= 5) {
                              ref
                                  .read(settingsProvider.notifier)
                                  .completeOnboarding();
                              ref
                                  .read(versionTapProvider.notifier)
                                  .update((state) => 0);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Modo desarrollador activado'),
                                ),
                              );
                            }
                          },
                          child: _SettingsTile(
                            icon: Icons.info_outline,
                            title: 'Versión',
                            subtitle: '1.0.0',
                            color: AppColors.onSurfaceVariant,
                            onTap: () {},
                          ),
                        );
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.code,
                      title: 'Código fuente',
                      subtitle: 'GitHub',
                      color: AppColors.onSurfaceVariant,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.help_outline,
                      title: 'Ayuda',
                      subtitle: 'Guía de uso',
                      color: AppColors.onSurfaceVariant,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _exportData(WidgetRef ref) {
    // Export implementation
  }

  void _importData(WidgetRef ref) {
    // Import implementation
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Borrar todos los datos'),
        content: const Text('¿Estás seguro? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              // Delete all items
              final items = ref.read(learningItemsProvider);
              for (final item in items) {
                ref.read(learningItemsProvider.notifier).delete(item.id);
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Todos los datos eliminados')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(Icons.person, color: AppColors.primary, size: 30),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Usuario',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Aprendiz de Trackie',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.edit,
              color: AppColors.onSurfaceVariant,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  final List<Widget> children;
  const _SettingsList({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.glassBorder.withValues(alpha: 0.08),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: AppColors.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.onSurfaceVariant,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final String currentTheme;
  final WidgetRef ref;

  const _ThemeSelector({required this.currentTheme, required this.ref});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.palette, color: AppColors.primary, size: 20),
      ),
      title: const Text(
        'Tema',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: AppColors.onSurface,
        ),
      ),
      subtitle: Row(
        children: [
          _ThemeOption(
            label: 'Sistema',
            isSelected: currentTheme == 'system',
            onTap: () => ref.read(settingsProvider.notifier).setTheme('system'),
          ),
          const SizedBox(width: 8),
          _ThemeOption(
            label: 'Claro',
            isSelected: currentTheme == 'light',
            onTap: () => ref.read(settingsProvider.notifier).setTheme('light'),
          ),
          const SizedBox(width: 8),
          _ThemeOption(
            label: 'Oscuro',
            isSelected: currentTheme == 'dark',
            onTap: () => ref.read(settingsProvider.notifier).setTheme('dark'),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ViewSelector extends StatelessWidget {
  final String currentView;
  final WidgetRef ref;

  const _ViewSelector({required this.currentView, required this.ref});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.view_module,
          color: AppColors.secondary,
          size: 20,
        ),
      ),
      title: const Text(
        'Vista predeterminada',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: AppColors.onSurface,
        ),
      ),
      subtitle: Row(
        children: [
          _ThemeOption(
            label: 'Cuadrícula',
            isSelected: currentView == 'grid',
            onTap: () =>
                ref.read(settingsProvider.notifier).setDefaultView('grid'),
          ),
          const SizedBox(width: 8),
          _ThemeOption(
            label: 'Lista',
            isSelected: currentView == 'list',
            onTap: () =>
                ref.read(settingsProvider.notifier).setDefaultView('list'),
          ),
        ],
      ),
    );
  }
}
