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
    id: json['id'] as String,
    title: json['title'] as String,
    type: json['type'] as String,
    description: json['description'] as String?,
    url: json['url'] as String?,
    urlFavicon: json['urlFavicon'] as String?,
    urlThumbnail: json['urlThumbnail'] as String?,
    localPath: json['localPath'] as String?,
    progress: json['progress'] as int? ?? 0,
    status: json['status'] as String? ?? 'pending',
    priority: json['priority'] as String?,
    categoryId: json['categoryId'] as String?,
    tags: (json['tags'] as List?)?.cast<String>() ?? [],
    notes: json['notes'] as String?,
    isFavorite: json['isFavorite'] as bool? ?? false,
    isPinned: json['isPinned'] as bool? ?? false,
    lastAccessedAt: json['lastAccessedAt'] != null
        ? DateTime.parse(json['lastAccessedAt'] as String)
        : null,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
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
    id: json['id'] as String,
    name: json['name'] as String,
    color: json['color'] as int? ?? 0xFF6366F1,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

class Tag {
  final String id;
  final String name;
  final int color;
  final String? category;
  final int usageCount;
  final DateTime createdAt;

  Tag({
    String? id,
    required this.name,
    this.color = 0xFF6366F1,
    this.category,
    this.usageCount = 0,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Tag copyWith({
    String? id,
    String? name,
    int? color,
    String? category,
    int? usageCount,
    DateTime? createdAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      category: category ?? this.category,
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    'category': category,
    'usageCount': usageCount,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    id: json['id'] as String,
    name: json['name'] as String,
    color: json['color'] as int? ?? 0xFF6366F1,
    category: json['category'] as String?,
    usageCount: json['usageCount'] as int? ?? 0,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now(),
  );
}

class AppSettings {
  final String theme;
  final bool showOnboarding;
  final bool notificationsEnabled;
  final bool pomodoroNotifications;
  final bool achievementsNotifications;
  final String defaultView;
  final bool compactMode;
  final bool pinLockEnabled;
  final String? pinCode;
  final bool autoBackupEnabled;
  final int autoBackupFrequency;
  final DateTime? lastBackupDate;
  final String locale;

  AppSettings({
    this.theme = 'system',
    this.showOnboarding = true,
    this.notificationsEnabled = true,
    this.pomodoroNotifications = true,
    this.achievementsNotifications = true,
    this.defaultView = 'grid',
    this.compactMode = false,
    this.pinLockEnabled = false,
    this.pinCode,
    this.autoBackupEnabled = false,
    this.autoBackupFrequency = 7,
    this.lastBackupDate,
    this.locale = 'en',
  });

  AppSettings copyWith({
    String? theme,
    bool? showOnboarding,
    bool? notificationsEnabled,
    bool? pomodoroNotifications,
    bool? achievementsNotifications,
    String? defaultView,
    bool? compactMode,
    bool? pinLockEnabled,
    String? pinCode,
    bool? autoBackupEnabled,
    int? autoBackupFrequency,
    DateTime? lastBackupDate,
    String? locale,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      showOnboarding: showOnboarding ?? this.showOnboarding,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      pomodoroNotifications:
          pomodoroNotifications ?? this.pomodoroNotifications,
      achievementsNotifications:
          achievementsNotifications ?? this.achievementsNotifications,
      defaultView: defaultView ?? this.defaultView,
      compactMode: compactMode ?? this.compactMode,
      pinLockEnabled: pinLockEnabled ?? this.pinLockEnabled,
      pinCode: pinCode ?? this.pinCode,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      autoBackupFrequency: autoBackupFrequency ?? this.autoBackupFrequency,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      locale: locale ?? this.locale,
    );
  }

  Map<String, dynamic> toJson() => {
    'theme': theme,
    'showOnboarding': showOnboarding,
    'notificationsEnabled': notificationsEnabled,
    'achievementsNotifications': achievementsNotifications,
    'defaultView': defaultView,
    'compactMode': compactMode,
    'pinLockEnabled': pinLockEnabled,
    'pinCode': pinCode,
    'autoBackupEnabled': autoBackupEnabled,
    'autoBackupFrequency': autoBackupFrequency,
    'lastBackupDate': lastBackupDate?.toIso8601String(),
    'locale': locale,
  };
  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    theme: json['theme'] as String? ?? 'system',
    showOnboarding: json['showOnboarding'] as bool? ?? true,
    notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    achievementsNotifications:
        json['achievementsNotifications'] as bool? ?? true,
    defaultView: json['defaultView'] as String? ?? 'grid',
    compactMode: json['compactMode'] as bool? ?? false,
    pinLockEnabled: json['pinLockEnabled'] as bool? ?? false,
    pinCode: json['pinCode'] as String?,
    autoBackupEnabled: json['autoBackupEnabled'] as bool? ?? false,
    autoBackupFrequency: json['autoBackupFrequency'] as int? ?? 7,
    lastBackupDate: json['lastBackupDate'] != null
        ? DateTime.parse(json['lastBackupDate'] as String)
        : null,
    locale: json['locale'] as String? ?? 'en',
  );

  bool get hasCompletedOnboarding => !showOnboarding;
}

// ============================================
// DAILY GOALS MODEL
// ============================================

class DailyGoal {
  final String id;
  final DateTime date;
  final int itemsToComplete;
  final int itemsCompleted;
  final int minutesToStudy;
  final int minutesStudied;
  final bool completed;

  DailyGoal({
    String? id,
    DateTime? date,
    this.itemsToComplete = 3,
    this.itemsCompleted = 0,
    this.minutesToStudy = 30,
    this.minutesStudied = 0,
    this.completed = false,
  }) : id = id ?? DateTime.now().toIso8601String().split('T')[0],
       date = date ?? DateTime.now();

  DailyGoal copyWith({
    String? id,
    DateTime? date,
    int? itemsToComplete,
    int? itemsCompleted,
    int? minutesToStudy,
    int? minutesStudied,
    bool? completed,
  }) {
    return DailyGoal(
      id: id ?? this.id,
      date: date ?? this.date,
      itemsToComplete: itemsToComplete ?? this.itemsToComplete,
      itemsCompleted: itemsCompleted ?? this.itemsCompleted,
      minutesToStudy: minutesToStudy ?? this.minutesToStudy,
      minutesStudied: minutesStudied ?? this.minutesStudied,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'itemsToComplete': itemsToComplete,
    'itemsCompleted': itemsCompleted,
    'minutesToStudy': minutesToStudy,
    'minutesStudied': minutesStudied,
    'completed': completed,
  };

  factory DailyGoal.fromJson(Map<String, dynamic> json) => DailyGoal(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    itemsToComplete: json['itemsToComplete'] as int? ?? 3,
    itemsCompleted: json['itemsCompleted'] as int? ?? 0,
    minutesToStudy: json['minutesToStudy'] as int? ?? 30,
    minutesStudied: json['minutesStudied'] as int? ?? 0,
    completed: json['completed'] as bool? ?? false,
  );

  double get itemsProgress => itemsToComplete > 0
      ? (itemsCompleted / itemsToComplete).clamp(0.0, 1.0)
      : 0.0;

  double get minutesProgress => minutesToStudy > 0
      ? (minutesStudied / minutesToStudy).clamp(0.0, 1.0)
      : 0.0;
}

// ============================================
// REMINDER MODEL
// ============================================

class Reminder {
  final String id;
  final String title;
  final String? message;
  final DateTime scheduledTime;
  final String? itemId;
  final bool isCompleted;
  final String repeatType; // 'once', 'daily', 'weekly'
  final List<int>? daysOfWeek; // 1-7 for weekly

  Reminder({
    String? id,
    required this.title,
    this.message,
    required this.scheduledTime,
    this.itemId,
    this.isCompleted = false,
    this.repeatType = 'once',
    this.daysOfWeek,
  }) : id = id ?? const Uuid().v4();

  Reminder copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? scheduledTime,
    String? itemId,
    bool? isCompleted,
    String? repeatType,
    List<int>? daysOfWeek,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      itemId: itemId ?? this.itemId,
      isCompleted: isCompleted ?? this.isCompleted,
      repeatType: repeatType ?? this.repeatType,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'scheduledTime': scheduledTime.toIso8601String(),
    'itemId': itemId,
    'isCompleted': isCompleted,
    'repeatType': repeatType,
    'daysOfWeek': daysOfWeek,
  };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
    id: json['id'] as String,
    title: json['title'] as String,
    message: json['message'] as String?,
    scheduledTime: DateTime.parse(json['scheduledTime'] as String),
    itemId: json['itemId'] as String?,
    isCompleted: json['isCompleted'] as bool? ?? false,
    repeatType: json['repeatType'] as String? ?? 'once',
    daysOfWeek: json['daysOfWeek'] != null
        ? (json['daysOfWeek'] as List).cast<int>()
        : null,
  );

  bool get isDue => !isCompleted && scheduledTime.isBefore(DateTime.now());
  bool get isToday {
    final now = DateTime.now();
    return scheduledTime.year == now.year &&
        scheduledTime.month == now.month &&
        scheduledTime.day == now.day;
  }
}

// ============================================
// LEARNING SESSION MODEL
// ============================================

class LearningSession {
  final String id;
  final String? itemId;
  final String type; // 'pomodoro', 'reading', 'practice', 'review'
  final int durationMinutes;
  final DateTime startTime;
  final DateTime? endTime;
  final bool completed;
  final String? notes;

  LearningSession({
    String? id,
    this.itemId,
    required this.type,
    required this.durationMinutes,
    required this.startTime,
    this.endTime,
    this.completed = false,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  LearningSession copyWith({
    String? id,
    String? itemId,
    String? type,
    int? durationMinutes,
    DateTime? startTime,
    DateTime? endTime,
    bool? completed,
    String? notes,
  }) {
    return LearningSession(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemId': itemId,
    'type': type,
    'durationMinutes': durationMinutes,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'completed': completed,
    'notes': notes,
  };

  factory LearningSession.fromJson(Map<String, dynamic> json) =>
      LearningSession(
        id: json['id'],
        itemId: json['itemId'],
        type: json['type'],
        durationMinutes: json['durationMinutes'],
        startTime: DateTime.parse(json['startTime']),
        endTime: json['endTime'] != null
            ? DateTime.parse(json['endTime'])
            : null,
        completed: json['completed'] ?? false,
        notes: json['notes'],
      );

  DateTime get date => DateTime(startTime.year, startTime.month, startTime.day);
}

// ============================================
// STREAK ANALYTICS MODEL
// ============================================

class StreakAnalytics {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final List<DailyActivity> weeklyActivity;
  final Map<String, int> monthlyCompletions;

  StreakAnalytics({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActivityDate,
    List<DailyActivity>? weeklyActivity,
    Map<String, int>? monthlyCompletions,
  }) : weeklyActivity = weeklyActivity ?? [],
       monthlyCompletions = monthlyCompletions ?? {};

  StreakAnalytics copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    List<DailyActivity>? weeklyActivity,
    Map<String, int>? monthlyCompletions,
  }) {
    return StreakAnalytics(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      monthlyCompletions: monthlyCompletions ?? this.monthlyCompletions,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'lastActivityDate': lastActivityDate?.toIso8601String(),
    'weeklyActivity': weeklyActivity.map((a) => a.toJson()).toList(),
    'monthlyCompletions': monthlyCompletions,
  };

  factory StreakAnalytics.fromJson(Map<String, dynamic> json) =>
      StreakAnalytics(
        currentStreak: json['currentStreak'] ?? 0,
        longestStreak: json['longestStreak'] ?? 0,
        lastActivityDate: json['lastActivityDate'] != null
            ? DateTime.parse(json['lastActivityDate'])
            : null,
        weeklyActivity:
            (json['weeklyActivity'] as List<dynamic>?)
                ?.map((a) => DailyActivity.fromJson(a))
                .toList() ??
            [],
        monthlyCompletions: json['monthlyCompletions'] != null
            ? Map<String, int>.from(json['monthlyCompletions'])
            : {},
      );
}

class DailyActivity {
  final DateTime date;
  final int itemsCompleted;
  final int minutesStudied;
  final int xpEarned;

  DailyActivity({
    DateTime? date,
    this.itemsCompleted = 0,
    this.minutesStudied = 0,
    this.xpEarned = 0,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'itemsCompleted': itemsCompleted,
    'minutesStudied': minutesStudied,
    'xpEarned': xpEarned,
  };

  factory DailyActivity.fromJson(Map<String, dynamic> json) => DailyActivity(
    date: DateTime.parse(json['date']),
    itemsCompleted: json['itemsCompleted'] ?? 0,
    minutesStudied: json['minutesStudied'] ?? 0,
    xpEarned: json['xpEarned'] ?? 0,
  );
}

// ============================================
// POMODORO SESSION MODEL
// ============================================

class PomodoroSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationMinutes;
  final String? relatedItemId;
  final bool completed;

  PomodoroSession({
    String? id,
    DateTime? startTime,
    this.endTime,
    this.durationMinutes = 25,
    this.relatedItemId,
    this.completed = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       startTime = startTime ?? DateTime.now();

  PomodoroSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    String? relatedItemId,
    bool? completed,
  }) {
    return PomodoroSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      relatedItemId: relatedItemId ?? this.relatedItemId,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'durationMinutes': durationMinutes,
    'relatedItemId': relatedItemId,
    'completed': completed,
  };

  factory PomodoroSession.fromJson(Map<String, dynamic> json) =>
      PomodoroSession(
        id: json['id'],
        startTime: DateTime.parse(json['startTime']),
        endTime: json['endTime'] != null
            ? DateTime.parse(json['endTime'])
            : null,
        durationMinutes: json['durationMinutes'] ?? 25,
        relatedItemId: json['relatedItemId'],
        completed: json['completed'] ?? false,
      );
}

// ============================================
// USER PROFILE MODEL
// ============================================

// ============================================
// USER PROFILE MODEL
// ============================================

class UserProfile {
  final String id;
  final String nombre;
  final String? avatarUrl;
  final int nivel;
  final int xp;
  final int streak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final DateTime createdAt;

  UserProfile({
    String? id,
    required this.nombre,
    this.avatarUrl,
    this.nivel = 1,
    this.xp = 0,
    this.streak = 0,
    this.longestStreak = 0,
    this.lastActivityDate,
    DateTime? createdAt,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now();

  UserProfile copyWith({
    String? id,
    String? nombre,
    String? avatarUrl,
    int? nivel,
    int? xp,
    int? streak,
    int? longestStreak,
    DateTime? lastActivityDate,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      nivel: nivel ?? this.nivel,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'avatarUrl': avatarUrl,
    'nivel': nivel,
    'xp': xp,
    'streak': streak,
    'longestStreak': longestStreak,
    'lastActivityDate': lastActivityDate?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'],
    nombre: json['nombre'] ?? 'Usuario',
    avatarUrl: json['avatarUrl'],
    nivel: json['nivel'] ?? 1,
    xp: json['xp'] ?? 0,
    streak: json['streak'] ?? 0,
    longestStreak: json['longestStreak'] ?? 0,
    lastActivityDate: json['lastActivityDate'] != null
        ? DateTime.parse(json['lastActivityDate'])
        : null,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
  );

  static UserProfile defaultProfile() => UserProfile(
    nombre: 'Usuario',
    nivel: 1,
    xp: 0,
    streak: 0,
    longestStreak: 0,
  );

  int get level => nivel;

  int get xpToNextLevel => (nivel * 100) - (xp % (nivel * 100));

  double get levelProgress => (xp % (nivel * 100)) / (nivel * 100);
}

// ============================================
// ACHIEVEMENT MODEL
// ============================================

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool unlocked;
  final DateTime? unlockedAt;
  final int xpReward;
  final String type; // milestone, streak, special

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.unlocked = false,
    this.unlockedAt,
    this.xpReward = 0,
    required this.type,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    bool? unlocked,
    DateTime? unlockedAt,
    int? xpReward,
    String? type,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      xpReward: xpReward ?? this.xpReward,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'icon': icon,
    'unlocked': unlocked,
    'unlockedAt': unlockedAt?.toIso8601String(),
    'xpReward': xpReward,
    'type': type,
  };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    id: json['id'],
    title: json['title'] ?? json['titulo'],
    description: json['description'] ?? json['descripcion'],
    icon: json['icon'] ?? json['icono'],
    unlocked: json['unlocked'] ?? json['desbloqueado'] ?? false,
    unlockedAt: (json['unlockedAt'] ?? json['desbloqueadoEn']) != null
        ? DateTime.parse(json['unlockedAt'] ?? json['desbloqueadoEn'])
        : null,
    xpReward: json['xpReward'] ?? json['xpRecompensa'] ?? 0,
    type: json['type'] ?? json['tipo'] ?? 'milestone',
  );

  static List<Achievement> getDefaultAchievements() => [
    Achievement(
      id: 'primer_paso',
      title: 'First Step',
      description: 'Complete your first item',
      icon: 'emoji_events',
      xpReward: 50,
      type: 'milestone',
    ),
    Achievement(
      id: 'avido',
      title: 'Avid Learner',
      description: 'Complete 5 items',
      icon: 'menu_book',
      xpReward: 100,
      type: 'milestone',
    ),
    Achievement(
      id: 'estudiante',
      title: 'Student',
      description: 'Complete 10 items',
      icon: 'school',
      xpReward: 150,
      type: 'milestone',
    ),
    Achievement(
      id: 'bibliotecario',
      title: 'Librarian',
      description: 'Complete 25 items',
      icon: 'local_library',
      xpReward: 250,
      type: 'milestone',
    ),
    Achievement(
      id: 'maestro',
      title: 'Master',
      description: 'Complete 50 items',
      icon: 'military_tech',
      xpReward: 500,
      type: 'milestone',
    ),
    Achievement(
      id: 'velocista',
      title: 'Sprinter',
      description: 'Complete an item in less than 24 hours',
      icon: 'bolt',
      xpReward: 75,
      type: 'special',
    ),
    Achievement(
      id: 'racha_7',
      title: '7-Day Streak',
      description: '7 days of consecutive activity',
      icon: 'local_fire_department',
      xpReward: 100,
      type: 'streak',
    ),
    Achievement(
      id: 'racha_30',
      title: '30-Day Streak',
      description: '30 days of consecutive activity',
      icon: 'whatshot',
      xpReward: 300,
      type: 'streak',
    ),
    Achievement(
      id: 'coleccionista',
      title: 'Collector',
      description: '10 items in favorites',
      icon: 'star',
      xpReward: 100,
      type: 'special',
    ),
    Achievement(
      id: 'prioritas',
      title: 'Prioritizer',
      description: 'Complete 5 high-priority items',
      icon: 'priority_high',
      xpReward: 100,
      type: 'special',
    ),
    Achievement(
      id: 'analista',
      title: 'Analyst',
      description: 'View stats 20 times',
      icon: 'analytics',
      xpReward: 50,
      type: 'special',
    ),
    Achievement(
      id: 'noctambulo',
      title: 'Night Owl',
      description: 'Study after midnight',
      icon: 'dark_mode',
      xpReward: 25,
      type: 'special',
    ),
  ];
}

// ============================================
// COMMUNITY POST MODEL
// ============================================

class CommunityPost {
  final String id;
  final String
  type; // item_completed, achievement_unlocked, item_added, streak_milestone, level_up
  final String content;
  final DateTime timestamp;
  final bool anonymous;
  final String? userId;
  final String? userName;
  final String? userAvatar;
  final int likes;
  final List<Comment> comments;
  final String? relatedItemId;
  final String? relatedAchievementId;
  final bool isUserPost; // true if this is the current user's post

  CommunityPost({
    String? id,
    required this.type,
    required this.content,
    DateTime? timestamp,
    this.anonymous = true,
    this.userId,
    this.userName,
    this.userAvatar,
    this.likes = 0,
    List<Comment>? comments,
    this.relatedItemId,
    this.relatedAchievementId,
    this.isUserPost = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       timestamp = timestamp ?? DateTime.now(),
       comments = comments ?? [];

  CommunityPost copyWith({
    String? id,
    String? type,
    String? content,
    DateTime? timestamp,
    bool? anonymous,
    String? userId,
    String? userName,
    String? userAvatar,
    int? likes,
    List<Comment>? comments,
    String? relatedItemId,
    String? relatedAchievementId,
    bool? isUserPost,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      anonymous: anonymous ?? this.anonymous,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      relatedItemId: relatedItemId ?? this.relatedItemId,
      relatedAchievementId: relatedAchievementId ?? this.relatedAchievementId,
      isUserPost: isUserPost ?? this.isUserPost,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'anonymous': anonymous,
    'userId': userId,
    'userName': userName,
    'userAvatar': userAvatar,
    'likes': likes,
    'comments': comments.map((c) => c.toJson()).toList(),
    'relatedItemId': relatedItemId,
    'relatedAchievementId': relatedAchievementId,
    'isUserPost': isUserPost,
  };

  factory CommunityPost.fromJson(Map<String, dynamic> json) => CommunityPost(
    id: json['id'],
    type: json['type'] ?? json['tipo'],
    content: json['content'] ?? json['contenido'],
    timestamp: DateTime.parse(json['timestamp']),
    anonymous: json['anonymous'] ?? json['anonimo'] ?? true,
    userId: json['userId'] ?? json['usuarioId'],
    userName: json['userName'] ?? json['usuarioNombre'],
    userAvatar: json['userAvatar'] ?? json['usuarioAvatar'],
    likes: json['likes'] ?? 0,
    comments:
        (json['comments'] ?? json['comentarios'] as List<dynamic>?)
            ?.map((c) => Comment.fromJson(c))
            .toList() ??
        [],
    relatedItemId: json['relatedItemId'],
    relatedAchievementId: json['relatedAchievementId'],
    isUserPost: json['isUserPost'] ?? false,
  );
}

class Comment {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;

  Comment({
    String? id,
    required this.userId,
    required this.userName,
    required this.content,
    DateTime? timestamp,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'],
    userId: json['userId'],
    userName: json['userName'],
    content: json['content'],
    timestamp: json['timestamp'] != null
        ? DateTime.parse(json['timestamp'])
        : DateTime.now(),
  );
}

// ============================================
// POLL MODEL (Community Polls)
// ============================================

class Poll {
  final String id;
  final String question;
  final List<PollOption> options;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;
  final int totalVotes;
  final String? creatorId;

  Poll({
    String? id,
    required this.question,
    required this.options,
    DateTime? createdAt,
    this.expiresAt,
    this.isActive = true,
    this.totalVotes = 0,
    this.creatorId,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now();

  Poll copyWith({
    String? id,
    String? question,
    List<PollOption>? options,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isActive,
    int? totalVotes,
    String? creatorId,
  }) {
    return Poll(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      totalVotes: totalVotes ?? this.totalVotes,
      creatorId: creatorId ?? this.creatorId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'options': options.map((o) => o.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
    'isActive': isActive,
    'totalVotes': totalVotes,
    'creatorId': creatorId,
  };

  factory Poll.fromJson(Map<String, dynamic> json) => Poll(
    id: json['id'],
    question: json['question'],
    options: (json['options'] as List<dynamic>)
        .map((o) => PollOption.fromJson(o))
        .toList(),
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
    expiresAt: json['expiresAt'] != null
        ? DateTime.parse(json['expiresAt'])
        : null,
    isActive: json['isActive'] ?? true,
    totalVotes: json['totalVotes'] ?? 0,
    creatorId: json['creatorId'],
  );

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

class PollOption {
  final String id;
  final String text;
  final int votes;

  PollOption({String? id, required this.text, this.votes = 0})
    : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  PollOption copyWith({String? id, String? text, int? votes}) {
    return PollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      votes: votes ?? this.votes,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'text': text, 'votes': votes};

  factory PollOption.fromJson(Map<String, dynamic> json) =>
      PollOption(id: json['id'], text: json['text'], votes: json['votes'] ?? 0);

  double getPercentage(int totalVotes) {
    if (totalVotes == 0) return 0;
    return votes / totalVotes;
  }
}

// ============================================
// NOTE MODEL - Enhanced Notes System with Multimedia Support
// ============================================

class Note {
  final String id;
  final String title;
  final String content;
  final String? itemId;
  final List<String> tags;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final NoteType type;
  final List<NoteAttachment> attachments;
  final String? voiceNotePath;

  Note({
    String? id,
    required this.title,
    required this.content,
    this.itemId,
    List<String>? tags,
    this.isPinned = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.type = NoteType.text,
    List<NoteAttachment>? attachments,
    this.voiceNotePath,
  }) : id = id ?? const Uuid().v4(),
       tags = tags ?? [],
       attachments = attachments ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? itemId,
    List<String>? tags,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    NoteType? type,
    List<NoteAttachment>? attachments,
    String? voiceNotePath,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      itemId: itemId ?? this.itemId,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      type: type ?? this.type,
      attachments: attachments ?? this.attachments,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'itemId': itemId,
    'tags': tags,
    'isPinned': isPinned,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'type': type.name,
    'attachments': attachments.map((a) => a.toJson()).toList(),
    'voiceNotePath': voiceNotePath,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    itemId: json['itemId'],
    tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    isPinned: json['isPinned'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    type: NoteType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => NoteType.text,
    ),
    attachments: json['attachments'] != null
        ? (json['attachments'] as List<dynamic>)
              .map((a) => NoteAttachment.fromJson(a))
              .toList()
        : [],
    voiceNotePath: json['voiceNotePath'],
  );

  bool get hasAttachments => attachments.isNotEmpty;
  bool get hasVoiceNote => voiceNotePath != null && voiceNotePath!.isNotEmpty;
}

enum NoteType { text, image, voice, mixed }

class NoteAttachment {
  final String id;
  final String path;
  final AttachmentType type;
  final DateTime createdAt;

  NoteAttachment({
    String? id,
    required this.path,
    required this.type,
    DateTime? createdAt,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': path,
    'type': type.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory NoteAttachment.fromJson(Map<String, dynamic> json) => NoteAttachment(
    id: json['id'],
    path: json['path'],
    type: AttachmentType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => AttachmentType.image,
    ),
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
  );
}

enum AttachmentType { image, file, link }

// ============================================
// RECOMMENDED RESOURCE MODEL
// ============================================

class RecommendedResource {
  final String id;
  final String title;
  final String description;
  final String url;
  final String type;
  final String category;
  final String difficulty;
  final bool isFree;
  final double rating;

  RecommendedResource({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.type,
    required this.category,
    this.difficulty = 'intermediate',
    this.isFree = true,
    this.rating = 4.5,
  });

  static List<RecommendedResource> getDefaults() => [
    RecommendedResource(
      id: 'rec_1',
      title: 'Flutter Complete Guide',
      description: 'The complete guide to Flutter development',
      url: 'https://www.udemy.com/course/flutter-complete-guide/',
      type: 'course',
      category: 'Mobile Development',
      difficulty: 'beginner',
      isFree: false,
      rating: 4.8,
    ),
    RecommendedResource(
      id: 'rec_2',
      title: 'Dart Docs',
      description: 'Official Dart programming language documentation',
      url: 'https://dart.dev/guides',
      type: 'documentation',
      category: 'Programming',
      difficulty: 'beginner',
      isFree: true,
      rating: 4.9,
    ),
    RecommendedResource(
      id: 'rec_3',
      title: 'Riverpod Course',
      description: 'State management with Riverpod',
      url: 'https://riverpod.dev/',
      type: 'documentation',
      category: 'State Management',
      difficulty: 'intermediate',
      isFree: true,
      rating: 4.7,
    ),
    RecommendedResource(
      id: 'rec_4',
      title: 'Clean Code',
      description: 'Robert C. Martin - Classic software engineering book',
      url:
          'https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350884',
      type: 'book',
      category: 'Best Practices',
      difficulty: 'intermediate',
      isFree: false,
      rating: 4.9,
    ),
    RecommendedResource(
      id: 'rec_5',
      title: 'The Pragmatic Programmer',
      description: 'Classic book on software development',
      url:
          'https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/',
      type: 'book',
      category: 'Best Practices',
      difficulty: 'advanced',
      isFree: false,
      rating: 4.8,
    ),
  ];
}

// ============================================
// FAQ MODEL
// ============================================

class FAQ {
  final String pregunta;
  final String respuesta;
  final String categoria;

  FAQ({
    required this.pregunta,
    required this.respuesta,
    required this.categoria,
  });

  static List<FAQ> getDefaultFAQs() => [
    FAQ(
      pregunta: 'How do I create a new item?',
      respuesta:
          'Tap the + button in the bottom right corner. Select the content type (course, book, podcast, etc.) and fill in the required fields.',
      categoria: 'Getting Started',
    ),
    FAQ(
      pregunta: 'How does the achievement system work?',
      respuesta:
          'Achievements unlock automatically when you complete specific actions. Each achievement gives you bonus XP. Collect them all!',
      categoria: 'Achievements',
    ),
    FAQ(
      pregunta: 'How do I change the app theme?',
      respuesta:
          'Go to Settings > Appearance and select System, Light, or Dark.',
      categoria: 'Settings',
    ),
    FAQ(
      pregunta: 'How do I export my data?',
      respuesta:
          'In Settings > Data, select Export data. A JSON file with all your items will be downloaded.',
      categoria: 'Data',
    ),
    FAQ(
      pregunta: 'What is the streak?',
      respuesta:
          'The streak counts consecutive days you have studied. Keep your streak to earn special achievements and XP bonuses.',
      categoria: 'Achievements',
    ),
    FAQ(
      pregunta: 'Can I import data from another device?',
      respuesta:
          'Yes, go to Settings > Data > Import data and select a previously exported JSON file.',
      categoria: 'Data',
    ),
    FAQ(
      pregunta: 'How does progress work?',
      respuesta:
          'Each item has a progress bar. Drag the slider to manually update your progress.',
      categoria: 'Library',
    ),
    FAQ(
      pregunta: 'What are filters?',
      respuesta:
          'Filters allow you to search items by type, status, priority and more. Use them in the Library to find exactly what you are looking for.',
      categoria: 'Library',
    ),
  ];
}

// ============================================
// CUSTOM DOMAIN MODEL
// ============================================

enum DomainVerificationStatus { pending, verifying, verified, failed }

class CustomDomain {
  final String id;
  final String domain;
  final DomainVerificationStatus status;
  final String? description;
  final String? verificationCode;
  final DateTime createdAt;
  final DateTime? verifiedAt;
  final String? errorMessage;

  CustomDomain({
    String? id,
    required this.domain,
    this.status = DomainVerificationStatus.pending,
    this.description,
    this.verificationCode,
    DateTime? createdAt,
    this.verifiedAt,
    this.errorMessage,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now();

  CustomDomain copyWith({
    String? id,
    String? domain,
    DomainVerificationStatus? status,
    String? description,
    String? verificationCode,
    DateTime? createdAt,
    DateTime? verifiedAt,
    String? errorMessage,
  }) {
    return CustomDomain(
      id: id ?? this.id,
      domain: domain ?? this.domain,
      status: status ?? this.status,
      description: description ?? this.description,
      verificationCode: verificationCode ?? this.verificationCode,
      createdAt: createdAt ?? this.createdAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'domain': domain,
    'status': status.name,
    'description': description,
    'verificationCode': verificationCode,
    'createdAt': createdAt.toIso8601String(),
    'verifiedAt': verifiedAt?.toIso8601String(),
    'errorMessage': errorMessage,
  };

  factory CustomDomain.fromJson(Map<String, dynamic> json) => CustomDomain(
    id: json['id'],
    domain: json['domain'],
    status: DomainVerificationStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => DomainVerificationStatus.pending,
    ),
    description: json['description'],
    verificationCode: json['verificationCode'],
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
    verifiedAt: json['verifiedAt'] != null
        ? DateTime.parse(json['verifiedAt'])
        : null,
    errorMessage: json['errorMessage'],
  );

  bool get isVerified => status == DomainVerificationStatus.verified;
  bool get isPending => status == DomainVerificationStatus.pending;
  bool get isVerifying => status == DomainVerificationStatus.verifying;
  bool get hasFailed => status == DomainVerificationStatus.failed;
}
