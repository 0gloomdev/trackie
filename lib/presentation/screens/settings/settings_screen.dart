import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../core/widgets/glass_design.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../../../domain/providers/customization_provider.dart';
import '../domains/custom_domains_section.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final UserProfile profile = ref.watch(userProfileProvider);
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
                  Expanded(flex: 2, child: _buildContent(settings, profile)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppSettings settings, UserProfile profile) {
    switch (_selectedIndex) {
      case 0:
        return _ProfileSection(settings: settings, profile: profile);
      case 1:
        return _NotificationsSection(settings: settings);
      case 2:
        return _PrivacySection(settings: settings);
      case 3:
        return _DataSection(settings: settings);
      case 4:
        return _AppearanceSection(settings: settings);
      case 5:
        return const _CustomDomainsSection();
      default:
        return _ProfileSection(settings: settings, profile: profile);
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
  final AppSettings settings;
  final UserProfile profile;

  const _ProfileSection({required this.settings, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        profile.nombre.isNotEmpty
                            ? profile.nombre[0].toUpperCase()
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
                        profile.nombre.isNotEmpty ? profile.nombre : 'User',
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
                          'Level ${profile.nivel} • ${profile.xp} XP',
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
              value: settings.compactMode,
              color: AppColors.secondary,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .update(settings.copyWith(compactMode: value));
              },
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
    );
  }
}

class _NotificationsSection extends ConsumerWidget {
  final AppSettings settings;

  const _NotificationsSection({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              value: settings.notificationsEnabled,
              color: AppColors.primary,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .update(settings.copyWith(notificationsEnabled: value));
              },
            ),
            const SizedBox(height: 12),
            _SettingsToggle(
              icon: Icons.schedule,
              title: 'Pomodoro Reminders',
              subtitle: 'Notifications during study sessions',
              value: settings.pomodoroNotifications,
              color: AppColors.secondary,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .update(settings.copyWith(pomodoroNotifications: value));
              },
            ),
            const SizedBox(height: 12),
            _SettingsToggle(
              icon: Icons.emoji_events,
              title: 'Achievements Unlocked',
              subtitle: 'Celebrate when you earn achievements',
              value: settings.achievementsNotifications,
              color: Colors.amber,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .update(
                      settings.copyWith(achievementsNotifications: value),
                    );
              },
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
    );
  }
}

class _PrivacySection extends ConsumerWidget {
  final AppSettings settings;

  const _PrivacySection({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: ShadcnCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: 'PRIVACY & SECURITY'),
            const SizedBox(height: 20),
            _SettingsTile(
              icon: Icons.lock,
              title: 'PIN Lock',
              subtitle: settings.pinLockEnabled ? 'Enabled' : 'Disabled',
              onTap: () => _showPinLockDialog(context, ref, settings),
            ),
            const SizedBox(height: 12),
            _SettingsToggle(
              icon: Icons.fingerprint,
              title: 'Biometrics',
              subtitle: 'Use fingerprint or face to unlock',
              value: settings.pinLockEnabled,
              color: AppColors.primary,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .update(settings.copyWith(pinLockEnabled: value));
              },
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
    );
  }

  void _showPinLockDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    final pinController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            settings.pinLockEnabled ? 'Disable PIN Lock' : 'Enable PIN Lock',
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (settings.pinLockEnabled) ...[
                Text(
                  'Are you sure you want to disable PIN lock?',
                  style: TextStyle(color: Colors.white.withAlpha(179)),
                ),
              ] else ...[
                Text(
                  'Enter a 4-digit PIN to secure your app.',
                  style: TextStyle(color: Colors.white.withAlpha(179)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    letterSpacing: 8,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••',
                    hintStyle: TextStyle(color: Colors.white.withAlpha(77)),
                    counterText: '',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withAlpha(51)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (settings.pinLockEnabled) {
                        ref
                            .read(settingsProvider.notifier)
                            .update(
                              settings.copyWith(
                                pinLockEnabled: false,
                                pinCode: null,
                              ),
                            );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('PIN Lock disabled'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      } else {
                        final pin = pinController.text;
                        if (pin.length != 4) {
                          return;
                        }
                        setState(() => isLoading = true);
                        ref
                            .read(settingsProvider.notifier)
                            .update(
                              settings.copyWith(
                                pinLockEnabled: true,
                                pinCode: pin,
                              ),
                            );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('PIN Lock enabled'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                settings.pinLockEnabled ? ('Disable') : ('Enable'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataSection extends ConsumerWidget {
  final AppSettings settings;

  const _DataSection({required this.settings});

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
                  onTap: () => _showImportDialog(context, ref),
                ),
                const SizedBox(height: 12),
                _SettingsToggle(
                  icon: Icons.backup,
                  title: 'Auto Backup',
                  subtitle: settings.autoBackupEnabled
                      ? 'Every ${settings.autoBackupFrequency} days'
                      : 'Disabled',
                  value: settings.autoBackupEnabled,
                  color: AppColors.primary,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .update(settings.copyWith(autoBackupEnabled: value));
                  },
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
      final items = ref.read(learningItemsProvider);
      final notes = ref.read(notesProvider);
      final reminders = ref.read(remindersProvider);

      final jsonData = {
        'items': items.map((i) => i.toJson()).toList(),
        'notes': notes.map((n) => n.toJson()).toList(),
        'reminders': reminders.map((r) => r.toJson()).toList(),
        'exportedAt': DateTime.now().toIso8601String(),
      };

      // Data ready: ${jsonData.toString().length} bytes

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

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Import Data', style: const TextStyle(color: Colors.white)),
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
            child: Text(
              'Cancel',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Import feature coming soon!'),
                  backgroundColor: AppColors.secondary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(
              'Select File',
              style: const TextStyle(color: Colors.white),
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
            Text(
              'Delete All Data?',
              style: const TextStyle(color: Colors.white),
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
            _DeleteItem(text: '• All saved items'),
            _DeleteItem(text: '• All notes'),
            _DeleteItem(text: '• All reminders'),
            _DeleteItem(text: '• All progress data'),
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
            child: Text(
              'Cancel',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(learningItemsProvider.notifier).deleteAll();
              ref.read(notesProvider.notifier).deleteAll();
              ref.read(remindersProvider.notifier).deleteAll();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All data has been deleted'),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: Text(
              'Delete Everything',
              style: const TextStyle(color: Colors.white),
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
  final AppSettings settings;

  const _AppearanceSection({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              subtitle: _getThemeName(settings.theme),
              onTap: () => _showThemeDialog(context, ref, settings),
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: settings.defaultView == 'grid'
                  ? Icons.grid_view
                  : Icons.list,
              title: 'Default View',
              subtitle: settings.defaultView == 'grid' ? 'Grid' : 'List',
              onTap: () {
                final newView = settings.defaultView == 'grid'
                    ? 'list'
                    : 'grid';
                ref
                    .read(settingsProvider.notifier)
                    .update(settings.copyWith(defaultView: newView));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      newView == 'grid'
                          ? 'View changed to Grid'
                          : 'View changed to List',
                    ),
                    backgroundColor: AppColors.primary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _SettingsToggle(
              icon: Icons.animation,
              title: 'Animations',
              subtitle: 'Enable transitions and effects',
              value: !settings.compactMode,
              color: AppColors.secondary,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .update(settings.copyWith(compactMode: !value));
              },
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

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
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
                isSelected: settings.theme == 'light',
                onTap: () {
                  ref.read(settingsProvider.notifier).setTheme('light');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
              _ThemeOption(
                title: 'Dark',
                isSelected: settings.theme == 'dark',
                onTap: () {
                  ref.read(settingsProvider.notifier).setTheme('dark');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
              _ThemeOption(
                title: 'System',
                isSelected: settings.theme == 'system',
                onTap: () {
                  ref.read(settingsProvider.notifier).setTheme('system');
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
              Icon(Icons.check, color: AppColors.primary, size: 20),
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
