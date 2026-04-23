import 'package:flutter_riverpod/flutter_riverpod.dart';

final customizationProvider =
    NotifierProvider<CustomizationNotifier, CustomizationState>(
      CustomizationNotifier.new,
    );

class CustomizationState {
  final bool isDarkMode;
  final String fontFamily;
  final double fontSize;
  final bool compactMode;

  CustomizationState({
    this.isDarkMode = false,
    this.fontFamily = 'default',
    this.fontSize = 14.0,
    this.compactMode = false,
  });

  CustomizationState copyWith({
    bool? isDarkMode,
    String? fontFamily,
    double? fontSize,
    bool? compactMode,
  }) {
    return CustomizationState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      compactMode: compactMode ?? this.compactMode,
    );
  }
}

class CustomizationNotifier extends Notifier<CustomizationState> {
  @override
  CustomizationState build() => CustomizationState();

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void setFontFamily(String family) {
    state = state.copyWith(fontFamily: family);
  }

  void setFontSize(double size) {
    state = state.copyWith(fontSize: size);
  }

  void toggleCompactMode() {
    state = state.copyWith(compactMode: !state.compactMode);
  }
}
