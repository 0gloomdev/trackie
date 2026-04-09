import 'package:hive/hive.dart';
import '../models/models.dart';

class LearningRepository {
  late Box<dynamic> _box;

  Future<void> init() async {
    _box = await Hive.openBox('learning_items');
  }

  List<LearningItem> getAll() =>
      _box.values
          .map((e) => LearningItem.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  List<LearningItem> getByType(String type) =>
      getAll().where((i) => i.type == type).toList();
  List<LearningItem> getByStatus(String status) =>
      getAll().where((i) => i.status == status).toList();
  List<LearningItem> getFavorites() =>
      getAll().where((i) => i.isFavorite).toList();
  LearningItem? getById(String id) {
    try {
      return getAll().firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> add(LearningItem item) async {
    await _box.put(item.id, item.toJson());
  }

  Future<void> update(LearningItem item) async {
    await _box.put(item.id, item.toJson());
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> deleteAll() async {
    await _box.clear();
  }

  List<LearningItem> search(String query) {
    final q = query.toLowerCase();
    return getAll()
        .where(
          (i) =>
              i.title.toLowerCase().contains(q) ||
              (i.description?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  int get totalCount => getAll().length;
  int get completedCount =>
      getAll().where((i) => i.status == 'completed').length;
  int get inProgressCount =>
      getAll().where((i) => i.status == 'in_progress').length;
  int get pendingCount => getAll().where((i) => i.status == 'pending').length;
  Map<String, int> getCountByType() {
    final m = <String, int>{};
    for (final i in getAll()) {
      m[i.type] = (m[i.type] ?? 0) + 1;
    }
    return m;
  }

  Map<String, int> getCountByStatus() {
    final m = <String, int>{};
    for (final i in getAll()) {
      m[i.status] = (m[i.status] ?? 0) + 1;
    }
    return m;
  }

  List<Map<String, dynamic>> exportToJson() {
    return getAll().map((i) => i.toJson()).toList();
  }

  Future<void> importFromJson(List<dynamic> data) async {
    for (final item in data) {
      await _box.put(item['id'], Map<String, dynamic>.from(item));
    }
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}

class CategoryRepository {
  late Box<dynamic> _box;

  Future<void> init() async {
    _box = await Hive.openBox('categories');
  }

  List<Category> getAll() =>
      _box.values
          .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

  List<Map<String, dynamic>> exportToJson() {
    return getAll().map((c) => c.toJson()).toList();
  }

  Future<void> importFromJson(List<dynamic> data) async {
    for (final item in data) {
      await _box.put(item['id'], Map<String, dynamic>.from(item));
    }
  }

  Future<void> add(Category c) async {
    await _box.put(c.id, c.toJson());
  }

  Future<void> update(Category c) async {
    await _box.put(c.id, c.toJson());
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}

class TagRepository {
  late Box<dynamic> _box;

  Future<void> init() async {
    _box = await Hive.openBox('tags');
  }

  List<Tag> getAll() =>
      _box.values
          .map((e) => Tag.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

  List<Map<String, dynamic>> exportToJson() {
    return getAll().map((t) => t.toJson()).toList();
  }

  Future<void> importFromJson(List<dynamic> data) async {
    for (final item in data) {
      await _box.put(item['id'], Map<String, dynamic>.from(item));
    }
  }

  Future<void> add(Tag t) async {
    await _box.put(t.id, t.toJson());
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}

class SettingsRepository {
  static const String _key = 'app_settings';
  late Box<dynamic> _box;

  Future<void> init() async {
    _box = await Hive.openBox('settings');
  }

  AppSettings get() {
    final d = _box.get(_key);
    return d == null
        ? AppSettings()
        : AppSettings.fromJson(Map<String, dynamic>.from(d));
  }

  Future<void> save(AppSettings s) async {
    await _box.put(_key, s.toJson());
  }

  Map<String, dynamic> exportToJson() {
    return get().toJson();
  }

  Future<void> importFromJson(Map<String, dynamic> data) async {
    await save(AppSettings.fromJson(data));
  }
}

class AchievementsRepository {
  late Box<dynamic> _box;

  void init(Box<dynamic> box) {
    _box = box;
  }

  List<Achievement> getAll() {
    if (_box.isEmpty) {
      final defaults = Achievement.getDefaultAchievements();
      for (final a in defaults) {
        _box.put(a.id, a.toJson());
      }
      return defaults;
    }
    return _box.values
        .map((e) => Achievement.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Achievement? getById(String id) {
    final d = _box.get(id);
    return d == null
        ? null
        : Achievement.fromJson(Map<String, dynamic>.from(d));
  }

  Future<void> unlock(String id) async {
    final a = getById(id);
    if (a != null && !a.unlocked) {
      final updated = a.copyWith(unlocked: true, unlockedAt: DateTime.now());
      await _box.put(id, updated.toJson());
    }
  }

  int get unlockedCount => getAll().where((a) => a.unlocked).length;

  List<Map<String, dynamic>> exportToJson() {
    return getAll().map((a) => a.toJson()).toList();
  }

  Future<void> importFromJson(List<dynamic> data) async {
    for (final item in data) {
      await _box.put(item['id'], Map<String, dynamic>.from(item));
    }
  }
}

class ProfileRepository {
  static const String _key = 'user_profile';
  late Box<dynamic> _box;

  void init(Box<dynamic> box) {
    _box = box;
  }

  UserProfile get() {
    final d = _box.get(_key);
    return d == null
        ? UserProfile.defaultProfile()
        : UserProfile.fromJson(Map<String, dynamic>.from(d));
  }

  Future<void> save(UserProfile p) async {
    await _box.put(_key, p.toJson());
  }

  Map<String, dynamic> exportToJson() {
    return get().toJson();
  }

  Future<void> importFromJson(Map<String, dynamic> data) async {
    await save(UserProfile.fromJson(data));
  }

  Future<void> addXp(int amount) async {
    final p = get();
    final newXp = p.xp + amount;
    final newNivel = _calculateLevel(newXp);
    await save(p.copyWith(xp: newXp, nivel: newNivel));
  }

  int _calculateLevel(int xp) {
    int level = 1;
    int xpRequired = 100;
    int totalXp = 0;
    while (totalXp + xpRequired <= xp) {
      totalXp += xpRequired;
      level++;
      xpRequired = level * 100;
    }
    return level;
  }
}

class CommunityRepository {
  late Box<dynamic> _box;
  static const String _userPostsKey = 'user_posts';

  void init(Box<dynamic> box) {
    _box = box;
  }

  List<CommunityPost> getUserPosts() {
    final data = _box.get(_userPostsKey);
    if (data == null) return [];
    return (data as List)
        .map((e) => CommunityPost.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<CommunityPost> getAllPosts() {
    return getUserPosts();
  }

  Future<void> addPost(CommunityPost post) async {
    final posts = getUserPosts();
    posts.insert(0, post);
    await _box.put(_userPostsKey, posts.map((p) => p.toJson()).toList());
  }

  Future<void> likePost(String postId) async {
    final posts = getAllPosts();
    final index = posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = posts[index];
      posts[index] = post.copyWith(likes: post.likes + 1);
      await _box.put(
        _userPostsKey,
        posts.where((p) => p.isUserPost).map((p) => p.toJson()).toList(),
      );
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    final posts = getAllPosts();
    final index = posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = posts[index];
      final comments = List<Comment>.from(post.comments)..add(comment);
      posts[index] = post.copyWith(comments: comments);

      final userPosts = posts.where((p) => p.isUserPost).toList();
      await _box.put(_userPostsKey, userPosts.map((p) => p.toJson()).toList());
    }
  }
}

// ============================================
// NOTES REPOSITORY
// ============================================

class NotesRepository {
  late Box<dynamic> _box;
  static const String _notesKey = 'notes';

  void init(Box<dynamic> box) {
    _box = box;
  }

  List<Note> getAll() {
    final raw = _box.get(_notesKey, defaultValue: <dynamic>[]);
    if (raw == null || raw is! List) return [];
    final notes = raw
        .map((e) => Note.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return notes;
  }

  Note? getById(String id) {
    try {
      return getAll().firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Note> getByItemId(String itemId) {
    return getAll().where((n) => n.itemId == itemId).toList();
  }

  Future<void> add(Note note) async {
    final notes = getAll();
    notes.add(note);
    await _box.put(_notesKey, notes.map((n) => n.toJson()).toList());
  }

  Future<void> update(Note note) async {
    final notes = getAll();
    final index = notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      notes[index] = note;
      await _box.put(_notesKey, notes.map((n) => n.toJson()).toList());
    }
  }

  Future<void> delete(String id) async {
    final notes = getAll();
    notes.removeWhere((n) => n.id == id);
    await _box.put(_notesKey, notes.map((n) => n.toJson()).toList());
  }

  Future<void> deleteAll() async {
    await _box.delete(_notesKey);
  }
}

// ============================================
// REMINDERS REPOSITORY
// ============================================

class RemindersRepository {
  late Box<dynamic> _box;
  static const String _remindersKey = 'reminders';

  void init(Box<dynamic> box) {
    _box = box;
  }

  List<Reminder> getAll() {
    final raw = _box.get(_remindersKey, defaultValue: <dynamic>[]);
    if (raw == null || raw is! List) return [];
    return raw
        .map((e) => Reminder.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  Reminder? getById(String id) {
    try {
      return getAll().firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Reminder> getByItemId(String itemId) {
    return getAll().where((r) => r.itemId == itemId).toList();
  }

  List<Reminder> getPending() {
    return getAll().where((r) => !r.isCompleted).toList();
  }

  List<Reminder> getToday() {
    return getAll().where((r) => r.isToday).toList();
  }

  Future<void> add(Reminder reminder) async {
    final reminders = getAll();
    reminders.add(reminder);
    await _box.put(_remindersKey, reminders.map((r) => r.toJson()).toList());
  }

  Future<void> update(Reminder reminder) async {
    final reminders = getAll();
    final index = reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      reminders[index] = reminder;
      await _box.put(_remindersKey, reminders.map((r) => r.toJson()).toList());
    }
  }

  Future<void> delete(String id) async {
    final reminders = getAll();
    reminders.removeWhere((r) => r.id == id);
    await _box.put(_remindersKey, reminders.map((r) => r.toJson()).toList());
  }

  Future<void> markCompleted(String id) async {
    final reminder = getById(id);
    if (reminder != null) {
      await update(reminder.copyWith(isCompleted: true));
    }
  }

  Future<void> deleteAll() async {
    await _box.delete(_remindersKey);
  }
}

// ============================================
// LEARNING SESSIONS REPOSITORY
// ============================================

class LearningSessionsRepository {
  late Box<dynamic> _box;
  static const String _sessionsKey = 'learning_sessions';

  void init(Box<dynamic> box) {
    _box = box;
  }

  List<LearningSession> getAll() {
    final raw = _box.get(_sessionsKey, defaultValue: <dynamic>[]);
    if (raw == null || raw is! List) return [];
    return raw
        .map(
          (e) => LearningSession.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  LearningSession? getById(String id) {
    try {
      return getAll().firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<LearningSession> getByItemId(String itemId) {
    return getAll().where((s) => s.itemId == itemId).toList();
  }

  List<LearningSession> getByDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return getAll().where((s) {
      final sessionDate = DateTime(
        s.startTime.year,
        s.startTime.month,
        s.startTime.day,
      );
      return sessionDate.isAtSameMomentAs(dateOnly);
    }).toList();
  }

  List<LearningSession> getByDateRange(DateTime start, DateTime end) {
    return getAll().where((s) {
      return s.startTime.isAfter(start) && s.startTime.isBefore(end);
    }).toList();
  }

  List<LearningSession> getTodaySessions() {
    return getByDate(DateTime.now());
  }

  int getTodayMinutes() {
    return getTodaySessions()
        .where((s) => s.completed)
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  Future<void> add(LearningSession session) async {
    final sessions = getAll();
    sessions.add(session);
    await _box.put(_sessionsKey, sessions.map((s) => s.toJson()).toList());
  }

  Future<void> update(LearningSession session) async {
    final sessions = getAll();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      sessions[index] = session;
      await _box.put(_sessionsKey, sessions.map((s) => s.toJson()).toList());
    }
  }

  Future<void> delete(String id) async {
    final sessions = getAll();
    sessions.removeWhere((s) => s.id == id);
    await _box.put(_sessionsKey, sessions.map((s) => s.toJson()).toList());
  }

  Future<void> deleteAll() async {
    await _box.delete(_sessionsKey);
  }
}
