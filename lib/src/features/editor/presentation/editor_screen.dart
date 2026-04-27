import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class EditorScreen extends ConsumerWidget {
  final dynamic item;
  const EditorScreen({super.key, this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Editor'),
      ),
      body: const Center(child: Text('Editor Screen')),
    );
  }
}
