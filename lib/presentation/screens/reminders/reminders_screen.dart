import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../../../domain/providers/customization_provider.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  final _controller = TextEditingController();
  String _activeTab = 'Pending';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(remindersProvider);
    final customization = ref.watch(customizationProvider);
    final pending = reminders.where((r) => !r.isCompleted).toList();
    final completed = reminders.where((r) => r.isCompleted).toList();
    final activeReminders = _activeTab == 'Pending' ? pending : completed;

    final effectivePadding = customization.compactMode ? 24.0 : 48.0;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(effectivePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primaryContainer,
                          AppColors.secondary,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'Stay on track',
                        style: AppTypography.heroTitle.copyWith(
                          color: Colors.white,
                          fontSize: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your celestial schedule, synchronized across the void.',
                      style: AppTypography.subtitle.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _TabButton(
                        label: 'Pending',
                        isActive: _activeTab == 'Pending',
                        onTap: () => setState(() => _activeTab = 'Pending'),
                      ),
                      const SizedBox(width: 4),
                      _TabButton(
                        label: 'Completed',
                        isActive: _activeTab == 'Completed',
                        onTap: () => setState(() => _activeTab = 'Completed'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            // Quick Add
            ShadcnCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 24,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: AppTypography.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Add a new reminder...',
                        hintStyle: AppTypography.body.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        prefixIcon: Icon(
                          Icons.add_task,
                          color: AppColors.primary.withAlpha(128),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        ref
                            .read(remindersProvider.notifier)
                            .add(
                              Reminder(
                                title: _controller.text,
                                scheduledTime: DateTime.now().add(
                                  const Duration(hours: 1),
                                ),
                              ),
                            );
                        _controller.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Add',
                          style: AppTypography.label.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.bolt, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Reminder List
            if (activeReminders.isEmpty)
              _EmptyState()
            else
              ...activeReminders.asMap().entries.map((entry) {
                final reminder = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ReminderCard(
                    reminder: reminder,
                    index: entry.key,
                    onToggle: () {
                      ref
                          .read(remindersProvider.notifier)
                          .update(
                            reminder.copyWith(
                              isCompleted: !reminder.isCompleted,
                            ),
                          );
                    },
                    onDelete: () {
                      ref.read(remindersProvider.notifier).delete(reminder.id);
                    },
                  ),
                );
              }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.secondary.withAlpha(26)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withAlpha(51),
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.secondary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ReminderCard extends StatefulWidget {
  final Reminder reminder;
  final int index;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _ReminderCard({
    required this.reminder,
    required this.index,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  State<_ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<_ReminderCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ShadcnCard(
        padding: const EdgeInsets.all(24),
        borderRadius: 24,
        hoverEffect: true,
        child: Row(
          children: [
            GestureDetector(
              onTap: widget.onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withAlpha(102),
                    width: 2,
                  ),
                  color: _isHovered
                      ? AppColors.primary.withAlpha(26)
                      : Colors.transparent,
                ),
                child: widget.reminder.isCompleted
                    ? const Icon(
                        Icons.check,
                        color: AppColors.primary,
                        size: 20,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.reminder.title,
                    style: AppTypography.cardTitle.copyWith(
                      decoration: widget.reminder.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: widget.reminder.isCompleted
                          ? AppColors.onSurfaceVariant
                          : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(widget.reminder.scheduledTime),
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: _isHovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                icon: const Icon(Icons.delete, size: 20),
                color: AppColors.error,
                onPressed: widget.onDelete,
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (50 * widget.index).ms).fadeIn().slideX(begin: 0.05);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);
    if (diff.inDays == 0) {
      return 'Today, ${_formatTime(date)}';
    } else if (diff.inDays == 1) {
      return 'Tomorrow, ${_formatTime(date)}';
    } else {
      return '${date.month}/${date.day}, ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${date.minute.toString().padLeft(2, '0')} $period';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withAlpha(51),
                      AppColors.secondary.withAlpha(26),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withAlpha(77),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 64,
                  color: AppColors.primary.withAlpha(102),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withAlpha(128),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'LiveIndicator: Idle',
                style: AppTypography.typeBadge.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('The Orbit is Clear', style: AppTypography.sectionTitle),
          const SizedBox(height: 8),
          Text(
            'Your celestial manifest is empty. Add a reminder to start your cosmic journey.',
            style: AppTypography.body.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}
