import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_design.dart';
import '../../shared/providers/customization_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customization = ref.watch(customizationProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          customization.compactMode
              ? DesignTokens.spaceMd
              : DesignTokens.spaceXl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: AppTypography.pageTitle),
            const SizedBox(height: DesignTokens.spaceLg),
            Text('Settings coming soon', style: AppTypography.body),
          ],
        ),
      ),
    );
  }
}
