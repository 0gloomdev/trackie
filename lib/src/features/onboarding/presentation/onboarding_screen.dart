import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/providers/drift_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      ref.read(settingsNotifierProvider.notifier).completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      body: Stack(
        children: [
          _BackgroundGlow(),
          SafeArea(
            child: Column(
              children: [
                _SkipButton(
                  onSkip: () => ref
                      .read(settingsNotifierProvider.notifier)
                      .completeOnboarding(),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                    children: [
                      _OnboardingPage(
                        icon: Icons.folder_copy,
                        title: 'Save your content',
                        description:
                            'Add links, videos, courses and more. Organize everything in one place.',
                        color: AppColors.shadcnPrimary,
                        pageIndex: 0,
                      ),
                      _OnboardingPage(
                        icon: Icons.timer,
                        title: 'Use Pomodoro',
                        description:
                            'Stay focused with 25-minute study sessions.',
                        color: AppColors.shadcnSecondary,
                        pageIndex: 1,
                      ),
                      _OnboardingPage(
                        icon: Icons.emoji_events,
                        title: 'Earn achievements',
                        description:
                            'Complete tasks and unlock achievements as you learn.',
                        color: AppColors.tertiary,
                        pageIndex: 2,
                      ),
                    ],
                  ),
                ),
                _PageIndicator(currentPage: _currentPage),
                const SizedBox(height: 32),
                _NextButton(currentPage: _currentPage, onNext: _nextPage),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.shadcnPrimary.withAlpha(51),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadcnPrimary.withAlpha(77),
                  blurRadius: 150,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.shadcnSecondary.withAlpha(51),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadcnSecondary.withAlpha(77),
                  blurRadius: 100,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SkipButton extends StatelessWidget {
  final VoidCallback onSkip;

  const _SkipButton({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: TextButton(
          onPressed: onSkip,
          child: Text(
            'Saltar',
            style: TextStyle(
              color: Colors.white.withAlpha(179),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final int pageIndex;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final bentoCards = [
      {
        'icon': Icons.folder_copy,
        'title': 'Save',
        'subtitle': 'Links & Content',
      },
      {'icon': Icons.timer, 'title': 'Focus', 'subtitle': 'Pomodoro Timer'},
      {'icon': Icons.emoji_events, 'title': 'Achieve', 'subtitle': 'Earn XP'},
    ];

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bento Grid Effect
          Stack(
            alignment: Alignment.center,
            children: [
              // Ambient glow
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withAlpha(51),
                      color.withAlpha(13),
                      Colors.transparent,
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 800.ms),
              // Main Icon Container
              Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [color.withAlpha(51), color.withAlpha(26)],
                      ),
                      border: Border.all(color: color.withAlpha(77), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: color.withAlpha(77),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: color.withAlpha(38),
                          blurRadius: 80,
                          spreadRadius: -20,
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 64, color: color),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
            ],
          ),
          const SizedBox(height: 48),
          // Title with gradient
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.white, Colors.white.withAlpha(179)],
            ).createShader(bounds),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -1.5,
                height: 1.1,
              ),
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2),
          const SizedBox(height: 16),
          // Description
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(13),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(26)),
            ),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withAlpha(179),
                height: 1.5,
              ),
            ),
          ).animate(delay: 400.ms).fadeIn(duration: 600.ms),
          const SizedBox(height: 32),
          // Feature indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isActive = index == pageIndex;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? color.withAlpha(26)
                      : Colors.white.withAlpha(13),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? color.withAlpha(77)
                        : Colors.white.withAlpha(26),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      bentoCards[index]['icon'] as IconData,
                      size: 14,
                      color: isActive ? color : Colors.white.withAlpha(128),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      bentoCards[index]['title'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? color : Colors.white.withAlpha(128),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ).animate(delay: 600.ms).fadeIn(),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentPage;

  const _PageIndicator({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.shadcnPrimary
                : Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    ).animate(delay: 300.ms).fadeIn();
  }
}

class _NextButton extends StatelessWidget {
  final int currentPage;
  final VoidCallback onNext;

  const _NextButton({required this.currentPage, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: GestureDetector(
        onTap: onNext,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadcnPrimary.withAlpha(102),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              isLastPage ? 'Comenzar' : 'Siguiente',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2);
  }
}
