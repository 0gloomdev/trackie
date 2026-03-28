import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsProvider);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ajustes',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                    ),
                  ),
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () => _showEditProfileDialog(context, ref, profile),
                    child: GlassCard(
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? AppColors.darkPrimaryContainer
                                  : AppColors.lightPrimaryContainer,
                            ),
                            child: Center(
                              child: Text(
                                profile.nombre.isNotEmpty
                                    ? profile.nombre[0].toUpperCase()
                                    : 'U',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.darkOnPrimaryContainer
                                      : AppColors.lightOnPrimaryContainer,
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
                                  profile.nombre,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppColors.darkOnSurface
                                        : AppColors.lightOnSurface,
                                  ),
                                ),
                                Text(
                                  'Nivel ${profile.nivel} • ${profile.xp} XP',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? AppColors.darkOnSurfaceVariant
                                        : AppColors.lightOnSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            color: isDark
                                ? AppColors.darkOnSurfaceVariant
                                : AppColors.lightOnSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _SectionTitle(title: 'Apariencia', isDark: isDark),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.palette,
                    title: 'Tema',
                    subtitle: _getThemeName(settings.theme),
                    isDark: isDark,
                    onTap: () => _showThemeDialog(context, ref, settings.theme),
                  ),
                  _SettingsTile(
                    icon: Icons.view_module,
                    title: 'Vista predeterminada',
                    subtitle: settings.defaultView == 'grid'
                        ? 'Cuadrícula'
                        : 'Lista',
                    isDark: isDark,
                    onTap: () =>
                        _showViewModeDialog(context, ref, settings.defaultView),
                  ),

                  const SizedBox(height: 24),

                  _SectionTitle(title: 'Datos', isDark: isDark),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.download,
                    title: 'Exportar datos',
                    subtitle: 'Descargar como JSON',
                    isDark: isDark,
                    onTap: () => _exportData(context, ref),
                  ),
                  _SettingsTile(
                    icon: Icons.upload,
                    title: 'Importar datos',
                    subtitle: 'Cargar desde JSON',
                    isDark: isDark,
                    onTap: () => _importData(context, ref),
                  ),
                  _SettingsTile(
                    icon: Icons.delete_forever,
                    title: 'Borrar todos los datos',
                    subtitle: 'Eliminar permanentemente',
                    isDark: isDark,
                    isDestructive: true,
                    onTap: () => _showDeleteDialog(context, ref),
                  ),

                  const SizedBox(height: 24),

                  _SectionTitle(title: 'Seguridad', isDark: isDark),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.lock,
                    title: 'PIN de bloqueo',
                    subtitle: settings.pinLockEnabled
                        ? 'Activado'
                        : 'Desactivado',
                    isDark: isDark,
                    onTap: () => _showPinLockDialog(context, ref, settings),
                  ),

                  const SizedBox(height: 24),

                  _SectionTitle(title: 'Notificaciones', isDark: isDark),
                  const SizedBox(height: 12),
                  _SettingsSwitch(
                    icon: Icons.notifications,
                    title: 'Notificaciones',
                    subtitle: 'Recibir alertas y recordatorios',
                    value: settings.notificationsEnabled,
                    isDark: isDark,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .update(
                            settings.copyWith(notificationsEnabled: value),
                          );
                    },
                  ),

                  const SizedBox(height: 24),

                  _SectionTitle(title: 'Respaldo', isDark: isDark),
                  const SizedBox(height: 12),
                  _SettingsSwitch(
                    icon: Icons.backup,
                    title: 'Auto respaldo',
                    subtitle: settings.autoBackupEnabled
                        ? 'Cada ${settings.autoBackupFrequency} días'
                        : 'Desactivado',
                    value: settings.autoBackupEnabled,
                    isDark: isDark,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .update(settings.copyWith(autoBackupEnabled: value));
                    },
                  ),

                  const SizedBox(height: 24),

                  _SectionTitle(title: 'Acerca de', isDark: isDark),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.info,
                    title: 'Versión',
                    subtitle: '1.0.0',
                    isDark: isDark,
                    onTap: () => _showVersionDialog(context, isDark),
                  ),
                  _SettingsTile(
                    icon: Icons.help,
                    title: 'Ayuda',
                    subtitle: 'Guía de uso',
                    isDark: isDark,
                    onTap: () {},
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeName(String theme) {
    switch (theme) {
      case 'light':
        return 'Claro';
      case 'dark':
        return 'Oscuro';
      default:
        return 'Sistema';
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    String currentTheme,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurfaceContainer
            : AppColors.lightSurface,
        title: const Text('Seleccionar tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              label: 'Sistema',
              isSelected: currentTheme == 'system',
              onTap: () {
                ref.read(settingsProvider.notifier).setTheme('system');
                Navigator.pop(context);
              },
              isDark: isDark,
            ),
            _ThemeOption(
              label: 'Claro',
              isSelected: currentTheme == 'light',
              onTap: () {
                ref.read(settingsProvider.notifier).setTheme('light');
                Navigator.pop(context);
              },
              isDark: isDark,
            ),
            _ThemeOption(
              label: 'Oscuro',
              isSelected: currentTheme == 'dark',
              onTap: () {
                ref.read(settingsProvider.notifier).setTheme('dark');
                Navigator.pop(context);
              },
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  void _showViewModeDialog(
    BuildContext context,
    WidgetRef ref,
    String currentView,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurfaceContainer
            : AppColors.lightSurface,
        title: const Text('Vista predeterminada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              label: 'Cuadrícula',
              isSelected: currentView == 'grid',
              onTap: () {
                ref.read(settingsProvider.notifier).toggleViewMode();
                Navigator.pop(context);
              },
              isDark: isDark,
            ),
            _ThemeOption(
              label: 'Lista',
              isSelected: currentView == 'list',
              onTap: () {
                ref.read(settingsProvider.notifier).toggleViewMode();
                Navigator.pop(context);
              },
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurfaceContainer
            : AppColors.lightSurface,
        title: const Text('Borrar todos los datos'),
        content: const Text('¿Estás seguro? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(learningItemsProvider.notifier).deleteAll();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Datos eliminados')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.darkError
                  : AppColors.lightError,
            ),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
  }

  void _showVersionDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => _VersionDialog(isDark: isDark),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      final exportService = ref.read(dataExportServiceProvider);
      final filePath = await exportService.exportToFile();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos exportados a: $filePath')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al exportar: $e')));
      }
    }
  }

  void _importData(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurfaceContainer
            : AppColors.lightSurface,
        title: const Text('Importar datos'),
        content: const Text(
          'Para importar datos, coloca un archivo JSON de backup en tu carpeta de documentos con el nombre "aura_learning_backup.json" y luego toca "Importar".\n\nEsto reemplazará todos tus datos actuales.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final exportService = ref.read(dataExportServiceProvider);
                await exportService.importFromFile(
                  '/home/gloom/Documentos/aura_learning_backup.json',
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Datos importados correctamente'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al importar: $e')),
                  );
                }
              }
            },
            child: const Text('Importar'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameController = TextEditingController(text: profile.nombre);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurfaceContainer
            : AppColors.lightSurface,
        title: const Text('Editar perfil'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Tu nombre',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                ref
                    .read(userProfileProvider.notifier)
                    .updateProfile(profile.copyWith(nombre: newName));
              }
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showPinLockDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurfaceContainer
            : AppColors.lightSurface,
        title: const Text('PIN de bloqueo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              settings.pinLockEnabled
                  ? 'El PIN está activado'
                  : 'El PIN está desactivado',
            ),
            const SizedBox(height: 16),
            if (!settings.pinLockEnabled)
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSetPinDialog(context, ref, settings);
                },
                child: const Text('Activar PIN'),
              )
            else
              FilledButton(
                onPressed: () {
                  ref
                      .read(settingsProvider.notifier)
                      .update(
                        settings.copyWith(pinLockEnabled: false, pinCode: null),
                      );
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Desactivar PIN'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showSetPinDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurfaceContainer
            : AppColors.lightSurface,
        title: const Text('Establecer PIN'),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'PIN de 4 dígitos',
            hintText: '****',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final pin = pinController.text;
              if (pin.length == 4) {
                ref
                    .read(settingsProvider.notifier)
                    .update(
                      settings.copyWith(pinLockEnabled: true, pinCode: pin),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class _VersionDialog extends StatefulWidget {
  final bool isDark;

  const _VersionDialog({required this.isDark});

  @override
  State<_VersionDialog> createState() => _VersionDialogState();
}

class _VersionDialogState extends State<_VersionDialog> {
  int _tapCount = 0;

  void _handleTap() {
    setState(() {
      _tapCount++;
    });

    if (_tapCount >= 5) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Onboarding will show on next app restart'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.isDark
          ? AppColors.darkSurfaceContainer
          : AppColors.lightSurface,
      title: const Text('Acerca de Aura Learning'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _handleTap,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Versión: 1.0.0'),
                SizedBox(height: 8),
                Text('Una app de gestión de aprendizaje personal.'),
                SizedBox(height: 8),
                Text('Desarrollado con Flutter.'),
              ],
            ),
          ),
          if (_tapCount > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${5 - _tapCount} taps remaining for developer mode',
              style: TextStyle(
                fontSize: 12,
                color: widget.isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.lightOnSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: isDark
            ? AppColors.darkOnSurfaceVariant
            : AppColors.lightOnSurfaceVariant,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? (isDark ? AppColors.darkError : AppColors.lightError)
        : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? (isDark
                                ? AppColors.darkError
                                : AppColors.lightError)
                          : (isDark
                                ? AppColors.darkOnSurface
                                : AppColors.lightOnSurface),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.lightOnSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _ThemeOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return ListTile(
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check, color: color) : null,
      onTap: onTap,
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool isDark;
  final Function(bool) onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged, activeThumbColor: color),
          ],
        ),
      ),
    );
  }
}
