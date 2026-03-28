import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../data/models/models.dart';

class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                    'Ayuda',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Search
                  GlassTextField(
                    hintText: 'Buscar en ayuda...',
                    prefixIcon: Icons.search,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Categories
                  Text(
                    'Categorías',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _CategoryChip(
                        label: 'Primeros pasos',
                        icon: Icons.rocket_launch,
                        isDark: isDark,
                        onTap: () {},
                      ),
                      _CategoryChip(
                        label: 'Biblioteca',
                        icon: Icons.auto_stories,
                        isDark: isDark,
                        onTap: () {},
                      ),
                      _CategoryChip(
                        label: 'Logros',
                        icon: Icons.military_tech,
                        isDark: isDark,
                        onTap: () {},
                      ),
                      _CategoryChip(
                        label: 'Datos',
                        icon: Icons.storage,
                        isDark: isDark,
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Preguntas Frecuentes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // FAQ List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final faq = filteredFAQs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _FAQCard(faq: faq, isDark: isDark),
                );
              }, childCount: filteredFAQs.length),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassChip(
      label: label,
      icon: icon,
      isSelected: false,
      onTap: onTap,
      activeColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
    );
  }
}

class _FAQCard extends StatefulWidget {
  final FAQ faq;
  final bool isDark;

  const _FAQCard({required this.faq, required this.isDark});

  @override
  State<_FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<_FAQCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return GlassCard(
      onTap: () {
        setState(() => _expanded = !_expanded);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.faq.pregunta,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkOnSurface
                        : AppColors.lightOnSurface,
                  ),
                ),
              ),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.lightOnSurfaceVariant,
              ),
            ],
          ),
          if (_expanded) ...[
            const SizedBox(height: 12),
            Text(
              widget.faq.respuesta,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.lightOnSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
