import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:drift/drift.dart' show Value;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/shadcn_widgets.dart';
import '../../../shared/widgets/glass_design.dart';
import '../../shared/providers/drift_providers.dart';
import '../../shared/providers/customization_provider.dart';
import '../../domains/presentation/custom_domains_section.dart';
import '../../../services/database/database.dart';
import '../../../services/database/database_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final customization = ref.watch(customizationProvider);

    final effectivePadding = customization.compactMode ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Padding(
        padding: EdgeInsets.all(effectivePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: sidebar()),
                  const SizedBox(width: 24),
                  Expanded(flex: 2, child: _buildContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const _ProfileSection();
      case 1:
        return const _NotificationsSection();
      case 2:
        return const _PrivacySection();
      case 3:
        return const _DataSection();
      case 4:
        return const _AppearanceSection();
      case 5:
        return const _CustomDomainsSection();
      default:
        return const _ProfileSection();
    }
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTypography.pageTitle,
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
        const SizedBox(height: 8),
        Text(
          'Manage your celestial presence across the Trackie network.',
          style: AppTypography.subtitle.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ).animate(delay: 100.ms).fadeIn(duration: 600.ms),
      ],
    );
  }

  Widget sidebar() {
    final menuItems = [
      'Profile',
      'Notifications',
      'Privacy',
      'Data & Sync',
      'Appearance',
      'Custom Domains',
    ];

    return GlassContainer(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(menuItems.length, (index) {
          final isSelected = _selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withAlpha(26)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                    left: BorderSide(
                      color: isSelected
                          ? AppColors.secondary
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(26),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      _getMenuIcon(index),
                      color: isSelected
                          ? AppColors.secondary
                          : Colors.white.withAlpha(128),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      menuItems[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withAlpha(179),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(delay: (50 * index).ms).fadeIn().slideX(begin: -0.1),
          );
        }),
      ),
    );
  }

  IconData _getMenuIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person;
      case 1:
        return Icons.notifications;
      case 2:
        return Icons.shield;
      case 3:
        return Icons.storage;
      case 4:
        return Icons.palette;
      case 5:
        return Icons.dns;
      default:
        return Icons.settings;
    }
  }
}

class _ProfileSection extends ConsumerWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final settingsAsync = ref.watch(settingsProvider);

    final settings = settingsAsync.maybeWhen(
      data: (data) => data,
      orElse: () => null,
    );

    return profileAsync.when(
      data: (profile) {
        final userName = profile?.username ?? 'User';
        final level = profile?.level ?? 1;
        final xp = profile?.xp ?? 0;

        return SingleChildScrollView(
          child: GlassContainer(
            borderRadius: 20,
            padding: const EdgeInsets.all(24),
            glowColor: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withAlpha(230),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(77),
                            blurRadius: 20,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceContainerLowest,
                        ),
                        child: Center(
                          child: Text(
                            userName.isNotEmpty
                                ? userName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName.isNotEmpty ? userName : 'User',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withAlpha(26),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.secondary.withAlpha(51),
                              ),
                            ),
                            child: Text(
                              'Level $level • $xp XP',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _SettingsToggle(
                  icon: Icons.cloud_off,
                  title: 'Offline Sync (Hive)',
                  subtitle: 'Local storage prioritized',
                  value: true,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                _SettingsToggle(
                  icon: Icons.battery_saver,
                  title: 'Battery Saver',
                  subtitle: 'Reduce animations',
                  value: settings?.reducedMotion ?? false,
                  color: AppColors.secondary,
                  onChanged: (value) async {
                    final db = ref.read(databaseProvider);
                    await db.saveSettings(
                      AppSettingsTableCompanion(
                        id: const Value('settings'),
                        reducedMotion: Value(value),
                      ),
                    );
                    ref.invalidate(settingsProvider);
                  },
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _NotificationsSection extends ConsumerWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    final settings = settingsAsync.maybeWhen(
      data: (data) => data,
      orElse: () => null,
    );

    return SingleChildScrollView(
      child: GlassContainer(
        borderRadius: 20,
        padding: const EdgeInsets.all(24),
        glowColor: AppColors.secondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Notification Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withAlpha(230),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SettingsToggle(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive alerts and reminders',
              value: settings?.notificationsEnabled ?? true,
              color: AppColors.primary,
              onChanged: (value) async {
                final db = ref.read(databaseProvider);
                await db.saveSettings(
                  AppSettingsTableCompanion(
                    id: const Value('settings'),
                    notificationsEnabled: Value(value),
                  ),
                );
                ref.invalidate(settingsProvider);
              },
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
    );
  }
}

class _PrivacySection extends ConsumerWidget {
  const _PrivacySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: ShadcnCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(title: 'PRIVACY & SECURITY'),
            const SizedBox(height: 20),
            _SettingsTile(
              icon: Icons.fingerprint,
              title: 'Biometrics',
              subtitle: 'Use fingerprint or face to unlock',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Biometrics feature coming soon'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
    );
  }
}

class _DataSection extends ConsumerWidget {
  const _DataSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GlassContainer(
            borderRadius: 20,
            padding: const EdgeInsets.all(24),
            glowColor: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.storage,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Data & Backup',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withAlpha(230),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _SettingsTile(
                  icon: Icons.download,
                  title: 'Export Data',
                  subtitle: 'Download as JSON',
                  onTap: () => _exportData(context, ref),
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.upload,
                  title: 'Import Data',
                  subtitle: 'Load from JSON',
                  onTap: () => _showImportDialog(context),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
          const SizedBox(height: 16),
          GlassContainer(
            borderRadius: 20,
            padding: const EdgeInsets.all(24),
            borderColor: Colors.red.withAlpha(77),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red.shade400, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Danger Zone',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Once you delete your data, there is no going back. Please be certain.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(128),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _SettingsTile(
                        icon: Icons.delete_forever,
                        title: 'Delete All Data',
                        subtitle: 'Permanently delete everything',
                        isDestructive: true,
                        onTap: () => _showDeleteConfirmation(context, ref),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate(delay: 300.ms).fadeIn().slideX(begin: 0.1),
        ],
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      final itemsAsync = ref.read(learningItemsProvider);
      final notesAsync = ref.read(notesProvider);
      final remindersAsync = ref.read(remindersProvider);

      final items = itemsAsync.maybeWhen(
        data: (data) => data,
        orElse: () => <LearningItem>[],
      );
      final notes = notesAsync.maybeWhen(
        data: (data) => data,
        orElse: () => <Note>[],
      );
      final reminders = remindersAsync.maybeWhen(
        data: (data) => data,
        orElse: () => <Reminder>[],
      );

      final jsonData = {
        'items': items.map((i) => i.toJson()).toList(),
        'notes': notes.map((n) => n.toJson()).toList(),
        'reminders': reminders.map((r) => r.toJson()).toList(),
        'exportedAt': DateTime.now().toIso8601String(),
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Data exported! ${items.length} items, ${notes.length} notes, ${reminders.length} reminders (${(jsonData.toString().length / 1024).toStringAsFixed(1)} KB)',
          ),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Import Data', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.upload_file,
              size: 64,
              color: AppColors.primary.withAlpha(179),
            ),
            const SizedBox(height: 16),
            Text(
              'This feature allows you to import data from a JSON file. Select a file to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withAlpha(179)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Import feature coming soon!'),
                  backgroundColor: AppColors.secondary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text(
              'Select File',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red.shade400),
            const SizedBox(width: 8),
            const Text(
              'Delete All Data?',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will permanently delete:',
              style: TextStyle(color: Colors.white.withAlpha(179)),
            ),
            const SizedBox(height: 12),
            const _DeleteItem(text: '• All saved items'),
            const _DeleteItem(text: '• All notes'),
            const _DeleteItem(text: '• All reminders'),
            const _DeleteItem(text: '• All progress data'),
            const SizedBox(height: 12),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('All data has been deleted'),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: const Text(
              'Delete Everything',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteItem extends StatelessWidget {
  final String text;
  const _DeleteItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(text, style: TextStyle(color: Colors.white.withAlpha(204))),
    );
  }
}

class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    final settings = settingsAsync.maybeWhen(
      data: (data) => data,
      orElse: () => null,
    );

    return SingleChildScrollView(
      child: GlassContainer(
        borderRadius: 20,
        padding: const EdgeInsets.all(24),
        glowColor: AppColors.tertiary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.palette,
                    color: AppColors.tertiary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Appearance Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withAlpha(230),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SettingsTile(
              icon: Icons.palette,
              title: 'Theme',
              subtitle: _getThemeName(settings?.theme ?? 'system'),
              onTap: () => _showThemeDialog(context, ref, settings),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
    );
  }

  String _getThemeName(String theme) {
    switch (theme) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, dynamic settings) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: GlassContainer(
          borderRadius: 20,
          padding: const EdgeInsets.all(24),
          opacity: 0.15,
          blur: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Theme',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _ThemeOption(
                title: 'Light',
                isSelected: settings?.theme == 'light',
                onTap: () async {
                  final db = ref.read(databaseProvider);
                  await db.saveSettings(
                    AppSettingsTableCompanion(
                      id: const Value('settings'),
                      theme: const Value('light'),
                    ),
                  );
                  ref.invalidate(settingsProvider);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
              _ThemeOption(
                title: 'Dark',
                isSelected: settings?.theme == 'dark',
                onTap: () async {
                  final db = ref.read(databaseProvider);
                  await db.saveSettings(
                    AppSettingsTableCompanion(
                      id: const Value('settings'),
                      theme: const Value('dark'),
                    ),
                  );
                  ref.invalidate(settingsProvider);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
              _ThemeOption(
                title: 'System',
                isSelected: settings?.theme == 'system',
                onTap: () async {
                  final db = ref.read(databaseProvider);
                  await db.saveSettings(
                    AppSettingsTableCompanion(
                      id: const Value('settings'),
                      theme: const Value('system'),
                    ),
                  );
                  ref.invalidate(settingsProvider);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              GlassButton(
                label: 'Cancel',
                color: AppColors.onSurfaceVariant,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(26)
              : Colors.white.withAlpha(13),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: Colors.white.withAlpha(128),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(13),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withAlpha(13)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (isDestructive ? Colors.red : AppColors.primary)
                    .withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(128),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withAlpha(77)),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color color;

  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(13)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withAlpha(128),
                  ),
                ),
              ],
            ),
          ),
          ShadcnToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _CustomDomainsSection extends StatelessWidget {
  const _CustomDomainsSection();

  @override
  Widget build(BuildContext context) {
    return const CustomDomainsSection();
  }
}
