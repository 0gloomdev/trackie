import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_glass.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../domain/providers/providers.dart';

class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({super.key});

  @override
  ConsumerState<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen> {
  Timer? _timer;
  int _selectedMinutes = 25;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    ref.read(pomodoroStateProvider.notifier).state = PomodoroState.running;
    ref.read(pomodoroTimeProvider.notifier).state = _selectedMinutes * 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentTime = ref.read(pomodoroTimeProvider);
      if (currentTime > 0) {
        ref.read(pomodoroTimeProvider.notifier).state = currentTime - 1;
      } else {
        _completeSession();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    ref.read(pomodoroStateProvider.notifier).state = PomodoroState.paused;
  }

  void _resumeTimer() {
    ref.read(pomodoroStateProvider.notifier).state = PomodoroState.running;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentTime = ref.read(pomodoroTimeProvider);
      if (currentTime > 0) {
        ref.read(pomodoroTimeProvider.notifier).state = currentTime - 1;
      } else {
        _completeSession();
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    ref.read(pomodoroStateProvider.notifier).state = PomodoroState.idle;
    ref.read(pomodoroTimeProvider.notifier).state = _selectedMinutes * 60;
  }

  void _completeSession() {
    _timer?.cancel();
    ref.read(pomodoroStateProvider.notifier).state = PomodoroState.idle;
    ref
        .read(pomodoroSessionsProvider.notifier)
        .startSession(duration: _selectedMinutes);
    ref
        .read(pomodoroSessionsProvider.notifier)
        .completeSession(ref.read(pomodoroSessionsProvider).last.id);
    ref.read(pomodoroTimeProvider.notifier).state = _selectedMinutes * 60;

    ref.read(userProfileProvider.notifier).addXp(10);
    ref.read(dailyGoalsProvider.notifier).addMinutesStudied(_selectedMinutes);

    // Check if daily goal is now complete and notify
    final goals = ref.read(dailyGoalsProvider);
    if (goals.isNotEmpty) {
      final todayGoal = goals.first;
      if (todayGoal.completed) {
        ref
            .read(notificationsProvider.notifier)
            .addNotification(
              AppNotification(
                titulo: '¡Meta diaria completada!',
                mensaje: 'Has completado todas tus metas de hoy',
                tipo: 'goal',
              ),
            );
      }
    }

    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber),
            const SizedBox(width: 8),
            const Text('¡Sesión completada!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Has ganado:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.lightPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '+10 XP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightPrimary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Genial!'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pomodoroState = ref.watch(pomodoroStateProvider);
    final timeLeft = ref.watch(pomodoroTimeProvider);
    final sessions = ref.watch(pomodoroSessionsProvider);
    final todaySessions = sessions.where((s) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      return s.completed && s.startTime.isAfter(today);
    }).length;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pomodoro',
          style: TextStyle(
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color:
                      (isDark
                              ? AppColors.darkSurfaceContainer
                              : AppColors.lightSurfaceContainer)
                          .withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: pomodoroState == PomodoroState.running
                        ? AppColors.lightPrimary.withValues(alpha: 0.3)
                        : Colors.transparent,
                    width: 4,
                  ),
                ),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.lightPrimary.withValues(alpha: 0.1),
                        AppColors.lightSecondary.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _formatTime(timeLeft),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: pomodoroState == PomodoroState.running
                            ? AppColors.lightPrimary
                            : (isDark
                                  ? AppColors.darkOnSurface
                                  : AppColors.lightOnSurface),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              if (pomodoroState == PomodoroState.idle) ...[
                Text(
                  'Selecciona la duración',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkOnSurfaceVariant
                        : AppColors.lightOnSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [15, 25, 45, 60].map((mins) {
                    final isSelected = _selectedMinutes == mins;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedMinutes = mins),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.lightPrimary
                                : (isDark
                                      ? AppColors.darkSurfaceContainerHighest
                                      : AppColors.lightSurfaceContainerHighest),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${mins}m',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                        ? AppColors.darkOnSurface
                                        : AppColors.lightOnSurface),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pomodoroState == PomodoroState.idle) ...[
                    GlassButton(
                      label: 'Iniciar',
                      icon: Icons.play_arrow,
                      isPrimary: true,
                      onPressed: _startTimer,
                    ),
                  ] else if (pomodoroState == PomodoroState.running) ...[
                    GlassButton(
                      label: 'Pausar',
                      icon: Icons.pause,
                      isPrimary: false,
                      onPressed: _pauseTimer,
                    ),
                    const SizedBox(width: 16),
                    GlassButton(
                      label: 'Reset',
                      icon: Icons.stop,
                      isPrimary: false,
                      onPressed: _resetTimer,
                    ),
                  ] else if (pomodoroState == PomodoroState.paused) ...[
                    GlassButton(
                      label: 'Reanudar',
                      icon: Icons.play_arrow,
                      isPrimary: true,
                      onPressed: _resumeTimer,
                    ),
                    const SizedBox(width: 16),
                    GlassButton(
                      label: 'Reset',
                      icon: Icons.stop,
                      isPrimary: false,
                      onPressed: _resetTimer,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceContainerHighest
                      : AppColors.lightSurfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppGlass.radiusMedium),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      label: 'Sesiones hoy',
                      value: '$todaySessions',
                      icon: Icons.check_circle,
                      isDark: isDark,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: isDark
                          ? AppColors.darkOutlineVariant
                          : AppColors.lightOutlineVariant,
                    ),
                    _StatItem(
                      label: 'Minutos hoy',
                      value: '${todaySessions * _selectedMinutes}',
                      icon: Icons.timer,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.lightPrimary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppColors.darkOnSurfaceVariant
                : AppColors.lightOnSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
