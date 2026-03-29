import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
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
    final sessions = ref.read(pomodoroSessionsProvider);
    if (sessions.isNotEmpty) {
      ref
          .read(pomodoroSessionsProvider.notifier)
          .completeSession(sessions.last.id);
    }
    ref.read(pomodoroTimeProvider.notifier).state = _selectedMinutes * 60;
    ref.read(userProfileProvider.notifier).addXp(10);
    ref.read(dailyGoalsProvider.notifier).addMinutesStudied(_selectedMinutes);
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.shadcnBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber),
            const SizedBox(width: 8),
            const Text(
              '¡Sesión completada!',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Has ganado:', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '+10 XP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Genial!', style: TextStyle(color: Colors.white)),
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
    final pomodoroState = ref.watch(pomodoroStateProvider);
    final timeLeft = ref.watch(pomodoroTimeProvider);
    final sessions = ref.watch(pomodoroSessionsProvider);
    final todaySessions = sessions.where((s) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      return s.completed && s.startTime.isAfter(today);
    }).length;

    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _Header(),
              const Spacer(),
              _TimerCircle(
                timeLeft: timeLeft,
                totalTime: _selectedMinutes * 60,
                state: pomodoroState,
              ),
              const SizedBox(height: 48),
              _TimerControls(
                state: pomodoroState,
                onStart: _startTimer,
                onPause: _pauseTimer,
                onResume: _resumeTimer,
                onReset: _resetTimer,
              ),
              const Spacer(),
              _SessionSelector(
                selectedMinutes: _selectedMinutes,
                enabled: pomodoroState == PomodoroState.idle,
                onChanged: (mins) => setState(() => _selectedMinutes = mins),
              ),
              const SizedBox(height: 24),
              _TodayStats(todaySessions: todaySessions),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Pomodoro',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: Colors.white,
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
        const SizedBox(height: 4),
        Text(
          'Enfócate y alcanza tus metas',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withAlpha(179),
            fontWeight: FontWeight.w500,
          ),
        ).animate(delay: 100.ms).fadeIn(duration: 600.ms),
      ],
    );
  }
}

class _TimerCircle extends StatelessWidget {
  final int timeLeft;
  final int totalTime;
  final PomodoroState state;

  const _TimerCircle({
    required this.timeLeft,
    required this.totalTime,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalTime > 0 ? timeLeft / totalTime : 0.0;
    final isRunning = state == PomodoroState.running;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 260,
            height: 260,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 12,
              color: Colors.white.withAlpha(13),
            ),
          ),
          SizedBox(
            width: 260,
            height: 260,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(
                isRunning ? AppColors.shadcnSecondary : AppColors.shadcnPrimary,
              ),
            ),
          ),
          if (isRunning)
            SizedBox(
              width: 240,
              height: 240,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(
                  AppColors.shadcnSecondary.withAlpha(77),
                ),
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(timeLeft),
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getStateLabel(state),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isRunning ? AppColors.shadcnSecondary : Colors.white54,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9, 0.9));
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _getStateLabel(PomodoroState state) {
    switch (state) {
      case PomodoroState.idle:
        return 'LISTO';
      case PomodoroState.running:
        return 'EN CURSO';
      case PomodoroState.paused:
        return 'PAUSADO';
      case PomodoroState.breakTime:
        return 'DESCANSO';
    }
  }
}

class _TimerControls extends StatelessWidget {
  final PomodoroState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onReset;

  const _TimerControls({
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state != PomodoroState.idle)
          _ControlButton(
            icon: Icons.refresh,
            onTap: onReset,
            color: Colors.white54,
          ),
        const SizedBox(width: 24),
        _MainButton(
          state: state,
          onStart: onStart,
          onPause: onPause,
          onResume: onResume,
        ),
        const SizedBox(width: 24),
        if (state != PomodoroState.idle) const SizedBox(width: 56),
      ],
    ).animate(delay: 300.ms).fadeIn();
  }
}

class _MainButton extends StatelessWidget {
  final PomodoroState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;

  const _MainButton({
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final isIdle = state == PomodoroState.idle;

    return GestureDetector(
      onTap: isIdle
          ? onStart
          : (state == PomodoroState.running ? onPause : onResume),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isIdle
                ? [AppColors.shadcnPrimary, AppColors.shadcnSecondary]
                : [AppColors.shadcnSecondary, AppColors.shadcnPrimary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:
                  (isIdle ? AppColors.shadcnPrimary : AppColors.shadcnSecondary)
                      .withAlpha(102),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Icon(
          isIdle
              ? Icons.play_arrow
              : (state == PomodoroState.running
                    ? Icons.pause
                    : Icons.play_arrow),
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(26),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}

class _SessionSelector extends StatelessWidget {
  final int selectedMinutes;
  final bool enabled;
  final ValueChanged<int> onChanged;

  const _SessionSelector({
    required this.selectedMinutes,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = [15, 25, 30, 45, 60];

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: options.map((mins) {
          final isSelected = selectedMinutes == mins;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: enabled ? () => onChanged(mins) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.shadcnPrimary.withAlpha(51)
                      : Colors.white.withAlpha(13),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.shadcnPrimary
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Text(
                  '$mins min',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ).animate(delay: 400.ms).fadeIn();
  }
}

class _TodayStats extends StatelessWidget {
  final int todaySessions;

  const _TodayStats({required this.todaySessions});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_fire_department, color: Colors.orange, size: 24),
          const SizedBox(width: 12),
          Text(
            '$todaySessions sesiones hoy',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.1);
  }
}
