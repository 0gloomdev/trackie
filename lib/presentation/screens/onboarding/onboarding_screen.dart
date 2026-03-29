import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/providers/providers.dart';

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
      ref.read(settingsProvider.notifier).completeOnboarding();
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
                  onSkip: () =>
                      ref.read(settingsProvider.notifier).completeOnboarding(),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                    children: const [
                      _OnboardingPage(
                        icon: Icons.folder_copy,
                        title: 'Guarda tu contenido',
                        description:
                            'Agrega enlaces, videos, cursos y más. Organiza todo en un solo lugar.',
                        color: AppColors.shadcnPrimary,
                      ),
                      _OnboardingPage(
                        icon: Icons.timer,
                        title: 'Usa el Pomodoro',
                        description:
                            'Mantén el enfoque con sesiones de estudio de 25 minutos.',
                        color: AppColors.shadcnSecondary,
                      ),
                      _OnboardingPage(
                        icon: Icons.emoji_events,
                        title: 'Gana logros',
                        description:
                            'Completa tareas y desbloquea logros mientras aprendes.',
                        color: Colors.amber,
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

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(77),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Icon(icon, size: 56, color: color),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withAlpha(179),
              height: 1.5,
            ),
          ).animate(delay: 400.ms).fadeIn(duration: 600.ms),
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
