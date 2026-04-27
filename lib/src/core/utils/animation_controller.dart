import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/shared/providers/drift_providers.dart';
import '../../features/shared/providers/customization_provider.dart';

class AnimationToggle extends ConsumerWidget {
  final Widget child;

  const AnimationToggle({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reducedMotion = ref.watch(reducedMotionProvider);
    final customization = ref.watch(customizationProvider);

    final disableAnimation = reducedMotion || customization.compactMode;

    return InheritedAnimation(enabled: !disableAnimation, child: child);
  }
}

class InheritedAnimation extends InheritedWidget {
  final bool enabled;

  const InheritedAnimation({
    super.key,
    required this.enabled,
    required super.child,
  });

  static bool of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<InheritedAnimation>();
    return result?.enabled ?? true;
  }

  @override
  bool updateShouldNotify(InheritedAnimation oldWidget) =>
      enabled != oldWidget.enabled;
}

extension AnimationEnabled on BuildContext {
  bool get animationsEnabled => InheritedAnimation.of(this);
}
