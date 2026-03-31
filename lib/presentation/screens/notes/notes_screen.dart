import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
import '../../../core/utils/translations.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final t = Translations(settings.locale);
    final notes = ref.watch(notesProvider);

    final filteredNotes = _searchQuery.isEmpty
        ? notes
        : notes
              .where(
                (n) =>
                    n.title.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    n.content.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();

    final pinnedNotes = filteredNotes.where((n) => n.isPinned).toList();
    final unpinnedNotes = filteredNotes.where((n) => !n.isPinned).toList();

    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              title: t.notes,
              subtitle: settings.locale == 'en'
                  ? 'Capture your thoughts'
                  : 'Captura tus pensamientos',
              onAddNote: () => _showNoteEditor(context, null),
            ),
            const SizedBox(height: 24),
            _SearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: filteredNotes.isEmpty
                  ? _EmptyState(onAddNote: () => _showNoteEditor(context, null))
                  : _NotesList(
                      pinnedNotes: pinnedNotes,
                      unpinnedNotes: unpinnedNotes,
                      onEditNote: (note) => _showNoteEditor(context, note),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteEditor(BuildContext context, Note? note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NoteEditorSheet(note: note),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onAddNote;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.onAddNote,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                color: Colors.white,
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withAlpha(179),
                fontWeight: FontWeight.w500,
              ),
            ).animate(delay: 100.ms).fadeIn(duration: 600.ms),
          ],
        ),
        _AddButton(onTap: onAddNote),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.shadcnPrimary, AppColors.shadcnSecondary],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadcnPrimary.withAlpha(77),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8));
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ShadcnInput(
      controller: controller,
      hintText: 'Search notes...',
      prefixIcon: const Icon(Icons.search, color: Colors.white54),
      onChanged: onChanged,
    ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1);
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddNote;

  const _EmptyState({required this.onAddNote});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.shadcnPrimary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.note_alt_outlined,
              size: 40,
              color: AppColors.shadcnPrimary.withAlpha(128),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No notes yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first note to get started',
            style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(128)),
          ),
          const SizedBox(height: 24),
          ShadcnButton(
            onPressed: onAddNote,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Create note', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

class _NotesList extends StatelessWidget {
  final List<Note> pinnedNotes;
  final List<Note> unpinnedNotes;
  final Function(Note) onEditNote;

  const _NotesList({
    required this.pinnedNotes,
    required this.unpinnedNotes,
    required this.onEditNote,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (pinnedNotes.isNotEmpty) ...[
          SliverToBoxAdapter(child: _SectionTitle(title: 'Pinned')),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _NoteCard(
                note: pinnedNotes[index],
                index: index,
                onTap: () => onEditNote(pinnedNotes[index]),
              ),
              childCount: pinnedNotes.length,
            ),
          ),
        ],
        if (unpinnedNotes.isNotEmpty) ...[
          SliverToBoxAdapter(child: _SectionTitle(title: 'All Notes')),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _NoteCard(
                note: unpinnedNotes[index],
                index: index + pinnedNotes.length,
                onTap: () => onEditNote(unpinnedNotes[index]),
              ),
              childCount: unpinnedNotes.length,
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: Colors.white.withAlpha(128),
        ),
      ),
    );
  }
}

class _NoteCard extends ConsumerWidget {
  final Note note;
  final int index;
  final VoidCallback onTap;

  const _NoteCard({
    required this.note,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ShadcnCard(
        padding: const EdgeInsets.all(16),
        hoverEffect: true,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (note.isPinned)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.push_pin,
                      size: 16,
                      color: AppColors.shadcnSecondary,
                    ),
                  ),
                Expanded(
                  child: Text(
                    note.title.isEmpty ? 'Untitled' : note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            if (note.content.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(179),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(note.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withAlpha(102),
                  ),
                ),
                Row(
                  children: [
                    _ActionButton(
                      icon: note.isPinned
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                      onTap: () => ref
                          .read(notesProvider.notifier)
                          .togglePinned(note.id),
                      color: note.isPinned
                          ? AppColors.shadcnSecondary
                          : Colors.white54,
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.delete_outline,
                      onTap: () =>
                          ref.read(notesProvider.notifier).delete(note.id),
                      color: Colors.red.shade400,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.05);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 20, color: color),
    );
  }
}

class _NoteEditorSheet extends ConsumerStatefulWidget {
  final Note? note;

  const _NoteEditorSheet({this.note});

  @override
  ConsumerState<_NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends ConsumerState<_NoteEditorSheet> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _isPinned = widget.note?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.shadcnBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShadcnButton(
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.white.withAlpha(26),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      widget.note == null ? 'New Note' : 'Edit Note',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ShadcnButton(
                      onPressed: _saveNote,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Save', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ShadcnInput(
                  controller: _titleController,
                  hintText: 'Note title',
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x0DFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x33FFFFFF)),
                    ),
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Write your note...',
                        hintStyle: const TextStyle(color: Color(0x80FFFFFF)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      color: _isPinned
                          ? AppColors.shadcnSecondary
                          : Colors.white54,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pin note',
                      style: TextStyle(
                        color: _isPinned
                            ? AppColors.shadcnSecondary
                            : Colors.white,
                      ),
                    ),
                    const Spacer(),
                    ShadcnToggle(
                      value: _isPinned,
                      onChanged: (value) => setState(() => _isPinned = value),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.3);
  }

  void _saveNote() {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (widget.note != null) {
      ref
          .read(notesProvider.notifier)
          .update(
            widget.note!.copyWith(
              title: _titleController.text,
              content: _contentController.text,
              isPinned: _isPinned,
            ),
          );
    } else {
      ref
          .read(notesProvider.notifier)
          .add(
            Note(
              title: _titleController.text,
              content: _contentController.text,
              isPinned: _isPinned,
            ),
          );
    }
    Navigator.pop(context);
  }
}
