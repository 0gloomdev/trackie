import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

class LearningItems extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get type => text()();
  TextColumn get description => text().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get urlFavicon => text().nullable()();
  TextColumn get urlThumbnail => text().nullable()();
  TextColumn get localPath => text().nullable()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get priority => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  TextColumn get notes => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastAccessedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get color => text()();
  TextColumn get icon => text().withDefault(const Constant('folder'))();
  TextColumn get parentId => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get color => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get theme => text().withDefault(const Constant('system'))();
  TextColumn get locale => text().withDefault(const Constant('en'))();
  BoolColumn get hasCompletedOnboarding =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get dailyGoalMinutes => integer().withDefault(const Constant(60))();
  IntColumn get focusDuration => integer().withDefault(const Constant(25))();
  IntColumn get breakDuration => integer().withDefault(const Constant(5))();
  IntColumn get longBreakDuration =>
      integer().withDefault(const Constant(15))();
  IntColumn get pomodorosUntilLongBreak =>
      integer().withDefault(const Constant(4))();
  TextColumn get customFont => text().nullable()();
  BoolColumn get reducedMotion =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get message => text().nullable()();
  TextColumn get type => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurrencePattern => text().nullable()();
  TextColumn get itemId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LearningSessions extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text()();
  IntColumn get durationMinutes => integer()();
  IntColumn get progressBefore => integer()();
  IntColumn get progressAfter => integer()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class PomodoroSessions extends Table {
  TextColumn get id => text()();
  IntColumn get durationMinutes => integer()();
  TextColumn get type => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get username => text()();
  TextColumn get avatarUrl => text().nullable()();
  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  IntColumn get streakDays => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActiveAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Achievements extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get icon => text()();
  TextColumn get category => text()();
  IntColumn get xpReward => integer()();
  BoolColumn get unlocked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get itemId => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class CommunityPosts extends Table {
  TextColumn get id => text()();
  TextColumn get authorId => text()();
  TextColumn get authorName => text()();
  TextColumn get authorAvatar => text().nullable()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get likes => integer().withDefault(const Constant(0))();
  IntColumn get comments => integer().withDefault(const Constant(0))();
  BoolColumn get isLiked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class CustomDomains extends Table {
  TextColumn get id => text()();
  TextColumn get domain => text()();
  TextColumn get verificationCode => text()();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  DateTimeColumn get verifiedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class DailyActivities extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get itemsCompleted => integer().withDefault(const Constant(0))();
  IntColumn get totalMinutes => integer().withDefault(const Constant(0))();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  IntColumn get pomodorosCompleted =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    LearningItems,
    Categories,
    Tags,
    AppSettingsTable,
    Reminders,
    LearningSessions,
    PomodoroSessions,
    UserProfiles,
    Achievements,
    Notes,
    CommunityPosts,
    CustomDomains,
    DailyActivities,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'trackie_db');
  }

  String generateUuid() => const Uuid().v4();

  Future<List<LearningItem>> getAllItems() => select(learningItems).get();
  Stream<List<LearningItem>> watchAllItems() => select(learningItems).watch();
  Future<int> insertItem(LearningItemsCompanion item) =>
      into(learningItems).insert(item);
  Future<bool> updateItem(LearningItemsCompanion item) =>
      update(learningItems).replace(item);
  Future<int> deleteItem(String id) =>
      (delete(learningItems)..where((t) => t.id.equals(id))).go();

  Future<AppSettingsTableData?> getSettings() => (select(
    appSettingsTable,
  )..where((t) => t.id.equals('settings'))).getSingleOrNull();
  Future<void> saveSettings(AppSettingsTableCompanion settings) async =>
      await into(appSettingsTable).insertOnConflictUpdate(settings);

  Future<List<Category>> getAllCategories() => select(categories).get();
  Stream<List<Category>> watchAllCategories() => select(categories).watch();
  Future<int> insertCategory(CategoriesCompanion cat) =>
      into(categories).insert(cat);
  Future<int> deleteCategory(String id) =>
      (delete(categories)..where((t) => t.id.equals(id))).go();

  Future<List<Tag>> getAllTags() => select(tags).get();
  Stream<List<Tag>> watchAllTags() => select(tags).watch();
  Future<int> insertTag(TagsCompanion tag) => into(tags).insert(tag);
  Future<int> deleteTag(String id) =>
      (delete(tags)..where((t) => t.id.equals(id))).go();

  Future<List<Note>> getAllNotes() => select(notes).get();
  Stream<List<Note>> watchAllNotes() => select(notes).watch();
  Future<int> insertNote(NotesCompanion note) => into(notes).insert(note);
  Future<bool> updateNote(NotesCompanion note) => update(notes).replace(note);
  Future<int> deleteNote(String id) =>
      (delete(notes)..where((t) => t.id.equals(id))).go();

  Future<List<Reminder>> getAllReminders() => select(reminders).get();
  Stream<List<Reminder>> watchAllReminders() => select(reminders).watch();
  Future<int> insertReminder(RemindersCompanion reminder) =>
      into(reminders).insert(reminder);
  Future<bool> updateReminder(RemindersCompanion reminder) =>
      update(reminders).replace(reminder);
  Future<int> deleteReminder(String id) =>
      (delete(reminders)..where((t) => t.id.equals(id))).go();

  Future<UserProfile?> getUserProfile() => (select(
    userProfiles,
  )..where((t) => t.id.equals('default'))).getSingleOrNull();
  Future<void> saveUserProfile(UserProfilesCompanion profile) async =>
      await into(userProfiles).insertOnConflictUpdate(profile);

  Future<List<Achievement>> getAllAchievements() => select(achievements).get();
  Stream<List<Achievement>> watchAllAchievements() =>
      select(achievements).watch();
  Future<int> insertAchievement(AchievementsCompanion achievement) =>
      into(achievements).insert(achievement);
  Future<bool> updateAchievement(AchievementsCompanion achievement) =>
      update(achievements).replace(achievement);

  Future<List<LearningSession>> getAllSessions() =>
      select(learningSessions).get();
  Stream<List<LearningSession>> watchAllSessions() =>
      select(learningSessions).watch();
  Future<int> insertSession(LearningSessionsCompanion session) =>
      into(learningSessions).insert(session);

  Future<List<PomodoroSession>> getAllPomodoroSessions() =>
      select(pomodoroSessions).get();
  Stream<List<PomodoroSession>> watchAllPomodoroSessions() =>
      select(pomodoroSessions).watch();
  Future<int> insertPomodoroSession(PomodoroSessionsCompanion session) =>
      into(pomodoroSessions).insert(session);
  Future<void> updatePomodoroSession(PomodoroSessionsCompanion session) async =>
      await (update(
        pomodoroSessions,
      )..where((t) => t.id.equals(session.id.value))).write(session);

  Future<List<CommunityPost>> getAllPosts() => select(communityPosts).get();
  Stream<List<CommunityPost>> watchAllPosts() => select(communityPosts).watch();
  Future<int> insertPost(CommunityPostsCompanion post) =>
      into(communityPosts).insert(post);
  Future<bool> updatePost(CommunityPostsCompanion post) =>
      update(communityPosts).replace(post);

  Future<List<CustomDomain>> getAllDomains() => select(customDomains).get();
  Stream<List<CustomDomain>> watchAllDomains() => select(customDomains).watch();
  Future<int> insertDomain(CustomDomainsCompanion domain) =>
      into(customDomains).insert(domain);
  Future<int> deleteDomain(String id) =>
      (delete(customDomains)..where((t) => t.id.equals(id))).go();

  Future<int> deleteAllItems() => (delete(learningItems)).go();
  Future<int> deleteAllNotes() => (delete(notes)).go();
  Future<int> deleteAllReminders() => (delete(reminders)).go();
  Future<int> deleteAllCategories() => (delete(categories)).go();
  Future<int> deleteAllTags() => (delete(tags)).go();

  Future<List<DailyActivity>> getAllActivities() =>
      select(dailyActivities).get();
  Stream<List<DailyActivity>> watchAllActivities() =>
      select(dailyActivities).watch();
  Future<int> insertActivity(DailyActivitiesCompanion activity) =>
      into(dailyActivities).insert(activity);
}
