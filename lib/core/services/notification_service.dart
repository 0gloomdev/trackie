import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/models.dart';
import '../../domain/providers/providers.dart';

class NotificationService {
  final Ref ref;

  NotificationService(this.ref);

  void showAchievementUnlocked(Achievement achievement) {
    ref
        .read(notificationsProvider.notifier)
        .addNotification(
          AppNotification(
            titulo: 'Achievement Unlocked!',
            mensaje: achievement.titulo,
            tipo: 'achievement',
          ),
        );
  }

  void showItemCompleted(LearningItem item) {
    ref
        .read(notificationsProvider.notifier)
        .addNotification(
          AppNotification(
            titulo: 'Item Completed!',
            mensaje: item.title,
            tipo: 'item',
          ),
        );
  }

  void showStreakMilestone(int streak) {
    ref
        .read(notificationsProvider.notifier)
        .addNotification(
          AppNotification(
            titulo: 'Streak Milestone!',
            mensaje: '$streak days in a row',
            tipo: 'streak',
          ),
        );
  }

  void showXpGained(int xp) {
    ref
        .read(notificationsProvider.notifier)
        .addNotification(
          AppNotification(titulo: 'XP Gained!', mensaje: '+$xp XP', tipo: 'xp'),
        );
  }

  void showLevelUp(int newLevel) {
    ref
        .read(notificationsProvider.notifier)
        .addNotification(
          AppNotification(
            titulo: 'Level Up!',
            mensaje: 'You are now level $newLevel',
            tipo: 'level',
          ),
        );
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

class InAppNotificationBanner extends StatefulWidget {
  final AppNotification notification;
  final VoidCallback onDismiss;

  const InAppNotificationBanner({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  @override
  State<InAppNotificationBanner> createState() =>
      _InAppNotificationBannerState();
}

class _InAppNotificationBannerState extends State<InAppNotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getIcon() {
    switch (widget.notification.tipo) {
      case 'achievement':
        return Icons.emoji_events;
      case 'item':
        return Icons.check_circle;
      case 'streak':
        return Icons.local_fire_department;
      case 'xp':
        return Icons.star;
      case 'level':
        return Icons.arrow_upward;
      default:
        return Icons.notifications;
    }
  }

  Color _getColor() {
    switch (widget.notification.tipo) {
      case 'achievement':
        return Colors.amber;
      case 'item':
        return Colors.green;
      case 'streak':
        return Colors.orange;
      case 'xp':
        return Colors.purple;
      case 'level':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getColor();

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey[900]?.withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getIcon(), color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.notification.titulo,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          widget.notification.mensaje,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    onPressed: _dismiss,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
