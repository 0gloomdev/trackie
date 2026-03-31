import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/url_metadata_service.dart';
import '../../../core/utils/translations.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final LearningItem? item;
  const EditorScreen({super.key, this.item});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;
  late TextEditingController _notesController;

  late String _selectedType;
  late String _selectedStatus;
  late int _progress;
  late List<String> _tags;
  final _tagController = TextEditingController();

  bool _isLoadingMetadata = false;
  String? _urlError;
  UrlMetadata? _fetchedMetadata;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = TextEditingController(text: item?.title ?? '');
    _descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
    _urlController = TextEditingController(text: item?.url ?? '');
    _notesController = TextEditingController(text: item?.notes ?? '');
    _selectedType = item?.type ?? 'course';
    _selectedStatus = item?.status ?? 'pending';
    _progress = item?.progress ?? 0;
    _tags = List.from(item?.tags ?? []);
    _urlController.addListener(_onUrlChanged);
  }

  void _onUrlChanged() {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _urlError = null;
        _fetchedMetadata = null;
      });
      return;
    }
    if (!_isValidUrl(url)) {
      setState(() {
        _urlError = 'Invalid URL';
        _fetchedMetadata = null;
      });
      return;
    }
    setState(() {
      _urlError = null;
    });
    _fetchMetadata(url);
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  Future<void> _fetchMetadata(String url) async {
    if (_isLoadingMetadata) return;
    setState(() => _isLoadingMetadata = true);
    try {
      final metadata = await UrlMetadataService.fetchMetadata(url);
      if (mounted) {
        setState(() {
          _fetchedMetadata = metadata;
          _isLoadingMetadata = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingMetadata = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final url = _urlController.text.trim();
    final now = DateTime.now();
    final item = LearningItem(
      id: widget.item?.id,
      title: _titleController.text.trim(),
      type: _selectedType,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      url: url.isEmpty ? null : url,
      urlFavicon: _fetchedMetadata?.favicon,
      urlThumbnail: _fetchedMetadata?.imageUrl,
      progress: _progress,
      status: _selectedStatus,
      tags: _tags,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      isFavorite: widget.item?.isFavorite ?? false,
      isPinned: widget.item?.isPinned ?? false,
      createdAt: widget.item?.createdAt ?? now,
      updatedAt: now,
    );
    if (_isEditing) {
      ref.read(learningItemsProvider.notifier).update(item);
    } else {
      ref.read(learningItemsProvider.notifier).add(item);
    }
    HapticFeedback.lightImpact();
    Navigator.pop(context);
  }

  void _addTag() {
    final tag = _tagController.text.trim().toLowerCase();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final t = Translations(settings.locale);
    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(
              isEditing: _isEditing,
              onSave: _save,
              onClose: () => Navigator.pop(context),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _SectionLabel(label: 'Title'),
                    const SizedBox(height: 8),
                    ShadcnInput(
                      controller: _titleController,
                      hintText: 'Nombre del contenido',
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel(label: 'Tipo de Contenido'),
                    const SizedBox(height: 12),
                    _TypeSelector(
                      selectedType: _selectedType,
                      onChanged: (type) => setState(() => _selectedType = type),
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel(label: 'Description'),
                    const SizedBox(height: 8),
                    ShadcnInput(
                      controller: _descriptionController,
                      hintText: 'Optional description...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel(label: 'URL'),
                    const SizedBox(height: 8),
                    ShadcnInput(
                      controller: _urlController,
                      hintText: 'https://...',
                      prefixIcon: const Icon(Icons.link, color: Colors.white54),
                      suffixIcon: _isLoadingMetadata
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : _fetchedMetadata != null
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                    ),
                    if (_urlError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _urlError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                    if (_fetchedMetadata != null) ...[
                      const SizedBox(height: 8),
                      _MetadataPreview(metadata: _fetchedMetadata!),
                    ],
                    const SizedBox(height: 24),
                    _SectionLabel(label: 'Estado'),
                    const SizedBox(height: 12),
                    _StatusSelector(
                      selectedStatus: _selectedStatus,
                      onChanged: (status) => setState(() {
                        _selectedStatus = status;
                        if (status == 'completed') _progress = 100;
                        if (status == 'pending') _progress = 0;
                      }),
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel(label: 'Progreso ($_progress%)'),
                    const SizedBox(height: 12),
                    _ProgressSlider(
                      progress: _progress,
                      onChanged: (value) => setState(() => _progress = value),
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel(label: 'Etiquetas'),
                    const SizedBox(height: 12),
                    _TagInput(
                      controller: _tagController,
                      tags: _tags,
                      onAdd: _addTag,
                      onRemove: _removeTag,
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel(label: t.notes),
                    const SizedBox(height: 8),
                    ShadcnInput(
                      controller: _notesController,
                      hintText: 'Notas adicionales...',
                      maxLines: 5,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onSave;
  final VoidCallback onClose;

  const _AppBar({
    required this.isEditing,
    required this.onSave,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
          Text(
            isEditing ? 'Edit' : 'New Item',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: onSave,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: Colors.white.withAlpha(128),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;

  const _TypeSelector({required this.selectedType, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final types = AppConstants.contentTypes.take(6).toList();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: types.map((type) {
        final isSelected = selectedType == type.id;
        final color = Color(type.color);
        return GestureDetector(
          onTap: () => onChanged(type.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withAlpha(26)
                  : Colors.white.withAlpha(13),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color.withAlpha(77) : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getTypeIcon(type.icon),
                  size: 16,
                  color: isSelected ? color : Colors.white54,
                ),
                const SizedBox(width: 8),
                Text(
                  type.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? color : Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getTypeIcon(String icon) {
    switch (icon) {
      case 'play_circle':
        return Icons.play_circle;
      case 'videocam':
        return Icons.videocam;
      case 'menu_book':
        return Icons.menu_book;
      case 'picture_as_pdf':
        return Icons.picture_as_pdf;
      case 'article':
        return Icons.article;
      default:
        return Icons.link;
    }
  }
}

class _StatusSelector extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onChanged;

  const _StatusSelector({
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = AppConstants.statuses;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: statuses.map((status) {
        final isSelected = selectedStatus == status.id;
        final color = Color(status.color);
        return GestureDetector(
          onTap: () => onChanged(status.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withAlpha(26)
                  : Colors.white.withAlpha(13),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color.withAlpha(77) : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? color : Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ProgressSlider extends StatelessWidget {
  final int progress;
  final ValueChanged<int> onChanged;

  const _ProgressSlider({required this.progress, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ShadcnProgress(value: progress / 100, color: _getProgressColor()),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: _getProgressColor(),
              inactiveTrackColor: Colors.white.withAlpha(26),
              thumbColor: _getProgressColor(),
              overlayColor: _getProgressColor().withAlpha(51),
            ),
            child: Slider(
              value: progress.toDouble(),
              min: 0,
              max: 100,
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor() {
    switch (_getStatusFromProgress()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusFromProgress() {
    if (progress >= 100) return 'completed';
    if (progress > 0) return 'in_progress';
    return 'pending';
  }
}

class _TagInput extends StatelessWidget {
  final TextEditingController controller;
  final List<String> tags;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  const _TagInput({
    required this.controller,
    required this.tags,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ShadcnInput(
                controller: controller,
                hintText: 'Agregar etiqueta...',
                prefixIcon: const Icon(
                  Icons.local_offer_outlined,
                  color: Colors.white54,
                  size: 20,
                ),
                onChanged: (_) {},
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.shadcnPrimary.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add,
                  color: AppColors.shadcnPrimary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map((tag) => _TagChip(tag: tag, onRemove: () => onRemove(tag)))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  final VoidCallback onRemove;

  const _TagChip({required this.tag, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.shadcnPrimary.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$tag',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.shadcnPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: AppColors.shadcnPrimary),
          ),
        ],
      ),
    );
  }
}

class _MetadataPreview extends StatelessWidget {
  final UrlMetadata metadata;

  const _MetadataPreview({required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(26)),
      ),
      child: Row(
        children: [
          if (metadata.favicon != null) ...[
            Image.network(
              metadata.favicon!,
              width: 16,
              height: 16,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.language, size: 16, color: Colors.white54),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              metadata.title ?? 'Found title',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
