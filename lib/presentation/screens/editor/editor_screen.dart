import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_glass.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/constants/app_constants.dart';
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
  String? _selectedCategoryId;
  final _tagController = TextEditingController();

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
    _selectedCategoryId = item?.categoryId;
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

    final now = DateTime.now();
    final item = LearningItem(
      id: widget.item?.id,
      title: _titleController.text.trim(),
      type: _selectedType,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      url: _urlController.text.trim().isEmpty
          ? null
          : _urlController.text.trim(),
      progress: _progress,
      status: _selectedStatus,
      categoryId: _selectedCategoryId,
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
    final categories = ref.watch(categoriesProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: GlassAppBar(
        title: _isEditing ? 'Editar' : 'Nuevo Elemento',
        leading: IconButton(
          icon: Icon(Icons.close, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          GestureDetector(
            onTap: _save,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary, cs.primaryContainer],
                ),
                borderRadius: BorderRadius.circular(AppGlass.radiusPill),
              ),
              child: Text(
                'Guardar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: cs.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _SectionLabel(label: 'TÍTULO'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              style: TextStyle(color: cs.onSurface),
              decoration: AppGlass.inputDecoration(
                hintText: 'Nombre del contenido',
                prefixIcon: Icons.title,
              ),
              validator: (v) => v?.trim().isEmpty == true ? 'Requerido' : null,
            ),

            const SizedBox(height: 24),

            _SectionLabel(label: 'TIPO DE CONTENIDO'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppConstants.contentTypes.take(6).map((type) {
                final typeColor = Color(type.color);
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = type.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedType == type.id
                          ? typeColor.withValues(alpha: 0.15)
                          : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppGlass.radiusPill),
                      border: Border.all(
                        color: _selectedType == type.id
                            ? typeColor.withValues(alpha: 0.3)
                            : cs.outlineVariant,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getTypeIcon(type.icon),
                          size: 16,
                          color: _selectedType == type.id
                              ? typeColor
                              : cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          type.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: _selectedType == type.id
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _selectedType == type.id
                                ? typeColor
                                : cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            _SectionLabel(label: 'DESCRIPCIÓN'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              style: TextStyle(color: cs.onSurface),
              decoration: AppGlass.inputDecoration(
                hintText: 'Descripción opcional...',
              ),
            ),

            const SizedBox(height: 24),

            _SectionLabel(label: 'URL'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              style: TextStyle(color: cs.onSurface),
              decoration: AppGlass.inputDecoration(
                hintText: 'https://...',
                prefixIcon: Icons.link,
              ),
            ),

            const SizedBox(height: 24),

            _SectionLabel(label: 'ESTADO'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppConstants.statuses.map((status) {
                final statusColor = Color(status.color);
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedStatus = status.id;
                    if (status.id == 'completed') _progress = 100;
                    if (status.id == 'pending') _progress = 0;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedStatus == status.id
                          ? statusColor.withValues(alpha: 0.15)
                          : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppGlass.radiusPill),
                      border: Border.all(
                        color: _selectedStatus == status.id
                            ? statusColor.withValues(alpha: 0.3)
                            : cs.outlineVariant,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          status.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: _selectedStatus == status.id
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _selectedStatus == status.id
                                ? statusColor
                                : cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            _SectionLabel(label: 'PROGRESO ($_progress%)'),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                children: [
                  GlassProgressBar(
                    value: _progress / 100,
                    color: AppHelpers.getStatusColor(_selectedStatus),
                    height: 6,
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: _progress.toDouble(),
                    min: 0,
                    max: 100,
                    onChanged: (v) => setState(() => _progress = v.round()),
                    activeColor: cs.primary,
                    inactiveColor: cs.primary.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _SectionLabel(label: 'ETIQUETAS'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    style: TextStyle(color: cs.onSurface),
                    decoration: AppGlass.inputDecoration(
                      hintText: 'Agregar etiqueta...',
                      prefixIcon: Icons.local_offer_outlined,
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _addTag,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(
                        AppGlass.radiusMedium,
                      ),
                    ),
                    child: Icon(Icons.add, color: cs.primary, size: 20),
                  ),
                ),
              ],
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags
                    .map(
                      (tag) => GestureDetector(
                        onTap: () => _removeTag(tag),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              AppGlass.radiusPill,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '#$tag',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: cs.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.close, size: 14, color: cs.primary),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],

            const SizedBox(height: 24),

            _SectionLabel(label: 'NOTAS'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 5,
              style: TextStyle(color: cs.onSurface),
              decoration: AppGlass.inputDecoration(
                hintText: 'Notas adicionales...',
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String iconName) {
    switch (iconName) {
      case 'play_circle':
        return Icons.play_circle;
      case 'menu_book':
        return Icons.menu_book;
      case 'picture_as_pdf':
        return Icons.picture_as_pdf;
      case 'book':
        return Icons.book;
      case 'video_library':
        return Icons.video_library;
      case 'headphones':
        return Icons.headphones;
      case 'article':
        return Icons.article;
      case 'podcasts':
        return Icons.podcasts;
      case 'note':
        return Icons.note;
      case 'link':
        return Icons.link;
      default:
        return Icons.library_books;
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}
