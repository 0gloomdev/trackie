import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

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
    final profile = ref.watch(userProfileProvider);
    final isEnglish = settings.locale == 'en';

    final menuItems = isEnglish
        ? ['Profile', 'Notifications', 'Privacy', 'Data & Sync', 'Appearance']
        : [
            'Perfil',
            'Notificaciones',
            'Privacidad',
            'Datos y Sincronización',
            'Apariencia',
          ];

    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _Sidebar()),
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
      default:
        return _ProfileSection(settings: settings, profile: profile);
    }
  }

  Widget _Header() {
    final settings = ref.watch(settingsProvider);
    final isEnglish = settings.locale == 'en';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEnglish ? 'Settings' : 'Ajustes',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: Colors.white,
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
        const SizedBox(height: 8),
        Text(
          isEnglish
              ? 'Customize your Aura Learning experience'
              : 'Personaliza tu experiencia Aura Learning',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withAlpha(179),
            fontWeight: FontWeight.w500,
          ),
        ).animate(delay: 100.ms).fadeIn(duration: 600.ms),
      ],
    );
  }

  Widget _Sidebar() {
    final settings = ref.watch(settingsProvider);
    final isEnglish = settings.locale == 'en';
    final menuItems = isEnglish
        ? ['Profile', 'Notifications', 'Privacy', 'Data & Sync', 'Appearance']
        : [
            'Perfil',
            'Notificaciones',
            'Privacidad',
            'Datos y Sincronización',
            'Apariencia',
          ];

    return Column(
      children: List.generate(menuItems.length, (index) {
        final isSelected = _selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.shadcnPrimary.withAlpha(51)
                    : Colors.white.withAlpha(13),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.shadcnPrimary.withAlpha(128)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getMenuIcon(index),
                    color: isSelected
                        ? AppColors.shadcnSecondary
                        : Colors.white.withAlpha(179),
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
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: (50 * index).ms).fadeIn().slideX(begin: -0.1),
        );
      }),
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
      default:
        return Icons.settings;
    }
  }
}

class _ProfileSection extends StatelessWidget {
  final AppSettings settings;
  final UserProfile profile;

  const _ProfileSection({required this.settings, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ShadcnCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.shadcnPrimary,
                        AppColors.shadcnSecondary,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.shadcnBackground,
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.nombre.isNotEmpty ? profile.nombre : 'Usuario',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Nivel ${profile.nivel} • ${profile.xp} XP',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SettingsToggle(
              icon: Icons.cloud_off,
              title: 'Sincronización Offline (Hive)',
              subtitle: 'Almacenamiento local prioritario activado',
              value: true,
              color: AppColors.shadcnPrimary,
            ),
            const SizedBox(height: 12),
            _SettingsToggle(
              icon: Icons.battery_saver,
              title: 'Modo Ahorro de Energía',
              subtitle: 'Reduce animaciones',
              value: settings.compactMode,
              color: AppColors.shadcnSecondary,
              onChanged: (value) {
                // Would update settings here
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
    final isEnglish = settings.locale == 'en';

    return SingleChildScrollView(
      child: ShadcnCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              title: isEnglish
                  ? 'NOTIFICATIONS'
                  : 'CONFIGURACIÓN DE NOTIFICACIONES',
            ),
            const SizedBox(height: 20),
            _SettingsToggle(
              icon: Icons.notifications,
              title: isEnglish ? 'Push Notifications' : 'Notificaciones Push',
              subtitle: isEnglish
                  ? 'Receive alerts and reminders'
                  : 'Recibe alertas y recordatorios',
              value: settings.notificationsEnabled,
              color: AppColors.shadcnPrimary,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .update(settings.copyWith(notificationsEnabled: value));
              },
            ),
            const SizedBox(height: 12),
            _SettingsToggle(
              icon: Icons.schedule,
              title: isEnglish
                  ? 'Pomodoro Reminders'
                  : 'Recordatorios de Pomodoro',
              subtitle: isEnglish
                  ? 'Notifications during study sessions'
                  : 'Notificaciones durante sesiones de estudio',
              value: settings.notificationsEnabled,
              color: AppColors.shadcnSecondary,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .update(settings.copyWith(notificationsEnabled: value));
              },
            ),
            const SizedBox(height: 12),
            _SettingsToggle(
              icon: Icons.emoji_events,
              title: isEnglish
                  ? 'Achievements Unlocked'
                  : 'Logros Desbloqueados',
              subtitle: isEnglish
                  ? 'Celebrate when you earn achievements'
                  : 'Celebrar cuando ganas logros',
              value: true,
              color: Colors.amber,
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
            _SectionTitle(title: 'Privacidad y Seguridad'),
            const SizedBox(height: 20),
            _SettingsTile(
              icon: Icons.lock,
              title: 'PIN de Bloqueo',
              subtitle: settings.pinLockEnabled ? 'Activado' : 'Desactivado',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _SettingsToggle(
              icon: Icons.fingerprint,
              title: 'Biometría',
              subtitle: 'Usar huella o rostro para desbloquear',
              value: settings.pinLockEnabled,
              color: AppColors.shadcnPrimary,
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
}

class _DataSection extends ConsumerWidget {
  final AppSettings settings;

  const _DataSection({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShadcnCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(title: 'Datos y Respaldo'),
                const SizedBox(height: 20),
                _SettingsTile(
                  icon: Icons.download,
                  title: 'Exportar Datos',
                  subtitle: 'Descargar como JSON',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.upload,
                  title: 'Importar Datos',
                  subtitle: 'Cargar desde JSON',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _SettingsToggle(
                  icon: Icons.backup,
                  title: 'Auto Respaldo',
                  subtitle: settings.autoBackupEnabled
                      ? 'Cada ${settings.autoBackupFrequency} días'
                      : 'Desactivado',
                  value: settings.autoBackupEnabled,
                  color: AppColors.shadcnPrimary,
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
          ShadcnCard(
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
                      'Zona de Peligro',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Una vez que elimines tus datos, no hay vuelta atrás. Por favor, asegúrate.',
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
                        title: 'Borrar Todos los Datos',
                        subtitle: 'Eliminar permanentemente',
                        isDestructive: true,
                        onTap: () {},
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
}

class _AppearanceSection extends ConsumerWidget {
  final AppSettings settings;

  const _AppearanceSection({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnglish = settings.locale == 'en';

    return SingleChildScrollView(
      child: ShadcnCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: isEnglish ? 'APPEARANCE' : 'APARIENCIA'),
            const SizedBox(height: 20),
            _SettingsTile(
              icon: Icons.palette,
              title: isEnglish ? 'Theme' : 'Tema',
              subtitle: _getThemeName(settings.theme, isEnglish),
              onTap: () => _showThemeDialog(context, ref, settings),
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.language,
              title: isEnglish ? 'Language' : 'Idioma',
              subtitle: settings.locale == 'es' ? 'Español' : 'English',
              onTap: () => _showLanguageDialog(context, ref, settings),
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.view_module,
              title: isEnglish ? 'Default View' : 'Vista Predeterminada',
              subtitle: settings.defaultView == 'grid'
                  ? (isEnglish ? 'Grid' : 'Cuadrícula')
                  : (isEnglish ? 'List' : 'Lista'),
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _SettingsToggle(
              icon: Icons.animation,
              title: isEnglish ? 'Animations' : 'Animaciones',
              subtitle: isEnglish
                  ? 'Enable transitions and effects'
                  : 'Habilitar transiciones y efectos',
              value: !settings.compactMode,
              color: AppColors.shadcnSecondary,
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

  String _getThemeName(String theme, bool isEnglish) {
    switch (theme) {
      case 'light':
        return isEnglish ? 'Light' : 'Claro';
      case 'dark':
        return isEnglish ? 'Dark' : 'Oscuro';
      default:
        return isEnglish ? 'System' : 'Sistema';
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.shadcnBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Seleccionar Tema',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              title: 'Claro',
              isSelected: settings.theme == 'light',
              onTap: () {
                ref.read(settingsProvider.notifier).setTheme('light');
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              title: 'Oscuro',
              isSelected: settings.theme == 'dark',
              onTap: () {
                ref.read(settingsProvider.notifier).setTheme('dark');
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              title: 'Sistema',
              isSelected: settings.theme == 'system',
              onTap: () {
                ref.read(settingsProvider.notifier).setTheme('system');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.shadcnBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Seleccionar Idioma',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              title: 'Español',
              isSelected: settings.locale == 'es',
              onTap: () {
                ref.read(settingsProvider.notifier).setLocale('es');
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              title: 'English',
              isSelected: settings.locale == 'en',
              onTap: () {
                ref.read(settingsProvider.notifier).setLocale('en');
                Navigator.pop(context);
              },
            ),
          ],
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
              ? AppColors.shadcnPrimary.withAlpha(26)
              : Colors.white.withAlpha(13),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.shadcnPrimary : Colors.transparent,
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
              Icon(Icons.check, color: AppColors.shadcnPrimary, size: 20),
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
                color: (isDestructive ? Colors.red : AppColors.shadcnPrimary)
                    .withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : AppColors.shadcnPrimary,
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
