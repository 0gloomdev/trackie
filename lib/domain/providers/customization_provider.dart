import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class CustomizationSettings {
  // Existing settings
  final String themePreset;
  final int accentColor;
  final double glassmorphismIntensity;
  final double animationSpeed;
  final double fontScale;
  final bool neonAccents;
  final bool glassEffects;

  // NEW: Extended settings
  final String borderRadiusStyle;
  final String animationStyle;
  final bool showShimmerLoading;
  final bool enableHapticFeedback;
  final double iconScale;
  final bool compactMode;
  final String layoutDensity;
  final bool enableAnimations;
  final bool enableGlowEffects;
  final int secondaryColor;

  const CustomizationSettings({
    // Existing defaults
    this.themePreset = 'cosmic',
    this.accentColor = 0xFFd3bfff,
    this.glassmorphismIntensity = 0.5,
    this.animationSpeed = 1.0,
    this.fontScale = 1.0,
    this.neonAccents = true,
    this.glassEffects = true,
    // NEW defaults
    this.borderRadiusStyle = 'rounded',
    this.animationStyle = 'smooth',
    this.showShimmerLoading = true,
    this.enableHapticFeedback = true,
    this.iconScale = 1.0,
    this.compactMode = false,
    this.layoutDensity = 'comfortable',
    this.enableAnimations = true,
    this.enableGlowEffects = true,
    this.secondaryColor = 0xFF5ce6ff,
  });

  CustomizationSettings copyWith({
    // Existing
    String? themePreset,
    int? accentColor,
    double? glassmorphismIntensity,
    double? animationSpeed,
    double? fontScale,
    bool? neonAccents,
    bool? glassEffects,
    // NEW
    String? borderRadiusStyle,
    String? animationStyle,
    bool? showShimmerLoading,
    bool? enableHapticFeedback,
    double? iconScale,
    bool? compactMode,
    String? layoutDensity,
    bool? enableAnimations,
    bool? enableGlowEffects,
    int? secondaryColor,
  }) {
    return CustomizationSettings(
      themePreset: themePreset ?? this.themePreset,
      accentColor: accentColor ?? this.accentColor,
      glassmorphismIntensity:
          glassmorphismIntensity ?? this.glassmorphismIntensity,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      fontScale: fontScale ?? this.fontScale,
      neonAccents: neonAccents ?? this.neonAccents,
      glassEffects: glassEffects ?? this.glassEffects,
      borderRadiusStyle: borderRadiusStyle ?? this.borderRadiusStyle,
      animationStyle: animationStyle ?? this.animationStyle,
      showShimmerLoading: showShimmerLoading ?? this.showShimmerLoading,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      iconScale: iconScale ?? this.iconScale,
      compactMode: compactMode ?? this.compactMode,
      layoutDensity: layoutDensity ?? this.layoutDensity,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      enableGlowEffects: enableGlowEffects ?? this.enableGlowEffects,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }

  Map<String, dynamic> toJson() => {
    // Existing
    'themePreset': themePreset,
    'accentColor': accentColor,
    'glassmorphismIntensity': glassmorphismIntensity,
    'animationSpeed': animationSpeed,
    'fontScale': fontScale,
    'neonAccents': neonAccents,
    'glassEffects': glassEffects,
    // NEW
    'borderRadiusStyle': borderRadiusStyle,
    'animationStyle': animationStyle,
    'showShimmerLoading': showShimmerLoading,
    'enableHapticFeedback': enableHapticFeedback,
    'iconScale': iconScale,
    'compactMode': compactMode,
    'layoutDensity': layoutDensity,
    'enableAnimations': enableAnimations,
    'enableGlowEffects': enableGlowEffects,
    'secondaryColor': secondaryColor,
  };

  factory CustomizationSettings.fromJson(Map<String, dynamic> json) =>
      CustomizationSettings(
        themePreset: json['themePreset'] ?? 'cosmic',
        accentColor: json['accentColor'] ?? 0xFFd3bfff,
        glassmorphismIntensity: (json['glassmorphismIntensity'] ?? 0.5)
            .toDouble(),
        animationSpeed: (json['animationSpeed'] ?? 1.0).toDouble(),
        fontScale: (json['fontScale'] ?? 1.0).toDouble(),
        neonAccents: json['neonAccents'] ?? true,
        glassEffects: json['glassEffects'] ?? true,
        borderRadiusStyle: json['borderRadiusStyle'] ?? 'rounded',
        animationStyle: json['animationStyle'] ?? 'smooth',
        showShimmerLoading: json['showShimmerLoading'] ?? true,
        enableHapticFeedback: json['enableHapticFeedback'] ?? true,
        iconScale: (json['iconScale'] ?? 1.0).toDouble(),
        compactMode: json['compactMode'] ?? false,
        layoutDensity: json['layoutDensity'] ?? 'comfortable',
        enableAnimations: json['enableAnimations'] ?? true,
        enableGlowEffects: json['enableGlowEffects'] ?? true,
        secondaryColor: json['secondaryColor'] ?? 0xFF5ce6ff,
      );
}

class CustomizationRepository {
  late Box<dynamic> _box;

  Future<void> init() async {
    _box = await Hive.openBox('customization_v2');
  }

  CustomizationSettings get() {
    final data = _box.get('settings');
    if (data == null) return const CustomizationSettings();
    return CustomizationSettings.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> save(CustomizationSettings settings) async {
    await _box.put('settings', settings.toJson());
  }
}

final customizationRepositoryProvider = Provider<CustomizationRepository>((
  ref,
) {
  throw UnimplementedError('Must be overridden in main.dart');
});

final customizationProvider =
    StateNotifierProvider<CustomizationNotifier, CustomizationSettings>(
      (ref) =>
          CustomizationNotifier(ref.watch(customizationRepositoryProvider)),
    );

class CustomizationNotifier extends StateNotifier<CustomizationSettings> {
  final CustomizationRepository _repo;

  CustomizationNotifier(this._repo) : super(const CustomizationSettings()) {
    _load();
  }

  void _load() {
    state = _repo.get();
  }

  Future<void> update(CustomizationSettings settings) async {
    await _repo.save(settings);
    state = settings;
  }

  // Existing methods
  Future<void> setThemePreset(String preset) async {
    final colors = _getPresetColors(preset);
    await update(
      state.copyWith(
        themePreset: preset,
        accentColor: colors['primary'],
        secondaryColor: colors['secondary'],
      ),
    );
  }

  Future<void> setAccentColor(int color) async {
    await update(state.copyWith(accentColor: color, themePreset: 'custom'));
  }

  Future<void> setGlassmorphismIntensity(double intensity) async {
    await update(state.copyWith(glassmorphismIntensity: intensity));
  }

  Future<void> setAnimationSpeed(double speed) async {
    await update(state.copyWith(animationSpeed: speed));
  }

  Future<void> setFontScale(double scale) async {
    await update(state.copyWith(fontScale: scale));
  }

  Future<void> toggleNeonAccents() async {
    await update(state.copyWith(neonAccents: !state.neonAccents));
  }

  Future<void> toggleGlassEffects() async {
    await update(state.copyWith(glassEffects: !state.glassEffects));
  }

  // NEW methods
  Future<void> setBorderRadiusStyle(String style) async {
    await update(state.copyWith(borderRadiusStyle: style));
  }

  Future<void> setAnimationStyle(String style) async {
    await update(state.copyWith(animationStyle: style));
  }

  Future<void> toggleShimmerLoading() async {
    await update(state.copyWith(showShimmerLoading: !state.showShimmerLoading));
  }

  Future<void> toggleHapticFeedback() async {
    await update(
      state.copyWith(enableHapticFeedback: !state.enableHapticFeedback),
    );
  }

  Future<void> setIconScale(double scale) async {
    await update(state.copyWith(iconScale: scale));
  }

  Future<void> toggleCompactMode() async {
    await update(state.copyWith(compactMode: !state.compactMode));
  }

  Future<void> setLayoutDensity(String density) async {
    await update(state.copyWith(layoutDensity: density));
  }

  Future<void> toggleAnimations() async {
    await update(state.copyWith(enableAnimations: !state.enableAnimations));
  }

  Future<void> toggleGlowEffects() async {
    await update(state.copyWith(enableGlowEffects: !state.enableGlowEffects));
  }

  Future<void> setSecondaryColor(int color) async {
    await update(state.copyWith(secondaryColor: color));
  }

  Map<String, int> _getPresetColors(String preset) {
    switch (preset) {
      case 'cosmic':
        return {'primary': 0xFFd3bfff, 'secondary': 0xFF5ce6ff};
      case 'ocean':
        return {'primary': 0xFF5ce6ff, 'secondary': 0xFF22C55E};
      case 'forest':
        return {'primary': 0xFF22C55E, 'secondary': 0xFF5ce6ff};
      case 'fire':
        return {'primary': 0xFFff6b35, 'secondary': 0xFFfbbf24};
      case 'void':
        return {'primary': 0xFF8b5cf6, 'secondary': 0xFFec4899};
      case 'sunset':
        return {'primary': 0xFFffb5c8, 'secondary': 0xFFfb923c};
      case 'minimal':
        return {'primary': 0xFF64748B, 'secondary': 0xFF94a3b8};
      case 'brutalist':
        return {'primary': 0xFF000000, 'secondary': 0xFFffffff};
      case 'neon':
        return {'primary': 0xFF39FF14, 'secondary': 0xFF00FFFF};
      case 'pastel':
        return {'primary': 0xFFFCE7F3, 'secondary': 0xFFA7F3D0};
      case 'oceanic':
        return {'primary': 0xFF0EA5E9, 'secondary': 0xFF06B6D4};
      case 'sunset-glow':
        return {'primary': 0xFFFB923C, 'secondary': 0xFFF97316};
      default:
        return {'primary': 0xFFd3bfff, 'secondary': 0xFF5ce6ff};
    }
  }

  static List<Map<String, dynamic>> get themePresets => [
    {
      'id': 'cosmic',
      'name': 'Cosmic',
      'color': 0xFFd3bfff,
      'description': 'Purple nebula theme',
      'style': 'glassmorphism',
    },
    {
      'id': 'ocean',
      'name': 'Ocean',
      'color': 0xFF5ce6ff,
      'description': 'Cyan deep sea',
      'style': 'gradient',
    },
    {
      'id': 'forest',
      'name': 'Forest',
      'color': 0xFF22C55E,
      'description': 'Green nature',
      'style': 'flat',
    },
    {
      'id': 'fire',
      'name': 'Fire',
      'color': 0xFFff6b35,
      'description': 'Orange flame',
      'style': 'vibrant',
    },
    {
      'id': 'void',
      'name': 'Void',
      'color': 0xFF8b5cf6,
      'description': 'Dark purple',
      'style': 'dark',
    },
    {
      'id': 'sunset',
      'name': 'Sunset',
      'color': 0xFFffb5c8,
      'description': 'Pink sunset',
      'style': 'soft',
    },
    {
      'id': 'minimal',
      'name': 'Minimal',
      'color': 0xFF64748B,
      'description': 'Clean slate',
      'style': 'flat',
    },
    {
      'id': 'brutalist',
      'name': 'Brutalist',
      'color': 0xFF000000,
      'description': 'Bold contrast',
      'style': 'bold',
    },
    {
      'id': 'neon',
      'name': 'Neon',
      'color': 0xFF39FF14,
      'description': 'Glowing green',
      'style': 'glow',
    },
    {
      'id': 'pastel',
      'name': 'Pastel',
      'color': 0xFFFCE7F3,
      'description': 'Soft colors',
      'style': 'soft',
    },
    {
      'id': 'oceanic',
      'name': 'Oceanic',
      'color': 0xFF0EA5E9,
      'description': 'Deep blue',
      'style': 'gradient',
    },
    {
      'id': 'sunset-glow',
      'name': 'Sunset Glow',
      'color': 0xFFFB923C,
      'description': 'Warm orange',
      'style': 'gradient',
    },
  ];

  static List<Map<String, dynamic>> get borderRadiusStyles => [
    {
      'id': 'rounded',
      'name': 'Rounded',
      'description': 'Smooth corners (16px)',
    },
    {'id': 'square', 'name': 'Square', 'description': 'Sharp corners (4px)'},
    {'id': 'pill', 'name': 'Pill', 'description': 'Fully rounded'},
    {'id': 'mixed', 'name': 'Mixed', 'description': 'Varied corners'},
  ];

  static List<Map<String, dynamic>> get animationStyles => [
    {'id': 'smooth', 'name': 'Smooth', 'description': 'Ease in-out'},
    {'id': 'elastic', 'name': 'Elastic', 'description': 'Bouncy feel'},
    {'id': 'bounce', 'name': 'Bounce', 'description': 'Spring effect'},
    {'id': 'linear', 'name': 'Linear', 'description': 'Constant speed'},
  ];

  static List<Map<String, dynamic>> get layoutDensityOptions => [
    {
      'id': 'comfortable',
      'name': 'Comfortable',
      'description': 'Standard spacing',
    },
    {'id': 'compact', 'name': 'Compact', 'description': 'Tight spacing'},
    {
      'id': 'spacious',
      'name': 'Spacious',
      'description': 'Extra breathing room',
    },
  ];

  static List<int> get accentColorOptions => [
    0xFFd3bfff,
    0xFF5ce6ff,
    0xFF22C55E,
    0xFFff6b35,
    0xFF8b5cf6,
    0xFFffb5c8,
    0xFFfbbf24,
    0xFFef4444,
    0xFF3b82f6,
    0xFFec4899,
    0xFF14b8a6,
    0xFFa855f7,
  ];

  static List<int> get secondaryColorOptions => [
    0xFF5ce6ff,
    0xFFd3bfff,
    0xFF22C55E,
    0xFFff6b35,
    0xFF8b5cf6,
    0xFFffb5c8,
    0xFFfbbf24,
    0xFFef4444,
    0xFF3b82f6,
    0xFFec4899,
    0xFF14b8a6,
    0xFFa855f7,
  ];
}
