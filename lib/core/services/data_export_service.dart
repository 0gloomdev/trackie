import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../data/repositories/repositories.dart';

class DataExportService {
  final LearningRepository learningRepo;
  final CategoryRepository categoryRepo;
  final TagRepository tagRepo;
  final SettingsRepository settingsRepo;
  final AchievementsRepository achievementsRepo;
  final ProfileRepository profileRepo;

  DataExportService({
    required this.learningRepo,
    required this.categoryRepo,
    required this.tagRepo,
    required this.settingsRepo,
    required this.achievementsRepo,
    required this.profileRepo,
  });

  Map<String, dynamic> exportAllData() {
    return {
      'version': '1.0.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'items': learningRepo.exportToJson(),
      'categories': categoryRepo.exportToJson(),
      'tags': tagRepo.exportToJson(),
      'settings': settingsRepo.exportToJson(),
      'achievements': achievementsRepo.exportToJson(),
      'profile': profileRepo.exportToJson(),
    };
  }

  String exportToJsonString() {
    final data = exportAllData();
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<String> exportToFile() async {
    final jsonString = exportToJsonString();
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/aura_learning_backup_$timestamp.json');
    await file.writeAsString(jsonString);
    return file.path;
  }

  Future<void> importFromJson(Map<String, dynamic> data) async {
    if (data['items'] != null) {
      await learningRepo.importFromJson(List<dynamic>.from(data['items']));
    }
    if (data['categories'] != null) {
      await categoryRepo.importFromJson(List<dynamic>.from(data['categories']));
    }
    if (data['tags'] != null) {
      await tagRepo.importFromJson(List<dynamic>.from(data['tags']));
    }
    if (data['settings'] != null) {
      await settingsRepo.importFromJson(
        Map<String, dynamic>.from(data['settings']),
      );
    }
    if (data['achievements'] != null) {
      await achievementsRepo.importFromJson(
        List<dynamic>.from(data['achievements']),
      );
    }
    if (data['profile'] != null) {
      await profileRepo.importFromJson(
        Map<String, dynamic>.from(data['profile']),
      );
    }
  }

  Future<void> importFromJsonString(String jsonString) async {
    final data = json.decode(jsonString) as Map<String, dynamic>;
    await importFromJson(data);
  }

  Future<void> importFromFile(String filePath) async {
    final file = File(filePath);
    final jsonString = await file.readAsString();
    await importFromJsonString(jsonString);
  }

  Future<void> clearAllData() async {
    await learningRepo.clearAll();
  }

  String exportItemsToCsv() {
    final items = learningRepo.getAll();
    final buffer = StringBuffer();

    buffer.writeln('Title,Type,Status,Progress,URL,Created,Updated');

    for (final item in items) {
      buffer.writeln(
        '"${_escapeCsv(item.title)}",'
        '"${item.type}",'
        '"${item.status}",'
        '${item.progress},'
        '"${item.url ?? ''}",'
        '"${item.createdAt.toIso8601String()}",'
        '"${item.updatedAt.toIso8601String()}"',
      );
    }

    return buffer.toString();
  }

  String _escapeCsv(String value) {
    return value.replaceAll('"', '""');
  }

  Future<String> exportItemsToCsvFile() async {
    final csv = exportItemsToCsv();
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/aura_learning_items_$timestamp.csv');
    await file.writeAsString(csv);
    return file.path;
  }

  Future<String> exportToMarkdown() async {
    final items = learningRepo.getAll();
    final profile = profileRepo.get();
    final buffer = StringBuffer();

    buffer.writeln('# ${profile.nombre} - Learning Progress');
    buffer.writeln();
    buffer.writeln('## Profile');
    buffer.writeln('- Level: ${profile.nivel}');
    buffer.writeln('- XP: ${profile.xp}');
    buffer.writeln('- Streak: ${profile.streak} days');
    buffer.writeln();
    buffer.writeln('## Learning Items (${items.length})');
    buffer.writeln();

    final byStatus = <String, List<dynamic>>{};
    for (final item in items) {
      byStatus.putIfAbsent(item.status, () => []).add(item);
    }

    for (final status in ['completed', 'in_progress', 'pending']) {
      final statusItems = byStatus[status];
      if (statusItems != null) {
        buffer.writeln('### ${status.toUpperCase()} (${statusItems.length})');
        buffer.writeln();
        for (final item in statusItems) {
          buffer.writeln('- ${item.title} (${item.progress}%)');
        }
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  Future<String> exportToMarkdownFile() async {
    final markdown = await exportToMarkdown();
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/aura_learning_progress_$timestamp.md');
    await file.writeAsString(markdown);
    return file.path;
  }
}
