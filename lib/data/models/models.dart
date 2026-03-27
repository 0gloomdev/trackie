import 'package:uuid/uuid.dart';

class LearningItem {
  final String id;
  final String title;
  final String type;
  final String? description;
  final String? url;
  final String? urlFavicon;
  final String? urlThumbnail;
  final String? localPath;
  final int progress;
  final String status;
  final String? priority;
  final String? categoryId;
  final List<String> tags;
  final String? notes;
  final bool isFavorite;
  final bool isPinned;
  final DateTime? lastAccessedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  LearningItem({
    String? id,
    required this.title,
    required this.type,
    this.description,
    this.url,
    this.urlFavicon,
    this.urlThumbnail,
    this.localPath,
    this.progress = 0,
    this.status = 'pending',
    this.priority,
    this.categoryId,
    this.tags = const [],
    this.notes,
    this.isFavorite = false,
    this.isPinned = false,
    this.lastAccessedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  LearningItem copyWith({
    String? id,
    String? title,
    String? type,
    String? description,
    String? url,
    String? urlFavicon,
    String? urlThumbnail,
    String? localPath,
    int? progress,
    String? status,
    String? priority,
    String? categoryId,
    List<String>? tags,
    String? notes,
    bool? isFavorite,
    bool? isPinned,
    DateTime? lastAccessedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LearningItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      url: url ?? this.url,
      urlFavicon: urlFavicon ?? this.urlFavicon,
      urlThumbnail: urlThumbnail ?? this.urlThumbnail,
      localPath: localPath ?? this.localPath,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      isPinned: isPinned ?? this.isPinned,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type,
    'description': description,
    'url': url,
    'urlFavicon': urlFavicon,
    'urlThumbnail': urlThumbnail,
    'localPath': localPath,
    'progress': progress,
    'status': status,
    'priority': priority,
    'categoryId': categoryId,
    'tags': tags,
    'notes': notes,
    'isFavorite': isFavorite,
    'isPinned': isPinned,
    'lastAccessedAt': lastAccessedAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory LearningItem.fromJson(Map<String, dynamic> json) => LearningItem(
    id: json['id'],
    title: json['title'],
    type: json['type'],
    description: json['description'],
    url: json['url'],
    urlFavicon: json['urlFavicon'],
    urlThumbnail: json['urlThumbnail'],
    localPath: json['localPath'],
    progress: json['progress'] ?? 0,
    status: json['status'] ?? 'pending',
    priority: json['priority'],
    categoryId: json['categoryId'],
    tags: List<String>.from(json['tags'] ?? []),
    notes: json['notes'],
    isFavorite: json['isFavorite'] ?? false,
    isPinned: json['isPinned'] ?? false,
    lastAccessedAt: json['lastAccessedAt'] != null
        ? DateTime.parse(json['lastAccessedAt'])
        : null,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}

class Category {
  final String id;
  final String name;
  final int color;
  final DateTime createdAt;
  Category({
    String? id,
    required this.name,
    this.color = 0xFF6366F1,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    'createdAt': createdAt.toIso8601String(),
  };
  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    color: json['color'] ?? 0xFF6366F1,
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class Tag {
  final String id;
  final String name;
  final int color;
  Tag({String? id, required this.name, this.color = 0xFF6366F1})
    : id = id ?? const Uuid().v4();
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'color': color};
  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(id: json['id'], name: json['name'], color: json['color']);
}

class AppSettings {
  final String theme;
  final bool showOnboarding;
  final bool notificationsEnabled;
  final String defaultView;
  final bool compactMode;
  AppSettings({
    this.theme = 'system',
    this.showOnboarding = true,
    this.notificationsEnabled = false,
    this.defaultView = 'grid',
    this.compactMode = false,
  });
  AppSettings copyWith({
    String? theme,
    bool? showOnboarding,
    bool? notificationsEnabled,
    String? defaultView,
    bool? compactMode,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      showOnboarding: showOnboarding ?? this.showOnboarding,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultView: defaultView ?? this.defaultView,
      compactMode: compactMode ?? this.compactMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'theme': theme,
    'showOnboarding': showOnboarding,
    'notificationsEnabled': notificationsEnabled,
    'defaultView': defaultView,
    'compactMode': compactMode,
  };
  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    theme: json['theme'] ?? 'system',
    showOnboarding: json['showOnboarding'] ?? true,
    notificationsEnabled: json['notificationsEnabled'] ?? false,
    defaultView: json['defaultView'] ?? 'grid',
    compactMode: json['compactMode'] ?? false,
  );
}
