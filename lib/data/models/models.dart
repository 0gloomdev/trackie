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
    id: json['id'],
    name: json['name'],
    color: json['color'] ?? 0xFF6366F1,
    category: json['category'],
    usageCount: json['usageCount'] ?? 0,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
  );
}

class AppSettings {
  final String theme;
  final bool showOnboarding;
  final bool notificationsEnabled;
  final String defaultView;
  final bool compactMode;
  final bool pinLockEnabled;
  final String? pinCode;
  final bool autoBackupEnabled;
  final int autoBackupFrequency;
  final DateTime? lastBackupDate;

  AppSettings({
    this.theme = 'system',
    this.showOnboarding = true,
    this.notificationsEnabled = false,
    this.defaultView = 'grid',
    this.compactMode = false,
    this.pinLockEnabled = false,
    this.pinCode,
    this.autoBackupEnabled = false,
    this.autoBackupFrequency = 7,
    this.lastBackupDate,
  });

  AppSettings copyWith({
    String? theme,
    bool? showOnboarding,
    bool? notificationsEnabled,
    String? defaultView,
    bool? compactMode,
    bool? pinLockEnabled,
    String? pinCode,
    bool? autoBackupEnabled,
    int? autoBackupFrequency,
    DateTime? lastBackupDate,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      showOnboarding: showOnboarding ?? this.showOnboarding,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultView: defaultView ?? this.defaultView,
      compactMode: compactMode ?? this.compactMode,
      pinLockEnabled: pinLockEnabled ?? this.pinLockEnabled,
      pinCode: pinCode ?? this.pinCode,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      autoBackupFrequency: autoBackupFrequency ?? this.autoBackupFrequency,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'theme': theme,
    'showOnboarding': showOnboarding,
    'notificationsEnabled': notificationsEnabled,
    'defaultView': defaultView,
    'compactMode': compactMode,
    'pinLockEnabled': pinLockEnabled,
    'pinCode': pinCode,
    'autoBackupEnabled': autoBackupEnabled,
    'autoBackupFrequency': autoBackupFrequency,
    'lastBackupDate': lastBackupDate?.toIso8601String(),
  };
  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    theme: json['theme'] ?? 'system',
    showOnboarding: json['showOnboarding'] ?? true,
    notificationsEnabled: json['notificationsEnabled'] ?? false,
    defaultView: json['defaultView'] ?? 'grid',
    compactMode: json['compactMode'] ?? false,
    pinLockEnabled: json['pinLockEnabled'] ?? false,
    pinCode: json['pinCode'],
    autoBackupEnabled: json['autoBackupEnabled'] ?? false,
    autoBackupFrequency: json['autoBackupFrequency'] ?? 7,
    lastBackupDate: json['lastBackupDate'] != null
        ? DateTime.parse(json['lastBackupDate'])
        : null,
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
    id: json['id'],
    date: DateTime.parse(json['date']),
    itemsToComplete: json['itemsToComplete'] ?? 3,
    itemsCompleted: json['itemsCompleted'] ?? 0,
    minutesToStudy: json['minutesToStudy'] ?? 30,
    minutesStudied: json['minutesStudied'] ?? 0,
    completed: json['completed'] ?? false,
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
    id: json['id'],
    title: json['title'],
    message: json['message'],
    scheduledTime: DateTime.parse(json['scheduledTime']),
    itemId: json['itemId'],
    isCompleted: json['isCompleted'] ?? false,
    repeatType: json['repeatType'] ?? 'once',
    daysOfWeek: json['daysOfWeek'] != null
        ? List<int>.from(json['daysOfWeek'])
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
  final String titulo;
  final String descripcion;
  final String icono;
  final bool desbloqueado;
  final DateTime? desbloqueadoEn;
  final int xpRecompensa;
  final String tipo; // milestone, streak, special

  Achievement({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    this.desbloqueado = false,
    this.desbloqueadoEn,
    this.xpRecompensa = 0,
    required this.tipo,
  });

  Achievement copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    String? icono,
    bool? desbloqueado,
    DateTime? desbloqueadoEn,
    int? xpRecompensa,
    String? tipo,
  }) {
    return Achievement(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      icono: icono ?? this.icono,
      desbloqueado: desbloqueado ?? this.desbloqueado,
      desbloqueadoEn: desbloqueadoEn ?? this.desbloqueadoEn,
      xpRecompensa: xpRecompensa ?? this.xpRecompensa,
      tipo: tipo ?? this.tipo,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'icono': icono,
    'desbloqueado': desbloqueado,
    'desbloqueadoEn': desbloqueadoEn?.toIso8601String(),
    'xpRecompensa': xpRecompensa,
    'tipo': tipo,
  };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    id: json['id'],
    titulo: json['titulo'],
    descripcion: json['descripcion'],
    icono: json['icono'],
    desbloqueado: json['desbloqueado'] ?? false,
    desbloqueadoEn: json['desbloqueadoEn'] != null
        ? DateTime.parse(json['desbloqueadoEn'])
        : null,
    xpRecompensa: json['xpRecompensa'] ?? 0,
    tipo: json['tipo'] ?? 'milestone',
  );

  static List<Achievement> getDefaultAchievements() => [
    Achievement(
      id: 'primer_paso',
      titulo: 'Primer Paso',
      descripcion: 'Completa tu primer item',
      icono: 'emoji_events',
      xpRecompensa: 50,
      tipo: 'milestone',
    ),
    Achievement(
      id: 'avido',
      titulo: 'Ávido',
      descripcion: 'Completa 5 items',
      icono: 'menu_book',
      xpRecompensa: 100,
      tipo: 'milestone',
    ),
    Achievement(
      id: 'estudiante',
      titulo: 'Estudiante',
      descripcion: 'Completa 10 items',
      icono: 'school',
      xpRecompensa: 150,
      tipo: 'milestone',
    ),
    Achievement(
      id: 'bibliotecario',
      titulo: 'Bibliotecario',
      descripcion: 'Completa 25 items',
      icono: 'local_library',
      xpRecompensa: 250,
      tipo: 'milestone',
    ),
    Achievement(
      id: 'maestro',
      titulo: 'Maestro',
      descripcion: 'Completa 50 items',
      icono: 'military_tech',
      xpRecompensa: 500,
      tipo: 'milestone',
    ),
    Achievement(
      id: 'velocista',
      titulo: 'Velocista',
      descripcion: 'Completa un item en menos de 24 horas',
      icono: 'bolt',
      xpRecompensa: 75,
      tipo: 'special',
    ),
    Achievement(
      id: 'racha_7',
      titulo: 'Racha 7',
      descripcion: '7 días consecutivos de actividad',
      icono: 'local_fire_department',
      xpRecompensa: 100,
      tipo: 'streak',
    ),
    Achievement(
      id: 'racha_30',
      titulo: 'Racha 30',
      descripcion: '30 días consecutivos de actividad',
      icono: 'whatshot',
      xpRecompensa: 300,
      tipo: 'streak',
    ),
    Achievement(
      id: 'coleccionista',
      titulo: 'Coleccionista',
      descripcion: '10 items en favoritos',
      icono: 'star',
      xpRecompensa: 100,
      tipo: 'special',
    ),
    Achievement(
      id: 'prioritario',
      titulo: 'Prioritario',
      descripcion: 'Completa 5 items urgentes',
      icono: 'flag',
      xpRecompensa: 100,
      tipo: 'special',
    ),
    Achievement(
      id: 'analista',
      titulo: 'Analista',
      descripcion: 'Ver estadísticas 20 veces',
      icono: 'insights',
      xpRecompensa: 50,
      tipo: 'special',
    ),
    Achievement(
      id: 'noctambulo',
      titulo: 'Noctámbulo',
      descripcion: 'Estudia después de medianoche',
      icono: 'nightlight',
      xpRecompensa: 25,
      tipo: 'special',
    ),
  ];
}

// ============================================
// COMMUNITY POST MODEL
// ============================================

class CommunityPost {
  final String id;
  final String
  tipo; // item_completed, achievement_unlocked, item_added, streak_milestone, level_up
  final String contenido;
  final DateTime timestamp;
  final bool anonimo;
  final String? usuarioId;
  final String? usuarioNombre;
  final String? usuarioAvatar;
  final int likes;
  final List<Comment> comentarios;
  final String? relatedItemId;
  final String? relatedAchievementId;
  final bool isUserPost; // true if this is the current user's post

  CommunityPost({
    String? id,
    required this.tipo,
    required this.contenido,
    DateTime? timestamp,
    this.anonimo = true,
    this.usuarioId,
    this.usuarioNombre,
    this.usuarioAvatar,
    this.likes = 0,
    List<Comment>? comentarios,
    this.relatedItemId,
    this.relatedAchievementId,
    this.isUserPost = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       timestamp = timestamp ?? DateTime.now(),
       comentarios = comentarios ?? [];

  CommunityPost copyWith({
    String? id,
    String? tipo,
    String? contenido,
    DateTime? timestamp,
    bool? anonimo,
    String? usuarioId,
    String? usuarioNombre,
    String? usuarioAvatar,
    int? likes,
    List<Comment>? comentarios,
    String? relatedItemId,
    String? relatedAchievementId,
    bool? isUserPost,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      contenido: contenido ?? this.contenido,
      timestamp: timestamp ?? this.timestamp,
      anonimo: anonimo ?? this.anonimo,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      usuarioAvatar: usuarioAvatar ?? this.usuarioAvatar,
      likes: likes ?? this.likes,
      comentarios: comentarios ?? this.comentarios,
      relatedItemId: relatedItemId ?? this.relatedItemId,
      relatedAchievementId: relatedAchievementId ?? this.relatedAchievementId,
      isUserPost: isUserPost ?? this.isUserPost,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tipo': tipo,
    'contenido': contenido,
    'timestamp': timestamp.toIso8601String(),
    'anonimo': anonimo,
    'usuarioId': usuarioId,
    'usuarioNombre': usuarioNombre,
    'usuarioAvatar': usuarioAvatar,
    'likes': likes,
    'comentarios': comentarios.map((c) => c.toJson()).toList(),
    'relatedItemId': relatedItemId,
    'relatedAchievementId': relatedAchievementId,
    'isUserPost': isUserPost,
  };

  factory CommunityPost.fromJson(Map<String, dynamic> json) => CommunityPost(
    id: json['id'],
    tipo: json['tipo'],
    contenido: json['contenido'],
    timestamp: DateTime.parse(json['timestamp']),
    anonimo: json['anonimo'] ?? true,
    usuarioId: json['usuarioId'],
    usuarioNombre: json['usuarioNombre'],
    usuarioAvatar: json['usuarioAvatar'],
    likes: json['likes'] ?? 0,
    comentarios:
        (json['comentarios'] as List<dynamic>?)
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
  final String usuarioId;
  final String usuarioNombre;
  final String contenido;
  final DateTime timestamp;

  Comment({
    String? id,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.contenido,
    DateTime? timestamp,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuarioId': usuarioId,
    'usuarioNombre': usuarioNombre,
    'contenido': contenido,
    'timestamp': timestamp.toIso8601String(),
  };

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'],
    usuarioId: json['usuarioId'],
    usuarioNombre: json['usuarioNombre'],
    contenido: json['contenido'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

// ============================================
// NOTE MODEL - Enhanced Notes System
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

  Note({
    String? id,
    required this.title,
    required this.content,
    this.itemId,
    List<String>? tags,
    this.isPinned = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       tags = tags ?? [],
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
  );
}

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
      pregunta: '¿Cómo creo un nuevo item?',
      respuesta:
          'Toca el botón + en la esquina inferior derecha. Selecciona el tipo de contenido (curso, libro, podcast, etc.) y completa los campos requeridos.',
      categoria: 'Primeros pasos',
    ),
    FAQ(
      pregunta: '¿Cómo funciona el sistema de logros?',
      respuesta:
          'Los logros se desbloquean automáticamente al completar acciones específicas. Cada logro te da XP adicional. ¡Colecciona todos!',
      categoria: 'Logros',
    ),
    FAQ(
      pregunta: '¿Cómo cambio el tema de la app?',
      respuesta:
          'Ve a Ajustes > Apariencia y selecciona entre Sistema, Claro u Oscuro.',
      categoria: 'Ajustes',
    ),
    FAQ(
      pregunta: '¿Cómo exporto mis datos?',
      respuesta:
          'En Ajustes > Datos, selecciona Exportar datos. Se descargará un archivo JSON con todos tus items.',
      categoria: 'Datos',
    ),
    FAQ(
      pregunta: '¿Qué es la racha?',
      respuesta:
          'La racha cuenta los días consecutivos que has estudiado. Mantén tu racha para ganar logros especiales y bonus de XP.',
      categoria: 'Logros',
    ),
    FAQ(
      pregunta: '¿Puedo importar datos desde otro dispositivo?',
      respuesta:
          'Sí, ve a Ajustes > Datos > Importar datos y selecciona un archivo JSON previamente exportado.',
      categoria: 'Datos',
    ),
    FAQ(
      pregunta: '¿Cómo funciona el progreso?',
      respuesta:
          'Cada item tiene una barra de progreso. Arrastra el deslizador para actualizar tu progreso manualmente.',
      categoria: 'Biblioteca',
    ),
    FAQ(
      pregunta: '¿Qué son los filtros?',
      respuesta:
          'Los filtros te permiten buscar items por tipo, estado, prioridad y más. Úsalos en la Biblioteca para encontrar exactamente lo que buscas.',
      categoria: 'Biblioteca',
    ),
  ];
}
