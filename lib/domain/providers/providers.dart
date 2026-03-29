import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../core/services/data_export_service.dart';

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
final tagRepositoryProvider = Provider<TagRepository>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
final achievementsRepositoryProvider = Provider<AchievementsRepository>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

final dataExportServiceProvider = Provider<DataExportService>((ref) {
  return DataExportService(
    learningRepo: ref.watch(learningRepositoryProvider),
    categoryRepo: ref.watch(categoryRepositoryProvider),
    tagRepo: ref.watch(tagRepositoryProvider),
    settingsRepo: ref.watch(settingsRepositoryProvider),
    achievementsRepo: ref.watch(achievementsRepositoryProvider),
    profileRepo: ref.watch(profileRepositoryProvider),
  );
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(ref.watch(settingsRepositoryProvider)),
);

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repo;
  SettingsNotifier(this._repo) : super(AppSettings()) {
    _load();
  }
  void _load() {
    state = _repo.get();
  }

  Future<void> update(AppSettings s) async {
    await _repo.save(s);
    state = s;
  }

  Future<void> setTheme(String t) async {
    await update(state.copyWith(theme: t));
  }

  Future<void> setDefaultView(String v) async {
    await update(state.copyWith(defaultView: v));
  }

  Future<void> toggleCompactMode() async {
    await update(state.copyWith(compactMode: !state.compactMode));
  }

  Future<void> toggleTheme() async {
    final newTheme = state.theme == 'dark' ? 'light' : 'dark';
    await setTheme(newTheme);
  }

  Future<void> toggleViewMode() async {
    await update(
      state.copyWith(
        defaultView: state.defaultView == 'grid' ? 'list' : 'grid',
      ),
    );
  }

  Future<void> setLocale(String locale) async {
    await update(state.copyWith(locale: locale));
  }

  Future<void> toggleNotifications() async {
    await update(
      state.copyWith(notificationsEnabled: !state.notificationsEnabled),
    );
  }

  Future<void> completeOnboarding() async {
    await update(state.copyWith(showOnboarding: false));
  }

  Future<void> updateLastBackupDate(DateTime date) async {
    await update(state.copyWith(lastBackupDate: date));
  }
}

final learningItemsProvider =
    StateNotifierProvider<LearningItemsNotifier, List<LearningItem>>(
      (ref) =>
          LearningItemsNotifier(ref.watch(learningRepositoryProvider), ref),
    );

class LearningItemsNotifier extends StateNotifier<List<LearningItem>> {
  final LearningRepository _repo;
  final Ref ref;
  LearningItemsNotifier(this._repo, this.ref) : super([]) {
    _load();
  }
  void _load() {
    state = _repo.getAll();
  }

  Future<void> add(LearningItem i) async {
    await _repo.add(i);
    _load();
  }

  Future<void> update(LearningItem i) async {
    final oldItem = _repo.getById(i.id);
    final wasCompleted = oldItem?.status != 'completed';
    final isNowCompleted = i.status == 'completed';

    await _repo.update(i);
    _load();

    if (wasCompleted && isNowCompleted) {
      final checker = ref.read(achievementCheckerProvider);
      await checker.checkItemCompleted(i);
      ref.read(dailyGoalsProvider.notifier).incrementItemsCompleted();

      // Add notification for item completion
      ref
          .read(notificationsProvider.notifier)
          .addNotification(
            AppNotification(
              titulo: '¡Item completado!',
              mensaje: i.title,
              tipo: 'item',
            ),
          );
    }
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _load();
  }

  Future<void> toggleFavorite(String id) async {
    final i = _repo.getById(id);
    if (i != null) {
      final newFavorite = !i.isFavorite;
      await _repo.update(i.copyWith(isFavorite: newFavorite));
      _load();

      if (newFavorite) {
        final checker = ref.read(achievementCheckerProvider);
        await checker.checkFavoritesChanged();
      }
    }
  }

  Future<void> togglePinned(String id) async {
    final i = _repo.getById(id);
    if (i != null) {
      await _repo.update(i.copyWith(isPinned: !i.isPinned));
      _load();
    }
  }

  Future<void> updateLastAccessed(String id) async {
    final i = _repo.getById(id);
    if (i != null) {
      await _repo.update(i.copyWith(lastAccessedAt: DateTime.now()));
      _load();
    }
  }

  Future<void> duplicateItem(String id) async {
    final i = _repo.getById(id);
    if (i != null) {
      final duplicate = i.copyWith(
        id: null,
        title: '${i.title} (copia)',
        isFavorite: false,
        isPinned: false,
        progress: 0,
        status: 'pending',
        createdAt: null,
        updatedAt: null,
      );
      await _repo.add(duplicate);
      _load();
    }
  }

  Future<void> bulkUpdateStatus(List<String> ids, String status) async {
    for (final id in ids) {
      final i = _repo.getById(id);
      if (i != null) {
        int progress = i.progress;
        if (status == 'completed') progress = 100;
        if (status == 'pending') progress = 0;
        await _repo.update(i.copyWith(status: status, progress: progress));
      }
    }
    _load();
  }

  Future<void> bulkDelete(List<String> ids) async {
    for (final id in ids) {
      await _repo.delete(id);
    }
    _load();
  }

  Future<void> bulkToggleFavorite(List<String> ids) async {
    for (final id in ids) {
      final i = _repo.getById(id);
      if (i != null) {
        await _repo.update(i.copyWith(isFavorite: !i.isFavorite));
      }
    }
    _load();
  }

  Future<void> updateProgress(String id, int progress) async {
    final i = _repo.getById(id);
    if (i != null) {
      String status = 'pending';
      if (progress > 0 && progress < 100) status = 'in_progress';
      if (progress >= 100) status = 'completed';
      await _repo.update(i.copyWith(progress: progress, status: status));
      _load();
    }
  }

  Future<void> updateStatus(String id, String status) async {
    final i = _repo.getById(id);
    if (i != null) {
      int progress = i.progress;
      if (status == 'completed') progress = 100;
      if (status == 'pending') progress = 0;
      await _repo.update(i.copyWith(status: status, progress: progress));
      _load();
    }
  }

  void refresh() => _load();

  Future<void> deleteAll() async {
    await _repo.deleteAll();
    _load();
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<Category>>(
      (ref) => CategoriesNotifier(ref.watch(categoryRepositoryProvider)),
    );

class CategoriesNotifier extends StateNotifier<List<Category>> {
  final CategoryRepository _repo;
  CategoriesNotifier(this._repo) : super([]) {
    _load();
  }
  void _load() {
    state = _repo.getAll();
  }

  Future<void> add(Category c) async {
    await _repo.add(c);
    _load();
  }

  Future<void> update(Category c) async {
    await _repo.update(c);
    _load();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _load();
  }
}

final tagsProvider = StateNotifierProvider<TagsNotifier, List<Tag>>(
  (ref) => TagsNotifier(ref.watch(tagRepositoryProvider)),
);

class TagsNotifier extends StateNotifier<List<Tag>> {
  final TagRepository _repo;
  TagsNotifier(this._repo) : super([]) {
    _load();
  }
  void _load() {
    state = _repo.getAll();
  }

  Future<void> add(Tag t) async {
    await _repo.add(t);
    _load();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _load();
  }
}

final achievementsProvider =
    StateNotifierProvider<AchievementsNotifier, List<Achievement>>(
      (ref) => AchievementsNotifier(ref.watch(achievementsRepositoryProvider)),
    );

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  final AchievementsRepository _repo;
  AchievementsNotifier(this._repo) : super([]) {
    _load();
  }
  void _load() {
    state = _repo.getAll();
  }

  Future<void> unlock(String id) async {
    await _repo.unlock(id);
    _load();
  }

  int get unlockedCount => state.where((a) => a.desbloqueado).length;
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>(
      (ref) => UserProfileNotifier(ref.watch(profileRepositoryProvider)),
    );

class UserProfileNotifier extends StateNotifier<UserProfile> {
  final ProfileRepository _repo;
  UserProfileNotifier(this._repo) : super(UserProfile.defaultProfile()) {
    _load();
  }
  void _load() {
    state = _repo.get();
  }

  Future<void> addXp(int amount) async {
    await _repo.addXp(amount);
    _load();
  }

  Future<void> updateProfile(UserProfile p) async {
    await _repo.save(p);
    _load();
  }
}

class FilterState {
  final String? type;
  final String? status;
  final String? priority;
  final String? categoryId;
  final String? searchQuery;
  final bool showFavoritesOnly;
  final String sortBy;
  final bool sortAscending;
  const FilterState({
    this.type,
    this.status,
    this.priority,
    this.categoryId,
    this.searchQuery,
    this.showFavoritesOnly = false,
    this.sortBy = 'updatedAt',
    this.sortAscending = false,
  });
  FilterState copyWith({
    String? type,
    String? status,
    String? priority,
    String? categoryId,
    String? searchQuery,
    bool? showFavoritesOnly,
    String? sortBy,
    bool? sortAscending,
    bool clearType = false,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearCategoryId = false,
    bool clearSearch = false,
  }) {
    return FilterState(
      type: clearType ? null : (type ?? this.type),
      status: clearStatus ? null : (status ?? this.status),
      priority: clearPriority ? null : (priority ?? this.priority),
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}

final filterProvider = StateProvider<FilterState>((ref) => const FilterState());

final filteredItemsProvider = Provider<List<LearningItem>>((ref) {
  final items = ref.watch(learningItemsProvider);
  final f = ref.watch(filterProvider);
  var filtered = items.toList();
  if (f.type != null) {
    filtered = filtered.where((i) => i.type == f.type).toList();
  }
  if (f.status != null) {
    filtered = filtered.where((i) => i.status == f.status).toList();
  }
  if (f.categoryId != null) {
    filtered = filtered.where((i) => i.categoryId == f.categoryId).toList();
  }
  if (f.showFavoritesOnly) {
    filtered = filtered.where((i) => i.isFavorite).toList();
  }
  if (f.searchQuery != null && f.searchQuery!.isNotEmpty) {
    final q = f.searchQuery!.toLowerCase();
    filtered = filtered
        .where(
          (i) =>
              i.title.toLowerCase().contains(q) ||
              (i.description?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }
  filtered.sort((a, b) {
    int c;
    switch (f.sortBy) {
      case 'title':
        c = a.title.compareTo(b.title);
        break;
      case 'createdAt':
        c = a.createdAt.compareTo(b.createdAt);
        break;
      case 'progress':
        c = a.progress.compareTo(b.progress);
        break;
      case 'type':
        c = a.type.compareTo(b.type);
        break;
      default:
        c = a.updatedAt.compareTo(b.updatedAt);
    }
    return f.sortAscending ? c : -c;
  });
  return filtered;
});

final statisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final items = ref.watch(learningItemsProvider);
  return {
    'total': items.length,
    'completed': items.where((i) => i.status == 'completed').length,
    'inProgress': items.where((i) => i.status == 'in_progress').length,
    'pending': items.where((i) => i.status == 'pending').length,
    'byType': _countBy(items, (i) => i.type),
    'byStatus': _countBy(items, (i) => i.status),
  };
});
Map<String, int> _countBy(
  List<LearningItem> items,
  String Function(LearningItem) f,
) {
  final m = <String, int>{};
  for (final i in items) {
    final k = f(i);
    m[k] = (m[k] ?? 0) + 1;
  }
  return m;
}

final pinnedItemsProvider = Provider<List<LearningItem>>((ref) {
  final items = ref.watch(learningItemsProvider);
  return items.where((i) => i.isPinned).toList()
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
});

final favoriteItemsProvider = Provider<List<LearningItem>>((ref) {
  final items = ref.watch(learningItemsProvider);
  return items.where((i) => i.isFavorite).toList()
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
});

final recentInProgressItemsProvider = Provider<List<LearningItem>>((ref) {
  final items = ref.watch(learningItemsProvider);
  return items.where((i) => i.status == 'in_progress').toList()
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
});

final recentItemsProvider = Provider<List<LearningItem>>((ref) {
  final items = ref.watch(learningItemsProvider);
  return items.toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
});

final searchProvider = StateProvider<String>((ref) => '');
final versionTapProvider = StateProvider<int>((ref) => 0);

final advancedFilteredItemsProvider = Provider<List<LearningItem>>((ref) {
  final items = ref.watch(learningItemsProvider);
  final f = ref.watch(filterProvider);
  final searchQuery = ref.watch(searchProvider).toLowerCase();

  var filtered = items.toList();

  if (f.type != null) {
    filtered = filtered.where((i) => i.type == f.type).toList();
  }
  if (f.status != null) {
    filtered = filtered.where((i) => i.status == f.status).toList();
  }
  if (f.priority != null) {
    filtered = filtered.where((i) => i.priority == f.priority).toList();
  }
  if (f.categoryId != null) {
    filtered = filtered.where((i) => i.categoryId == f.categoryId).toList();
  }
  if (f.showFavoritesOnly) {
    filtered = filtered.where((i) => i.isFavorite).toList();
  }
  if (searchQuery.isNotEmpty) {
    filtered = filtered.where((i) {
      return i.title.toLowerCase().contains(searchQuery) ||
          (i.description?.toLowerCase().contains(searchQuery) ?? false) ||
          (i.notes?.toLowerCase().contains(searchQuery) ?? false) ||
          i.tags.any((t) => t.toLowerCase().contains(searchQuery));
    }).toList();
  }

  filtered.sort((a, b) {
    int c;
    switch (f.sortBy) {
      case 'title':
        c = a.title.compareTo(b.title);
        break;
      case 'createdAt':
        c = a.createdAt.compareTo(b.createdAt);
        break;
      case 'progress':
        c = a.progress.compareTo(b.progress);
        break;
      case 'type':
        c = a.type.compareTo(b.type);
        break;
      default:
        c = a.updatedAt.compareTo(b.updatedAt);
    }
    return f.sortAscending ? c : -c;
  });

  return filtered;
});

// ============================================
// COMMUNITY FEED PROVIDER
// ============================================

final communityFeedProvider =
    StateNotifierProvider<CommunityFeedNotifier, List<CommunityPost>>(
      (ref) => CommunityFeedNotifier(ref.watch(communityRepositoryProvider)),
    );

class CommunityFeedNotifier extends StateNotifier<List<CommunityPost>> {
  final CommunityRepository? _repo;

  CommunityFeedNotifier(this._repo) : super([]) {
    _load();
  }

  void _load() {
    final repo = _repo;
    if (repo != null) {
      state = repo.getAllPosts();
    } else {
      state = _generateDefaultFeed();
    }
  }

  List<CommunityPost> _generateDefaultFeed() {
    final now = DateTime.now();
    return [
      CommunityPost(
        tipo: 'item_completed',
        contenido: 'completó "Flutter Complete Guide"',
        timestamp: now.subtract(const Duration(hours: 2)),
        anonimo: false,
        usuarioNombre: 'María G.',
        likes: 12,
        isUserPost: false,
      ),
      CommunityPost(
        tipo: 'achievement_unlocked',
        contenido: 'desbloqueó el logro "Maestro"',
        timestamp: now.subtract(const Duration(hours: 5)),
        anonimo: false,
        usuarioNombre: 'Carlos R.',
        likes: 8,
        isUserPost: false,
      ),
    ];
  }

  Future<void> addUserPost(CommunityPost post) async {
    final repo = _repo;
    if (repo != null) {
      await repo.addPost(post);
      _load();
    }
  }

  Future<void> likePost(String postId) async {
    final repo = _repo;
    if (repo != null) {
      await repo.likePost(postId);
      _load();
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    final repo = _repo;
    if (repo != null) {
      await repo.addComment(postId, comment);
      _load();
    }
  }

  void refresh() {
    _load();
  }

  Future<void> shareItemCompleted(LearningItem item) async {
    final post = CommunityPost(
      tipo: 'item_completed',
      contenido: 'completó "${item.title}"',
      relatedItemId: item.id,
      isUserPost: true,
    );
    await addUserPost(post);
  }

  Future<void> shareAchievementUnlocked(Achievement achievement) async {
    final post = CommunityPost(
      tipo: 'achievement_unlocked',
      contenido: 'desbloqueó el logro "${achievement.titulo}"',
      relatedAchievementId: achievement.id,
      isUserPost: true,
    );
    await addUserPost(post);
  }

  Future<void> shareStreakMilestone(int streak) async {
    final post = CommunityPost(
      tipo: 'streak_milestone',
      contenido: 'alcanzó $streak días de racha',
      isUserPost: true,
    );
    await addUserPost(post);
  }

  Future<void> shareLevelUp(int level) async {
    final post = CommunityPost(
      tipo: 'level_up',
      contenido: 'subió al nivel $level',
      isUserPost: true,
    );
    await addUserPost(post);
  }
}

// ============================================
// SEARCH PROVIDER (Advanced)
// ============================================

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryNotifier, List<String>>(
      (ref) => SearchHistoryNotifier(),
    );

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier() : super([]) {
    _load();
  }

  void _load() {
    try {
      final box = Hive.box('settings');
      final data = box.get('searchHistory');
      if (data != null) {
        state = List<String>.from(data);
      }
    } catch (e) {
      // Use empty history
    }
  }

  Future<void> _save() async {
    try {
      final box = Hive.box('settings');
      await box.put('searchHistory', state);
    } catch (e) {
      // Handle error
    }
  }

  void addToHistory(String query) {
    if (query.trim().isEmpty) return;

    state = state.where((q) => q != query).toList();
    state = [query, ...state].take(20).toList();
    _save();
  }

  void removeFromHistory(String query) {
    state = state.where((q) => q != query).toList();
    _save();
  }

  void clearHistory() {
    state = [];
    _save();
  }
}

// ============================================
// NOTIFICATION PROVIDER
// ============================================

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<AppNotification>>(
      (ref) => NotificationsNotifier(),
    );

class AppNotification {
  final String id;
  final String titulo;
  final String mensaje;
  final String tipo;
  final DateTime timestamp;
  final bool leida;

  AppNotification({
    String? id,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    DateTime? timestamp,
    this.leida = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       timestamp = timestamp ?? DateTime.now();
}

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  NotificationsNotifier() : super([]);

  void addNotification(AppNotification notification) {
    state = [notification, ...state];
  }

  void markAsRead(String id) {
    state = state.map((n) {
      if (n.id == id) {
        return AppNotification(
          id: n.id,
          titulo: n.titulo,
          mensaje: n.mensaje,
          tipo: n.tipo,
          timestamp: n.timestamp,
          leida: true,
        );
      }
      return n;
    }).toList();
  }

  void markAllAsRead() {
    state = state
        .map(
          (n) => AppNotification(
            id: n.id,
            titulo: n.titulo,
            mensaje: n.mensaje,
            tipo: n.tipo,
            timestamp: n.timestamp,
            leida: true,
          ),
        )
        .toList();
  }

  void clearNotifications() {
    state = [];
  }

  int get unreadCount => state.where((n) => !n.leida).length;
}

// ============================================
// ACHIEVEMENT CHECKER SERVICE
// ============================================

class AchievementChecker {
  final Ref ref;

  AchievementChecker(this.ref);

  Future<void> checkItemCompleted(LearningItem item) async {
    final items = ref.read(learningItemsProvider);
    final completedCount = items.where((i) => i.status == 'completed').length;
    final achievementsNotifier = ref.read(achievementsProvider.notifier);

    if (completedCount >= 1) {
      await achievementsNotifier.unlock('primer_paso');
      await _addXpForUnlock('primer_paso');
    }
    if (completedCount >= 5) {
      await achievementsNotifier.unlock('avido');
      await _addXpForUnlock('avido');
    }
    if (completedCount >= 10) {
      await achievementsNotifier.unlock('estudiante');
      await _addXpForUnlock('estudiante');
    }
    if (completedCount >= 25) {
      await achievementsNotifier.unlock('bibliotecario');
      await _addXpForUnlock('bibliotecario');
    }
    if (completedCount >= 50) {
      await achievementsNotifier.unlock('maestro');
      await _addXpForUnlock('maestro');
    }

    final createdAt = item.createdAt;
    final completedAt = item.updatedAt;
    if (completedAt.difference(createdAt).inHours < 24) {
      await achievementsNotifier.unlock('velocista');
      await _addXpForUnlock('velocista');
    }

    final urgentCompleted = items
        .where((i) => i.status == 'completed' && i.priority == 'high')
        .length;
    if (urgentCompleted >= 5) {
      await achievementsNotifier.unlock('prioritario');
      await _addXpForUnlock('prioritario');
    }
  }

  Future<void> checkStreakUpdated(int streak) async {
    final achievementsNotifier = ref.read(achievementsProvider.notifier);

    if (streak >= 7) {
      await achievementsNotifier.unlock('racha_7');
      await _addXpForUnlock('racha_7');
    }
    if (streak >= 30) {
      await achievementsNotifier.unlock('racha_30');
      await _addXpForUnlock('racha_30');
    }
  }

  Future<void> checkFavoritesChanged() async {
    final items = ref.read(learningItemsProvider);
    final favoriteCount = items.where((i) => i.isFavorite).length;

    if (favoriteCount >= 10) {
      final achievementsNotifier = ref.read(achievementsProvider.notifier);
      await achievementsNotifier.unlock('coleccionista');
      await _addXpForUnlock('coleccionista');
    }
  }

  Future<void> checkNightStudy() async {
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 5) {
      final achievementsNotifier = ref.read(achievementsProvider.notifier);
      await achievementsNotifier.unlock('noctambulo');
      await _addXpForUnlock('noctambulo');
    }
  }

  Future<void> _addXpForUnlock(String achievementId) async {
    final achievements = ref.read(achievementsProvider);
    final achievement = achievements.firstWhere(
      (a) => a.id == achievementId,
      orElse: () =>
          Achievement(id: '', titulo: '', descripcion: '', icono: '', tipo: ''),
    );
    if (achievement.id.isNotEmpty && achievement.xpRecompensa > 0) {
      ref.read(userProfileProvider.notifier).addXp(achievement.xpRecompensa);
      ref
          .read(notificationsProvider.notifier)
          .addNotification(
            AppNotification(
              titulo: '¡Logro desbloqueado!',
              mensaje:
                  '${achievement.titulo} (+${achievement.xpRecompensa} XP)',
              tipo: 'achievement',
            ),
          );
    }
  }
}

final achievementCheckerProvider = Provider<AchievementChecker>((ref) {
  return AchievementChecker(ref);
});

// ============================================
// DAILY GOALS PROVIDER
// ============================================

final dailyGoalsProvider =
    StateNotifierProvider<DailyGoalsNotifier, List<DailyGoal>>(
      (ref) => DailyGoalsNotifier(ref),
    );

class DailyGoalsNotifier extends StateNotifier<List<DailyGoal>> {
  final Ref _ref;
  bool _goalCompletedNotified = false;

  DailyGoalsNotifier(this._ref) : super([]) {
    _load();
  }

  void _load() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final existing = state.where((g) {
      final goalDate = DateTime(g.date.year, g.date.month, g.date.day);
      return goalDate.isAtSameMomentAs(today);
    }).toList();

    if (existing.isEmpty) {
      _goalCompletedNotified = false;
      state = [...state, DailyGoal(date: today)];
    } else {
      // Reset notification flag if goal is not completed
      if (!existing.first.completed) {
        _goalCompletedNotified = false;
      }
    }
  }

  DailyGoal get todayGoal {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return state.firstWhere(
      (g) => DateTime(
        g.date.year,
        g.date.month,
        g.date.day,
      ).isAtSameMomentAs(today),
      orElse: () => DailyGoal(),
    );
  }

  Future<void> updateTodayGoal(DailyGoal goal) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    state = state.map((g) {
      final goalDate = DateTime(g.date.year, g.date.month, g.date.day);
      if (goalDate.isAtSameMomentAs(today)) {
        return goal;
      }
      return g;
    }).toList();
  }

  Future<void> incrementItemsCompleted() async {
    final goal = todayGoal;
    final newCompleted = goal.itemsCompleted + 1;
    final completed = newCompleted >= goal.itemsToComplete;
    final wasCompleted = goal.completed;

    await updateTodayGoal(
      goal.copyWith(itemsCompleted: newCompleted, completed: completed),
    );

    // Notify when goal is first completed
    if (completed && !wasCompleted && !_goalCompletedNotified) {
      _goalCompletedNotified = true;
      _ref
          .read(notificationsProvider.notifier)
          .addNotification(
            AppNotification(
              titulo: '¡Meta diaria alcanzada!',
              mensaje: 'Has completado tu objetivo de hoy',
              tipo: 'goal',
            ),
          );
    }
  }

  Future<void> addMinutesStudied(int minutes) async {
    final goal = todayGoal;
    final wasCompleted = goal.completed;

    await updateTodayGoal(
      goal.copyWith(minutesStudied: goal.minutesStudied + minutes),
    );

    // Check if time goal is now complete
    final updatedGoal = todayGoal;
    if (updatedGoal.completed && !wasCompleted && !_goalCompletedNotified) {
      _goalCompletedNotified = true;
      _ref
          .read(notificationsProvider.notifier)
          .addNotification(
            AppNotification(
              titulo: '¡Meta diaria alcanzada!',
              mensaje: 'Has completado tu objetivo de hoy',
              tipo: 'goal',
            ),
          );
    }
  }

  List<DailyGoal> getGoalsForWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return state.where((g) {
      return g.date.isAfter(weekStart) || g.date.isAtSameMomentAs(weekStart);
    }).toList();
  }
}

// ============================================
// POMODORO PROVIDER
// ============================================

enum PomodoroState { idle, running, paused, breakTime }

final pomodoroStateProvider = StateProvider<PomodoroState>(
  (ref) => PomodoroState.idle,
);
final pomodoroTimeProvider = StateProvider<int>((ref) => 25 * 60);
final pomodoroSessionProvider = StateProvider<PomodoroSession?>((ref) => null);
final pomodoroSessionsProvider =
    StateNotifierProvider<PomodoroSessionsNotifier, List<PomodoroSession>>(
      (ref) => PomodoroSessionsNotifier(),
    );

class PomodoroSessionsNotifier extends StateNotifier<List<PomodoroSession>> {
  PomodoroSessionsNotifier() : super([]);

  Future<void> startSession({String? relatedItemId, int duration = 25}) async {
    final session = PomodoroSession(
      relatedItemId: relatedItemId,
      durationMinutes: duration,
    );
    state = [...state, session];
  }

  Future<void> completeSession(String sessionId) async {
    state = state.map((s) {
      if (s.id == sessionId) {
        return s.copyWith(completed: true, endTime: DateTime.now());
      }
      return s;
    }).toList();
  }

  int get todayCompletedSessions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return state.where((s) {
      return s.completed && s.startTime.isAfter(today);
    }).length;
  }

  int get todayMinutesStudied {
    return state
        .where((s) => s.completed)
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }
}

// ============================================
// ANALYTICS PROVIDER
// ============================================

final analyticsProvider = Provider<Analytics>((ref) {
  final items = ref.watch(learningItemsProvider);
  final goals = ref.watch(dailyGoalsProvider);
  final pomodoro = ref.watch(pomodoroSessionsProvider);
  final profile = ref.watch(userProfileProvider);

  final completedPomodoro = pomodoro
      .where((s) => s.completed && s.endTime != null)
      .toList();
  final todayMinutes = completedPomodoro
      .where((s) {
        final now = DateTime.now();
        return s.endTime!.year == now.year &&
            s.endTime!.month == now.month &&
            s.endTime!.day == now.day;
      })
      .fold(0, (sum, s) => sum + s.durationMinutes);

  final weekMinutes = completedPomodoro
      .where((s) {
        final now = DateTime.now();
        final weekAgo = now.subtract(const Duration(days: 7));
        return s.endTime!.isAfter(weekAgo);
      })
      .fold(0, (sum, s) => sum + s.durationMinutes);

  final itemsByType = <String, int>{};
  for (final item in items) {
    itemsByType[item.type] = (itemsByType[item.type] ?? 0) + 1;
  }

  return Analytics(
    totalItems: items.length,
    completedItems: items.where((i) => i.status == 'completed').length,
    inProgressItems: items.where((i) => i.status == 'in_progress').length,
    pendingItems: items.where((i) => i.status == 'pending').length,
    totalXp: profile.xp,
    currentStreak: profile.streak,
    longestStreak: profile.longestStreak,
    todayCompleted: goals.isNotEmpty ? goals.last.itemsCompleted : 0,
    todayMinutes: todayMinutes,
    weekMinutes: weekMinutes,
    totalPomodoroSessions: completedPomodoro.length,
    weeklyActivity: _generateWeeklyActivity(items),
    monthlyActivity: _generateMonthlyActivity(items),
    itemsByType: itemsByType,
    completionRate: items.isEmpty
        ? 0.0
        : items.where((i) => i.status == 'completed').length / items.length,
  );
});

List<DailyActivity> _generateWeeklyActivity(List<LearningItem> items) {
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: 7));

  return List.generate(7, (index) {
    final day = weekStart.add(Duration(days: index));
    final dayEnd = day.add(const Duration(days: 1));
    final dayItems = items
        .where(
          (i) =>
              i.status == 'completed' &&
              i.updatedAt.isAfter(day) &&
              i.updatedAt.isBefore(dayEnd),
        )
        .length;

    return DailyActivity(date: day, itemsCompleted: dayItems);
  });
}

List<DailyActivity> _generateMonthlyActivity(List<LearningItem> items) {
  final now = DateTime.now();
  final monthStart = DateTime(now.year, now.month - 1, now.day);

  return List.generate(30, (index) {
    final day = monthStart.add(Duration(days: index));
    final dayEnd = day.add(const Duration(days: 1));
    final dayItems = items
        .where(
          (i) =>
              i.status == 'completed' &&
              i.updatedAt.isAfter(day) &&
              i.updatedAt.isBefore(dayEnd),
        )
        .length;

    return DailyActivity(date: day, itemsCompleted: dayItems);
  });
}

class Analytics {
  final int totalItems;
  final int completedItems;
  final int inProgressItems;
  final int pendingItems;
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final int todayCompleted;
  final int todayMinutes;
  final int weekMinutes;
  final int totalPomodoroSessions;
  final List<DailyActivity> weeklyActivity;
  final List<DailyActivity> monthlyActivity;
  final Map<String, int> itemsByType;
  final double completionRate;

  Analytics({
    required this.totalItems,
    required this.completedItems,
    required this.inProgressItems,
    required this.pendingItems,
    required this.totalXp,
    required this.currentStreak,
    required this.longestStreak,
    required this.todayCompleted,
    required this.todayMinutes,
    required this.weekMinutes,
    required this.totalPomodoroSessions,
    required this.weeklyActivity,
    required this.monthlyActivity,
    required this.itemsByType,
    required this.completionRate,
  });
}

// ============================================
// RECOMMENDED RESOURCES PROVIDER
// ============================================

final recommendedResourcesProvider = Provider<List<RecommendedResource>>((ref) {
  return RecommendedResource.getDefaults();
});

final featuredResourcesProvider = Provider<List<RecommendedResource>>((ref) {
  final resources = ref.watch(recommendedResourcesProvider);
  return resources.take(5).toList();
});

// ============================================
// BACKGROUND REFRESH SERVICE
// Efficient periodic refresh without overwhelming the system
// ============================================

final backgroundRefreshProvider = Provider<void>((ref) {
  // This provider initializes the background refresh when first accessed
  // It keeps all critical providers in memory by watching them
  ref.watch(learningItemsProvider);
  ref.watch(dailyGoalsProvider);
  ref.watch(pomodoroSessionsProvider);
  ref.watch(userProfileProvider);
  ref.watch(achievementsProvider);
  ref.watch(analyticsProvider);
  ref.watch(statisticsProvider);
});

final lastUpdateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final autoRefreshProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 30), (i) {
    // This runs every 30 seconds to trigger UI updates for time-sensitive data
    return DateTime.now();
  });
});

// ============================================
// NOTES PROVIDER
// ============================================

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>(
  (ref) => NotesNotifier(ref.watch(notesRepositoryProvider)),
);

class NotesNotifier extends StateNotifier<List<Note>> {
  final NotesRepository _repo;

  NotesNotifier(this._repo) : super([]) {
    _load();
  }

  void _load() {
    state = _repo.getAll();
  }

  Future<void> add(Note note) async {
    await _repo.add(note);
    _load();
  }

  Future<void> update(Note note) async {
    await _repo.update(note);
    _load();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _load();
  }

  Future<void> togglePinned(String id) async {
    final note = _repo.getById(id);
    if (note != null) {
      await _repo.update(note.copyWith(isPinned: !note.isPinned));
      _load();
    }
  }

  List<Note> getByItemId(String itemId) {
    return state.where((n) => n.itemId == itemId).toList();
  }
}

// ============================================
// REMINDERS PROVIDER
// ============================================

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

final remindersProvider =
    StateNotifierProvider<RemindersNotifier, List<Reminder>>(
      (ref) => RemindersNotifier(ref.watch(remindersRepositoryProvider)),
    );

class RemindersNotifier extends StateNotifier<List<Reminder>> {
  final RemindersRepository _repo;

  RemindersNotifier(this._repo) : super([]) {
    _load();
  }

  void _load() {
    state = _repo.getAll();
  }

  Future<void> add(Reminder reminder) async {
    await _repo.add(reminder);
    _load();
  }

  Future<void> update(Reminder reminder) async {
    await _repo.update(reminder);
    _load();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _load();
  }

  Future<void> markCompleted(String id) async {
    await _repo.markCompleted(id);
    _load();
  }

  List<Reminder> getPending() {
    return state.where((r) => !r.isCompleted).toList();
  }

  List<Reminder> getToday() {
    return state.where((r) => r.isToday).toList();
  }

  List<Reminder> getDue() {
    return state.where((r) => r.isDue).toList();
  }
}

// ============================================
// STREAK MILESTONES
// ============================================

const List<int> streakMilestones = [3, 7, 14, 30, 60, 90, 180, 365];

final nextStreakMilestoneProvider = Provider<int>((ref) {
  final profile = ref.watch(userProfileProvider);
  final currentStreak = profile.streak;

  for (final milestone in streakMilestones) {
    if (currentStreak < milestone) {
      return milestone;
    }
  }
  return streakMilestones.last;
});

final streakProgressProvider = Provider<double>((ref) {
  final profile = ref.watch(userProfileProvider);
  final nextMilestone = ref.watch(nextStreakMilestoneProvider);

  final prevMilestone = streakMilestones
      .where((m) => m < nextMilestone)
      .fold<int>(0, (prev, m) => m);

  if (nextMilestone == prevMilestone) return 1.0;

  final progress =
      (profile.streak - prevMilestone) / (nextMilestone - prevMilestone);
  return progress.clamp(0.0, 1.0);
});

final streakDaysRemainingProvider = Provider<int>((ref) {
  final profile = ref.watch(userProfileProvider);
  final nextMilestone = ref.watch(nextStreakMilestoneProvider);
  return nextMilestone - profile.streak;
});

final achievedMilestonesProvider = Provider<List<int>>((ref) {
  final profile = ref.watch(userProfileProvider);
  return streakMilestones.where((m) => profile.streak >= m).toList();
});

final nextMilestonesProvider = Provider<List<int>>((ref) {
  final achieved = ref.watch(achievedMilestonesProvider);
  return streakMilestones.where((m) => !achieved.contains(m)).take(3).toList();
});

// ============================================
// LEARNING SESSIONS PROVIDER
// ============================================

final learningSessionsRepositoryProvider = Provider<LearningSessionsRepository>(
  (ref) {
    throw UnimplementedError('Must be overridden in main.dart');
  },
);

final learningSessionsProvider =
    StateNotifierProvider<LearningSessionsNotifier, List<LearningSession>>(
      (ref) => LearningSessionsNotifier(
        ref.watch(learningSessionsRepositoryProvider),
      ),
    );

class LearningSessionsNotifier extends StateNotifier<List<LearningSession>> {
  final LearningSessionsRepository _repo;

  LearningSessionsNotifier(this._repo) : super([]) {
    _load();
  }

  void _load() {
    state = _repo.getAll();
  }

  Future<void> startSession({
    String? itemId,
    required String type,
    required int durationMinutes,
    String? notes,
  }) async {
    final session = LearningSession(
      itemId: itemId,
      type: type,
      durationMinutes: durationMinutes,
      startTime: DateTime.now(),
      notes: notes,
    );
    await _repo.add(session);
    _load();
  }

  Future<void> completeSession(String sessionId) async {
    final session = _repo.getById(sessionId);
    if (session != null) {
      await _repo.update(
        session.copyWith(completed: true, endTime: DateTime.now()),
      );
      _load();
    }
  }

  Future<void> cancelSession(String sessionId) async {
    await _repo.delete(sessionId);
    _load();
  }

  List<LearningSession> getTodaySessions() {
    return _repo.getTodaySessions();
  }

  int getTodayMinutes() {
    return _repo.getTodayMinutes();
  }

  List<LearningSession> getByDateRange(DateTime start, DateTime end) {
    return _repo.getByDateRange(start, end);
  }

  Map<DateTime, int> getWeeklyMinutes() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 6));
    final sessions = _repo.getByDateRange(
      weekStart,
      now.add(const Duration(days: 1)),
    );

    final Map<DateTime, int> weekly = {};
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayOnly = DateTime(day.year, day.month, day.day);
      weekly[dayOnly] = 0;
    }

    for (final session in sessions.where((s) => s.completed)) {
      final dayOnly = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );
      weekly[dayOnly] = (weekly[dayOnly] ?? 0) + session.durationMinutes;
    }

    return weekly;
  }
}

// Quick providers for dashboard
final todayStudyMinutesProvider = Provider<int>((ref) {
  final sessions = ref.watch(learningSessionsProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return sessions
      .where((s) => s.completed && s.startTime.isAfter(today))
      .fold(0, (sum, s) => sum + s.durationMinutes);
});

final todaySessionsCountProvider = Provider<int>((ref) {
  final sessions = ref.watch(learningSessionsProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return sessions
      .where((s) => s.completed && s.startTime.isAfter(today))
      .length;
});

final weeklyStudyMinutesProvider = Provider<Map<String, int>>((ref) {
  final sessions = ref.watch(learningSessionsProvider);
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1));

  final Map<String, int> weekly = {};
  final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  for (int i = 0; i < 7; i++) {
    final day = weekStart.add(Duration(days: i));
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final minutes = sessions
        .where(
          (s) =>
              s.completed &&
              s.startTime.isAfter(dayStart) &&
              s.startTime.isBefore(dayEnd),
        )
        .fold(0, (sum, s) => sum + s.durationMinutes);
    weekly[days[i]] = minutes;
  }

  return weekly;
});

final totalStudyMinutesProvider = Provider<int>((ref) {
  final sessions = ref.watch(learningSessionsProvider);
  return sessions
      .where((s) => s.completed)
      .fold(0, (sum, s) => sum + s.durationMinutes);
});

// ============================================
// AUTO BACKUP PROVIDER
// ============================================

final autoBackupProvider = Provider<void>((ref) async {
  final settings = ref.watch(settingsProvider);
  if (!settings.autoBackupEnabled) return;

  final lastBackup = settings.lastBackupDate;
  final now = DateTime.now();
  final daysSinceBackup = lastBackup != null
      ? now.difference(lastBackup).inDays
      : settings.autoBackupFrequency + 1;

  if (daysSinceBackup >= settings.autoBackupFrequency) {
    try {
      final exportService = ref.read(dataExportServiceProvider);
      final filePath = await exportService.exportToFile();
      debugPrint('Auto backup completed: $filePath');

      await ref.read(settingsProvider.notifier).updateLastBackupDate(now);
    } catch (e) {
      debugPrint('Auto backup failed: $e');
    }
  }
});
