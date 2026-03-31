import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../core/utils/translations.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final t = Translations(settings.locale);
    final reminders = ref.watch(remindersProvider);
    final pendingReminders = reminders.where((r) => !r.isCompleted).toList();
    final completedReminders = reminders.where((r) => r.isCompleted).toList();

    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              pendingCount: pendingReminders.length,
              onAddReminder: () => _showAddReminderDialog(context, ref),
              title: t.reminders,
              subtitle:
                  '${pendingReminders.length} ${settings.locale == 'en' ? (pendingReminders.length > 1 ? 'pending' : 'pending') : (pendingReminders.length > 1 ? 'pendientes' : 'pendiente')}',
            ),
            const SizedBox(height: 24),
            Expanded(
              child: reminders.isEmpty
                  ? _EmptyState(
                      onAddReminder: () => _showAddReminderDialog(context, ref),
                    )
                  : _RemindersList(
                      pendingReminders: pendingReminders,
                      completedReminders: completedReminders,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ReminderEditorSheet(),
    );
  }
}

class _Header extends StatelessWidget {
  final int pendingCount;
  final VoidCallback onAddReminder;
  final String title;
  final String subtitle;

  const _Header({
    required this.pendingCount,
    required this.onAddReminder,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                color: Colors.white,
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
            const SizedBox(height: 4),
            if (pendingCount > 0)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.shadcnSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ).animate(delay: 100.ms).fadeIn(duration: 600.ms),
          ],
        ),
        _AddButton(onTap: onAddReminder),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadcnPrimary.withAlpha(77),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8));
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddReminder;

  const _EmptyState({required this.onAddReminder});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.shadcnPrimary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 40,
              color: AppColors.shadcnPrimary.withAlpha(128),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay recordatorios',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea un recordatorio para no olvidar',
            style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(128)),
          ),
          const SizedBox(height: 24),
          ShadcnButton(
            onPressed: onAddReminder,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Crear recordatorio',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

class _RemindersList extends ConsumerWidget {
  final List<Reminder> pendingReminders;
  final List<Reminder> completedReminders;

  const _RemindersList({
    required this.pendingReminders,
    required this.completedReminders,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        if (pendingReminders.isNotEmpty) ...[
          SliverToBoxAdapter(child: _SectionTitle(title: 'Pendientes')),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _ReminderCard(
                reminder: pendingReminders[index],
                index: index,
              ),
              childCount: pendingReminders.length,
            ),
          ),
        ],
        if (completedReminders.isNotEmpty) ...[
          SliverToBoxAdapter(child: _SectionTitle(title: 'Completados')),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _ReminderCard(
                reminder: completedReminders[index],
                index: index + pendingReminders.length,
              ),
              childCount: completedReminders.length,
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: Colors.white.withAlpha(128),
        ),
      ),
    );
  }
}

class _ReminderCard extends ConsumerWidget {
  final Reminder reminder;
  final int index;

  const _ReminderCard({required this.reminder, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverdue =
        !reminder.isCompleted &&
        reminder.scheduledTime.isBefore(DateTime.now());

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ShadcnCard(
        padding: const EdgeInsets.all(16),
        hoverEffect: true,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => ref
                  .read(remindersProvider.notifier)
                  .markCompleted(reminder.id),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: reminder.isCompleted
                      ? AppColors.shadcnPrimary
                      : Colors.transparent,
                  border: Border.all(
                    color: reminder.isCompleted
                        ? AppColors.shadcnPrimary
                        : isOverdue
                        ? Colors.red
                        : Colors.white54,
                    width: 2,
                  ),
                ),
                child: reminder.isCompleted
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: reminder.isCompleted
                          ? Colors.white54
                          : Colors.white,
                      decoration: reminder.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isOverdue
                            ? Colors.red
                            : Colors.white.withAlpha(128),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDateTime(reminder.scheduledTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: isOverdue
                              ? Colors.red
                              : Colors.white.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red.shade400,
                size: 20,
              ),
              onPressed: () =>
                  ref.read(remindersProvider.notifier).delete(reminder.id),
            ),
          ],
        ),
      ),
    ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.05);
  }

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();

    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today ${_formatTime(date)}';
    } else if (date.day == now.day + 1 &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Tomorrow ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month} ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _ReminderEditorSheet extends ConsumerStatefulWidget {
  const _ReminderEditorSheet();

  @override
  ConsumerState<_ReminderEditorSheet> createState() =>
      _ReminderEditorSheetState();
}

class _ReminderEditorSheetState extends ConsumerState<_ReminderEditorSheet> {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColors.shadcnBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShadcnButton(
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.white.withAlpha(26),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      'New Reminder',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ShadcnButton(
                      onPressed: _saveReminder,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Save', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ShadcnInput(
                  controller: _titleController,
                  hintText: 'Reminder title',
                ),
                const SizedBox(height: 16),
                Text(
                  'Fecha y hora',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DateTimeButton(
                        icon: Icons.calendar_today,
                        label:
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        onTap: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateTimeButton(
                        icon: Icons.access_time,
                        label:
                            '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                        onTap: _pickTime,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.3);
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(
        () => _selectedDate = DateTime(
          date.year,
          date.month,
          date.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
      );
    }
  }

  void _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  void _saveReminder() {
    if (_titleController.text.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final dueDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    ref
        .read(remindersProvider.notifier)
        .add(Reminder(title: _titleController.text, scheduledTime: dueDate));
    Navigator.pop(context);
  }
}

class _DateTimeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DateTimeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(13),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withAlpha(26)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.shadcnSecondary, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
