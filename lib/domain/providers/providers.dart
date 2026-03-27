import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';

final learningRepositoryProvider = Provider<LearningRepository>(
  (ref) => LearningRepository(),
);
final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(),
);
final tagRepositoryProvider = Provider<TagRepository>((ref) => TagRepository());
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(),
);

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

  Future<void> toggleViewMode() async {
    await update(
      state.copyWith(
        defaultView: state.defaultView == 'grid' ? 'list' : 'grid',
      ),
    );
  }

  Future<void> completeOnboarding() async {
    await update(state.copyWith(showOnboarding: false));
  }
}

final learningItemsProvider =
    StateNotifierProvider<LearningItemsNotifier, List<LearningItem>>(
      (ref) => LearningItemsNotifier(ref.watch(learningRepositoryProvider)),
    );

class LearningItemsNotifier extends StateNotifier<List<LearningItem>> {
  final LearningRepository _repo;
  LearningItemsNotifier(this._repo) : super([]) {
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
    await _repo.update(i);
    _load();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _load();
  }

  Future<void> toggleFavorite(String id) async {
    final i = _repo.getById(id);
    if (i != null) {
      await _repo.update(i.copyWith(isFavorite: !i.isFavorite));
      _load();
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
  if (f.type != null)
    filtered = filtered.where((i) => i.type == f.type).toList();
  if (f.status != null)
    filtered = filtered.where((i) => i.status == f.status).toList();
  if (f.categoryId != null)
    filtered = filtered.where((i) => i.categoryId == f.categoryId).toList();
  if (f.showFavoritesOnly)
    filtered = filtered.where((i) => i.isFavorite).toList();
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
