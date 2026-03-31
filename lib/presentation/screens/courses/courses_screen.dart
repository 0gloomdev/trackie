import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../core/utils/translations.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';
import '../editor/editor_screen.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final t = Translations(settings.locale);
    final items = ref.watch(learningItemsProvider);
    final courses = items.where((i) => i.type == 'course').toList();
    final inProgress = courses.where((i) => i.status == 'in_progress').toList();
    final completed = courses.where((i) => i.status == 'completed').toList();

    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(
                    totalCourses: courses.length,
                    title: t.courses,
                    subtitle:
                        '${courses.length} ${courses.length != 1 ? (settings.locale == 'en' ? 'courses' : 'cursos') : (settings.locale == 'en' ? 'course' : 'curso')} ${settings.locale == 'en' ? 'total' : 'en total'}',
                  ),
                  const SizedBox(height: 24),
                  _StatsRow(
                    inProgress: inProgress.length,
                    completed: completed.length,
                    pending:
                        courses.length - inProgress.length - completed.length,
                  ),
                  const SizedBox(height: 32),
                  if (inProgress.isNotEmpty) ...[
                    _SectionTitle(title: 'In Progress'),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
          if (inProgress.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _CourseCard(item: inProgress[index], index: index),
                  childCount: inProgress.length,
                ),
              ),
            ),
          if (completed.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _SectionTitle(title: 'Completados'),
              ),
            ),
          if (completed.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _CourseCard(
                    item: inProgress.isNotEmpty
                        ? completed[index]
                        : completed[index],
                    index: inProgress.length + index,
                  ),
                  childCount: completed.length,
                ),
              ),
            ),
          if (courses.isEmpty) SliverFillRemaining(child: _EmptyState()),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int totalCourses;
  final String title;
  final String subtitle;

  const _Header({
    required this.totalCourses,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Text(
          subtitle,
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

class _StatsRow extends StatelessWidget {
  final int inProgress;
  final int completed;
  final int pending;

  const _StatsRow({
    required this.inProgress,
    required this.completed,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            label: 'En progreso',
            value: inProgress,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            label: 'Completados',
            value: completed,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            label: 'Pendientes',
            value: pending,
            color: Colors.grey,
          ),
        ),
      ],
    ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1);
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(179)),
          ),
        ],
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

class _CourseCard extends StatelessWidget {
  final LearningItem item;
  final int index;

  const _CourseCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final isCompleted = item.status == 'completed';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ShadcnCard(
        padding: const EdgeInsets.all(16),
        hoverEffect: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditorScreen(item: item)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green.withAlpha(26)
                    : AppColors.shadcnPrimary.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.play_circle,
                color: isCompleted ? Colors.green : AppColors.shadcnPrimary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(children: [_StatusBadge(status: item.status)]),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withAlpha(77)),
          ],
        ),
      ),
    ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.05);
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'completed':
        color = Colors.green;
        label = 'Completado';
        break;
      case 'in_progress':
        color = Colors.orange;
        label = 'En progreso';
        break;
      default:
        color = Colors.grey;
        label = 'Pendiente';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
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
              Icons.school,
              size: 40,
              color: AppColors.shadcnPrimary.withAlpha(128),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No courses yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primer curso para comenzar',
            style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(128)),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}
