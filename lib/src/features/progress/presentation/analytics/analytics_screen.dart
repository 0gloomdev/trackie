import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_design.dart';
import '../../../shared/providers/drift_providers.dart';
import '../../../shared/providers/customization_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(analyticsProvider);
    final customization = ref.watch(customizationProvider);
    final effectivePadding = customization.compactMode
        ? DesignTokens.spaceMd
        : DesignTokens.spaceXl;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: activitiesAsync.when(
        data: (activities) => SingleChildScrollView(
          padding: EdgeInsets.all(effectivePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Analytics', style: AppTypography.pageTitle),
              const SizedBox(height: DesignTokens.spaceMd),
              Text('Activities: ${activities.length}'),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
