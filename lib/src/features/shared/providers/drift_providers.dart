import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:uuid/uuid.dart';
import '../../../services/database/database.dart';
import '../../../services/database/database_provider.dart';

final settingsProvider = FutureProvider<AppSettingsTableData?>((ref) async {
  final db = ref.watch(databaseProvider);
  var settings = await db.getSettings();
  if (settings == null) {
    await db.saveSettings(
      AppSettingsTableCompanion(
        id: const Value('settings'),
        theme: const Value('system'),
        locale: const Value('en'),
        hasCompletedOnboarding: const Value(false),
        notificationsEnabled: const Value(true),
        dailyGoalMinutes: const Value(60),
        focusDuration: const Value(25),
        breakDuration: const Value(5),
        longBreakDuration: const Value(15),
        pomodorosUntilLongBreak: const Value(4),
        reducedMotion: const Value(false),
      ),
    );
    settings = await db.getSettings();
  }
  return settings;
});

final itemsProvider = StreamProvider<List<LearningItem>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllItems();
});

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllCategories();
});

final tagsProvider = StreamProvider<List<Tag>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllTags();
});

final notesProvider = StreamProvider<List<Note>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllNotes();
});

final remindersProvider = StreamProvider<List<Reminder>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllReminders();
});

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final db = ref.watch(databaseProvider);
  var profile = await db.getUserProfile();
  if (profile == null) {
    await db.saveUserProfile(
      UserProfilesCompanion.insert(
        id: 'default',
        username: 'User',
        level: const Value(1),
        xp: const Value(0),
        totalXp: const Value(0),
        streakDays: const Value(0),
        longestStreak: const Value(0),
        lastActiveAt: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    );
    profile = await db.getUserProfile();
  }
  return profile;
});

final achievementsProvider = StreamProvider<List<Achievement>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllAchievements();
});

final sessionsProvider = StreamProvider<List<LearningSession>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllSessions();
});

final pomodoroSessionsProvider = StreamProvider<List<PomodoroSession>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllPomodoroSessions();
});

final postsProvider = StreamProvider<List<CommunityPost>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllPosts();
});

final domainsProvider = StreamProvider<List<CustomDomain>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllDomains();
});

final activitiesProvider = StreamProvider<List<DailyActivity>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllActivities();
});

final learningItemsProvider = StreamProvider<List<LearningItem>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllItems();
});

final communityFeedProvider = StreamProvider<List<CommunityPost>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllPosts();
});

final analyticsProvider = StreamProvider<List<DailyActivity>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllActivities();
});

final pollsProvider = StreamProvider<List<CommunityPost>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllPosts();
});

final customDomainsProvider = StreamProvider<List<CustomDomain>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllDomains();
});

final verifiedDomainsProvider = StreamProvider<List<CustomDomain>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllDomains().map(
    (domains) => domains.where((d) => d.isVerified).toList(),
  );
});

final recentInProgressItemsProvider = Provider<List<LearningItem>>((ref) {
  final itemsAsync = ref.watch(itemsProvider);
  return itemsAsync.maybeWhen(
    data: (items) =>
        items.where((item) => item.status == 'in_progress').take(5).toList(),
    orElse: () => [],
  );
});

final filteredItemsProvider = Provider<List<LearningItem>>((ref) {
  final itemsAsync = ref.watch(itemsProvider);
  return itemsAsync.maybeWhen(data: (items) => items, orElse: () => []);
});

enum PomodoroState { idle, running, paused, breakTime }

final pomodoroStateProvider =
    NotifierProvider<PomodoroStateNotifier, PomodoroState>(
      PomodoroStateNotifier.new,
    );

class PomodoroStateNotifier extends Notifier<PomodoroState> {
  @override
  PomodoroState build() => PomodoroState.idle;

  void setRunning() => state = PomodoroState.running;
  void setPaused() => state = PomodoroState.paused;
  void setIdle() => state = PomodoroState.idle;
  void setBreakTime() => state = PomodoroState.breakTime;
}

final pomodoroTimeProvider = StateProvider<int>((ref) => 25 * 60);

final pendingDomainsProvider = StreamProvider<List<CustomDomain>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllDomains().map(
    (domains) => domains.where((d) => !d.isVerified).toList(),
  );
});

final verifiedDomainsNotifierProvider =
    NotifierProvider<VerifiedDomainsNotifier, List<CustomDomain>>(
      VerifiedDomainsNotifier.new,
    );

class VerifiedDomainsNotifier extends Notifier<List<CustomDomain>> {
  @override
  List<CustomDomain> build() => [];

  void addDomain(CustomDomain domain) {
    state = [...state, domain];
  }

  void removeDomain(String id) {
    state = state.where((d) => d.id != id).toList();
  }

  void updateDomain(CustomDomain domain) {
    state = state.map((d) => d.id == domain.id ? domain : d).toList();
  }
}

final customDomainsNotifierProvider =
    NotifierProvider<CustomDomainsNotifier, List<CustomDomain>>(
      CustomDomainsNotifier.new,
    );

class CustomDomainsNotifier extends Notifier<List<CustomDomain>> {
  @override
  List<CustomDomain> build() => [];

  void addDomain(CustomDomain domain) {
    state = [...state, domain];
  }

  void removeDomain(String id) {
    state = state.where((d) => d.id != id).toList();
  }

  void updateDomain(CustomDomain domain) {
    state = state.map((d) => d.id == domain.id ? domain : d).toList();
  }
}

final userProfileNotifierProvider =
    NotifierProvider<UserProfileNotifier, UserProfile?>(
      UserProfileNotifier.new,
    );

class UserProfileNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() => null;

  Future<void> addXp(int amount) async {
    if (state == null) return;
    final db = ref.read(databaseProvider);
    await db.saveUserProfile(
      UserProfilesCompanion(
        id: Value(state!.id),
        username: Value(state!.username),
        level: Value(state!.level),
        xp: Value(state!.xp + amount),
        totalXp: Value(state!.totalXp + amount),
        streakDays: Value(state!.streakDays),
        longestStreak: Value(state!.longestStreak),
        lastActiveAt: Value(DateTime.now()),
        createdAt: Value(state!.createdAt),
      ),
    );
  }

  Future<void> updateProfile(UserProfilesCompanion profile) async {
    final db = ref.read(databaseProvider);
    await db.saveUserProfile(profile);
  }
}

final notesNotifierProvider = NotifierProvider<NotesNotifier, List<Note>>(
  NotesNotifier.new,
);

class NotesNotifier extends Notifier<List<Note>> {
  @override
  List<Note> build() => [];

  void addNote(Note note) {
    state = [...state, note];
  }

  void removeNote(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void updateNote(Note note) {
    state = state.map((n) => n.id == note.id ? note : n).toList();
  }
}

final remindersNotifierProvider =
    NotifierProvider<RemindersNotifier, List<Reminder>>(RemindersNotifier.new);

class RemindersNotifier extends Notifier<List<Reminder>> {
  @override
  List<Reminder> build() => [];

  void addReminder(Reminder reminder) {
    state = [...state, reminder];
  }

  void removeReminder(String id) {
    state = state.where((r) => r.id != id).toList();
  }

  void updateReminder(Reminder reminder) {
    state = state.map((r) => r.id == reminder.id ? reminder : r).toList();
  }

  void toggleComplete(String id) {
    state = state.map((r) {
      if (r.id == id) {
        return r.copyWith(isCompleted: !r.isCompleted);
      }
      return r;
    }).toList();
  }
}

final pomodoroSessionsNotifierProvider =
    NotifierProvider<PomodoroSessionsNotifier, List<PomodoroSession>>(
      PomodoroSessionsNotifier.new,
    );

class PomodoroSessionsNotifier extends Notifier<List<PomodoroSession>> {
  @override
  List<PomodoroSession> build() => [];

  Future<void> startSession({required int durationMinutes}) async {
    final db = ref.read(databaseProvider);
    await db.insertPomodoroSession(
      PomodoroSessionsCompanion.insert(
        id: const Uuid().v4(),
        durationMinutes: durationMinutes,
        type: 'focus',
        startedAt: DateTime.now(),
      ),
    );
  }

  Future<void> completeSession(String id) async {
    final db = ref.read(databaseProvider);
    await db.updatePomodoroSession(
      PomodoroSessionsCompanion(
        id: Value(id),
        completed: const Value(true),
        endedAt: Value(DateTime.now()),
      ),
    );
  }
}

final learningItemsNotifierProvider =
    NotifierProvider<LearningItemsNotifier, List<LearningItem>>(
      LearningItemsNotifier.new,
    );

class LearningItemsNotifier extends Notifier<List<LearningItem>> {
  @override
  List<LearningItem> build() => [];

  void addItem(LearningItem item) {
    state = [...state, item];
  }

  void removeItem(String id) {
    state = state.where((i) => i.id != id).toList();
  }

  void updateItem(LearningItem item) {
    state = state.map((i) => i.id == item.id ? item : i).toList();
  }

  void updateProgress(String itemId, int progress) {
    state = state.map((item) {
      if (item.id == itemId) {
        return item.copyWith(progress: progress);
      }
      return item;
    }).toList();
  }
}

final categoriesNotifierProvider =
    NotifierProvider<CategoriesNotifier, List<Category>>(
      CategoriesNotifier.new,
    );

class CategoriesNotifier extends Notifier<List<Category>> {
  @override
  List<Category> build() => [];

  void addCategory(Category category) {
    state = [...state, category];
  }

  void removeCategory(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}

final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, AppSettingsTableData?>(
      SettingsNotifier.new,
    );

class SettingsNotifier extends Notifier<AppSettingsTableData?> {
  @override
  AppSettingsTableData? build() => null;

  Future<void> updateSettings(AppSettingsTableCompanion settings) async {
    final db = ref.read(databaseProvider);
    await db.saveSettings(settings);
  }

  Future<void> completeOnboarding() async {
    final db = ref.read(databaseProvider);
    await db.saveSettings(
      AppSettingsTableCompanion(
        id: const Value('settings'),
        hasCompletedOnboarding: const Value(true),
      ),
    );
  }
}
