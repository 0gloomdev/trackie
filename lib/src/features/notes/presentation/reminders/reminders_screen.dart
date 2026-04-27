import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Reminders'),
      ),
      body: const Center(child: Text('Reminders Screen - Coming Soon')),
    );
  }
}
