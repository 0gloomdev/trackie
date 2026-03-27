import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/providers/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < AppConstants.onboardingSteps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      ref.read(settingsProvider.notifier).completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      [const Color(0xFFEC4899), const Color(0xFFF43F5E)],
      [const Color(0xFF14B8A6), const Color(0xFF06B6D4)],
      [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
      [const Color(0xFF22C55E), const Color(0xFF10B981)],
    ];

    final currentColors = colors[_currentPage % colors.length];

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  currentColors[0].withValues(alpha: 0.15),
                  currentColors[1].withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
          ),

          // Floating shapes
          _FloatingShape(
            color: currentColors[0].withValues(alpha: 0.3),
            size: 180,
            top: -60,
            right: -40,
          ),
          _FloatingShape(
            color: currentColors[1].withValues(alpha: 0.2),
            size: 120,
            bottom: 150,
            left: -30,
          ),
          _FloatingShape(
            color: currentColors[0].withValues(alpha: 0.15),
            size: 80,
            top: 150,
            left: 40,
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: currentColors),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: currentColors[0].withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref
                            .read(settingsProvider.notifier)
                            .completeOnboarding(),
                        child: Text(
                          'Saltar',
                          style: TextStyle(
                            color: currentColors[0],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: AppConstants.onboardingSteps.length,
                    itemBuilder: (context, index) => _OnboardingPage(
                      step: AppConstants.onboardingSteps[index],
                      colors: colors[index % colors.length],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          AppConstants.onboardingSteps.length,
                          (i) => _Dot(
                            isActive: i == _currentPage,
                            color: currentColors[0],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Button
                      GestureDetector(
                        onTap: _nextPage,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: currentColors),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: currentColors[0].withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _currentPage ==
                                      AppConstants.onboardingSteps.length - 1
                                  ? 'Comenzar'
                                  : 'Continuar',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingShape extends StatelessWidget {
  final Color color;
  final double size;
  final double top;
  final double right;
  final double bottom;
  final double left;

  const _FloatingShape({
    required this.color,
    required this.size,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
          boxShadow: [
            BoxShadow(color: color, blurRadius: 40, spreadRadius: 10),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingStep step;
  final List<Color> colors;

  const _OnboardingPage({required this.step, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors[0].withValues(alpha: 0.2),
                  colors[1].withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: colors[0].withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors[0].withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Icon(_getIcon(step.icon), size: 70, color: colors[0]),
          ),
          const SizedBox(height: 48),
          Text(
            step.title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'school':
        return Icons.school;
      case 'add_circle':
        return Icons.add_circle;
      case 'label':
        return Icons.label;
      case 'trending_up':
        return Icons.trending_up;
      case 'celebration':
        return Icons.celebration;
      default:
        return Icons.arrow_forward;
    }
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _Dot({required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 28 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? color : color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(5),
        boxShadow: isActive
            ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8)]
            : null,
      ),
    );
  }
}
