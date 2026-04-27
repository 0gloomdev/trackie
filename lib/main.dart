import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/theme/app_theme.dart';
import 'src/core/theme/app_colors.dart';
import 'src/services/database/database_provider.dart';
import 'src/features/shared/providers/drift_providers.dart';
import 'src/features/shared/main_navigation.dart';
import 'src/features/onboarding/presentation/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ProviderScope(child: AuraLearningApp()));
}

class AuraLearningApp extends ConsumerWidget {
  const AuraLearningApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(databaseProvider);
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      data: (settings) {
        if (settings == null) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          );
        }
        final isDark =
            settings.theme == 'dark' ||
            (settings.theme == 'system' &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);
        AppColors.tertiary = isDark
            ? AppColors.darkTertiary
            : AppColors.lightTertiary;

        return MaterialApp(
          title: 'Trackie',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.theme == 'system'
              ? ThemeMode.system
              : settings.theme == 'dark'
              ? ThemeMode.dark
              : ThemeMode.light,
          themeAnimationDuration: const Duration(milliseconds: 400),
          themeAnimationCurve: Curves.easeInOut,
          home: settings.hasCompletedOnboarding
              ? const MainNavigation()
              : const OnboardingScreen(),
        );
      },
      loading: () => MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ),
      error: (e, _) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Error: $e'))),
      ),
    );
  }
}
