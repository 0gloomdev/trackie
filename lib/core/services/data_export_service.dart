import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../data/models/models.dart';
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

  // Import from CSV
  Future<void> importItemsFromCsv(String csvContent) async {
    final lines = csvContent.split('\n');
    if (lines.isEmpty) return;

    // Skip header
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final values = _parseCsvLine(line);
      if (values.length < 2) continue;

      // Create item from CSV row
      final item = LearningItem(
        title: values[0],
        type: values.length > 1 ? values[1] : 'course',
        status: values.length > 2 ? values[2] : 'pending',
        progress: values.length > 3 ? int.tryParse(values[3]) ?? 0 : 0,
        url: values.length > 4 ? values[4] : null,
      );

      await learningRepo.add(item);
    }
  }

  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    var current = StringBuffer();
    var inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current.toString().trim());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }
    result.add(current.toString().trim());

    return result;
  }

  Future<void> importFromCsvFile(String filePath) async {
    final file = File(filePath);
    final csvContent = await file.readAsString();
    await importItemsFromCsv(csvContent);
  }

  // Import from URL (for sharing)
  Future<bool> importFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await importFromJsonString(response.body);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
