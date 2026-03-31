import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../core/utils/translations.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final t = Translations(settings.locale);
    final faqs = FAQ.getDefaultFAQs();

    final filteredFAQs = _searchQuery.isEmpty
        ? faqs
        : faqs
              .where(
                (f) =>
                    f.pregunta.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    f.respuesta.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();

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
                    title: t.help,
                    subtitle: settings.locale == 'en'
                        ? 'Find answers to your questions'
                        : 'Encuentra respuestas a tus preguntas',
                  ),
                  const SizedBox(height: 24),
                  _SearchBar(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                  const SizedBox(height: 24),
                  _QuickActions(),
                  const SizedBox(height: 32),
                  _SectionTitle(title: t.faq),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _FAQItem(faq: filteredFAQs[index], index: index),
                childCount: filteredFAQs.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Header({required this.title, required this.subtitle});

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

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ShadcnInput(
      controller: controller,
      hintText: 'Buscar en ayuda...',
      prefixIcon: const Icon(Icons.search, color: Colors.white54),
      onChanged: onChanged,
    ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1);
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'icon': Icons.play_circle,
        'label': 'Tutorial',
        'color': AppColors.shadcnPrimary,
      },
      {
        'icon': Icons.message,
        'label': 'Contact',
        'color': AppColors.shadcnSecondary,
      },
      {'icon': Icons.star, 'label': 'Rate Us', 'color': Colors.amber},
      {'icon': Icons.description, 'label': 'Terms', 'color': Colors.green},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.asMap().entries.map((entry) {
        final action = entry.value;
        return _QuickActionItem(
          icon: action['icon'] as IconData,
          label: action['label'] as String,
          color: action['color'] as Color,
          index: entry.key,
        );
      }).toList(),
    ).animate(delay: 200.ms).fadeIn();
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int index;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(179)),
        ),
      ],
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

class _FAQItem extends StatefulWidget {
  final FAQ faq;
  final int index;

  const _FAQItem({required this.faq, required this.index});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ShadcnCard(
        padding: EdgeInsets.zero,
        hoverEffect: false,
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.pregunta,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: _isExpanded ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withAlpha(128),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  widget.faq.respuesta,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(179),
                    height: 1.5,
                  ),
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    ).animate(delay: (50 * widget.index).ms).fadeIn().slideY(begin: 0.05);
  }
}
