import 'package:hive/hive.dart';
import '../models/models.dart';

class LearningRepository {
  static const String _boxName = 'learning_items';
  late Box<dynamic> _box;
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
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
}

class CategoryRepository {
  static const String _boxName = 'categories';
  late Box<dynamic> _box;
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  List<Category> getAll() =>
      _box.values
          .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
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
  static const String _boxName = 'tags';
  late Box<dynamic> _box;
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  List<Tag> getAll() =>
      _box.values
          .map((e) => Tag.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
  Future<void> add(Tag t) async {
    await _box.put(t.id, t.toJson());
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}

class SettingsRepository {
  static const String _boxName = 'settings';
  static const String _key = 'app_settings';
  late Box<dynamic> _box;
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
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
}
