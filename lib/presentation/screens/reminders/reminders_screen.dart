import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reminders = ref.watch(remindersProvider);
    final pendingReminders = reminders.where((r) => !r.isCompleted).toList();
    final completedReminders = reminders.where((r) => r.isCompleted).toList();

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recordatorios',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.darkOnSurface
                              : AppColors.lightOnSurface,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: isDark
                              ? AppColors.darkOnSurface
                              : AppColors.lightOnSurface,
                        ),
                        onPressed: () => _showAddReminderDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (pendingReminders.isNotEmpty)
                    Text(
                      '${pendingReminders.length} recordatorio(s) pendiente(s)',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.lightOnSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (reminders.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay recordatorios',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.lightOnSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    NeonButton(
                      label: 'Crear recordatorio',
                      icon: Icons.add,
                      onPressed: () => _showAddReminderDialog(context),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            if (pendingReminders.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'PENDIENTES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ReminderCard(
                      reminder: pendingReminders[index],
                      isDark: isDark,
                      onComplete: () => ref
                          .read(remindersProvider.notifier)
                          .markCompleted(pendingReminders[index].id),
                      onDelete: () => ref
                          .read(remindersProvider.notifier)
                          .delete(pendingReminders[index].id),
                    ),
                    childCount: pendingReminders.length,
                  ),
                ),
              ),
            ],
            if (completedReminders.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'COMPLETADOS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ReminderCard(
                      reminder: completedReminders[index],
                      isDark: isDark,
                      onDelete: () => ref
                          .read(remindersProvider.notifier)
                          .delete(completedReminders[index].id),
                    ),
                    childCount: completedReminders.length,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    bool isDaily = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark
                ? AppColors.darkSurfaceContainer
                : AppColors.lightSurface,
            title: const Text('Nuevo recordatorio'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Estudiar Flutter',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    labelText: 'Mensaje (opcional)',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text('Hora: ${selectedTime.format(context)}'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (time != null) {
                          setState(() => selectedTime = time);
                        }
                      },
                      child: const Text('Cambiar'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isDaily,
                      onChanged: (v) => setState(() => isDaily = v ?? false),
                    ),
                    const Text('Repetir diariamente'),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  if (title.isNotEmpty) {
                    final now = DateTime.now();
                    final scheduledTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    ref
                        .read(remindersProvider.notifier)
                        .add(
                          Reminder(
                            title: title,
                            message: messageController.text.trim(),
                            scheduledTime: scheduledTime,
                            repeatType: isDaily ? 'daily' : 'once',
                          ),
                        );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Crear'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final bool isDark;
  final VoidCallback? onComplete;
  final VoidCallback onDelete;

  const _ReminderCard({
    required this.reminder,
    required this.isDark,
    this.onComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        state: reminder.isCompleted
            ? GlassCardState.normal
            : GlassCardState.normal,
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: isDark
                ? AppColors.darkOnSurfaceVariant
                : AppColors.lightOnSurfaceVariant,
          ),
          onSelected: (value) {
            if (value == 'complete' && onComplete != null) onComplete!();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            if (onComplete != null && !reminder.isCompleted)
              const PopupMenuItem(
                value: 'complete',
                child: Text('Marcar completado'),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        child: Row(
          children: [
            if (onComplete != null && !reminder.isCompleted)
              GestureDetector(
                onTap: onComplete,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.darkSecondary,
                      width: 2,
                    ),
                  ),
                ),
              )
            else if (reminder.isCompleted)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkSecondary,
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: reminder.isCompleted
                          ? (isDark
                                ? AppColors.darkOnSurfaceVariant
                                : AppColors.lightOnSurfaceVariant)
                          : (isDark
                                ? AppColors.darkOnSurface
                                : AppColors.lightOnSurface),
                      decoration: reminder.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (reminder.message != null &&
                      reminder.message!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      reminder.message!,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.lightOnSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: reminder.isDue && !reminder.isCompleted
                            ? AppColors.darkError
                            : (isDark
                                  ? AppColors.darkOnSurfaceVariant
                                  : AppColors.lightOnSurfaceVariant),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${reminder.scheduledTime.hour.toString().padLeft(2, '0')}:${reminder.scheduledTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: reminder.isDue && !reminder.isCompleted
                              ? AppColors.darkError
                              : (isDark
                                    ? AppColors.darkOnSurfaceVariant
                                    : AppColors.lightOnSurfaceVariant),
                        ),
                      ),
                      if (reminder.repeatType == 'daily') ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'DIARIO',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkPrimary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
