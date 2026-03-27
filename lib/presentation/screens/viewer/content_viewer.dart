import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfx/pdfx.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/models.dart';
import '../../../domain/providers/providers.dart';

class ContentViewerScreen extends ConsumerStatefulWidget {
  final String itemId;

  const ContentViewerScreen({super.key, required this.itemId});

  @override
  ConsumerState<ContentViewerScreen> createState() =>
      _ContentViewerScreenState();
}

class _ContentViewerScreenState extends ConsumerState<ContentViewerScreen> {
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = true;
  PdfController? _pdfController;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  AudioPlayer? _audioPlayer;
  String? _error;
  PdfDocument? _pdfDocument;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final items = ref.read(learningItemsProvider);
    final item = items.firstWhere(
      (i) => i.id == widget.itemId,
      orElse: () => throw Exception('Item no encontrado'),
    );

    if (item.url == null && item.localPath == null) {
      setState(() {
        _isLoading = false;
        _error = 'No hay contenido para visualizar';
      });
      return;
    }

    try {
      setState(() => _isLoading = true);

      switch (item.type) {
        case 'pdf':
          if (item.localPath != null) {
            _pdfDocument = await PdfDocument.openFile(item.localPath!);
          }
          _totalPages = _pdfDocument?.pagesCount ?? 0;
          _pdfController = PdfController(document: Future.value(_pdfDocument));
          break;
        case 'video':
          if (item.localPath != null) {
            _videoController = VideoPlayerController.file(
              File(item.localPath!),
            );
          } else if (item.url != null) {
            _videoController = VideoPlayerController.networkUrl(
              Uri.parse(item.url!),
            );
          }
          await _videoController!.initialize();
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: true,
          );
          break;
        case 'audio':
          _audioPlayer = AudioPlayer();
          if (item.localPath != null) {
            await _audioPlayer!.setFilePath(item.localPath!);
          } else if (item.url != null) {
            await _audioPlayer!.setUrl(item.url!);
          }
          break;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    _videoController?.dispose();
    _chewieController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(learningItemsProvider);
    final item = items.firstWhere(
      (i) => i.id == widget.itemId,
      orElse: () => throw Exception('No encontrado'),
    );
    final typeColor = _getTypeColor(item.type);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (item.type == 'pdf' && _totalPages > 0)
            Center(
              child: Text(
                '$_currentPage/$_totalPages',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: _buildViewer(item, typeColor),
    );
  }

  Widget _buildViewer(LearningItem item, Color color) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: color));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              'Error al cargar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    switch (item.type) {
      case 'pdf':
        return _buildPdfViewer(color);
      case 'video':
        return _buildVideoViewer(color);
      case 'audio':
        return _buildAudioPlayer(color);
      case 'epub':
      case 'book':
        return _buildBookViewer(item, color);
      default:
        return _buildWebViewer(item, color);
    }
  }

  Widget _buildPdfViewer(Color color) {
    if (_pdfController == null) {
      return Center(
        child: Text('No se pudo cargar el PDF', style: TextStyle(color: color)),
      );
    }

    return PdfView(
      controller: _pdfController!,
      onPageChanged: (page) => setState(() => _currentPage = page),
      builders: PdfViewBuilders<DefaultBuilderOptions>(
        options: const DefaultBuilderOptions(),
        documentLoaderBuilder: (_) =>
            Center(child: CircularProgressIndicator(color: color)),
        pageLoaderBuilder: (_) =>
            Center(child: CircularProgressIndicator(color: color)),
        errorBuilder: (_, error) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildVideoViewer(Color color) {
    if (_chewieController == null) {
      return Center(
        child: Text(
          'No se pudo cargar el video',
          style: TextStyle(color: color),
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      ),
    );
  }

  Widget _buildAudioPlayer(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.2),
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 30),
              ],
            ),
            child: Icon(Icons.headphones, size: 70, color: color),
          ),
          const SizedBox(height: 40),
          StreamBuilder<Duration>(
            stream: _audioPlayer!.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _audioPlayer!.duration ?? Duration.zero;
              return Column(
                children: [
                  Slider(
                    value: position.inSeconds.toDouble(),
                    max: duration.inSeconds.toDouble().clamp(
                      1,
                      double.infinity,
                    ),
                    onChanged: (v) =>
                        _audioPlayer!.seek(Duration(seconds: v.toInt())),
                    activeColor: color,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position)),
                        Text(_formatDuration(duration)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                iconSize: 40,
                onPressed: () => _audioPlayer!.seek(
                  Duration(seconds: _audioPlayer!.position.inSeconds - 10),
                ),
              ),
              const SizedBox(width: 20),
              StreamBuilder<PlayerState>(
                stream: _audioPlayer!.playerStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  return GestureDetector(
                    onTap: () =>
                        playing ? _audioPlayer!.pause() : _audioPlayer!.play(),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Icon(
                        playing ? Icons.pause : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.forward_10),
                iconSize: 40,
                onPressed: () => _audioPlayer!.seek(
                  Duration(seconds: _audioPlayer!.position.inSeconds + 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookViewer(LearningItem item, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 20),
              ],
            ),
            child: Icon(Icons.book, size: 60, color: color),
          ),
          const SizedBox(height: 24),
          Text(item.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Lector de libros - Próximamente',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewer(LearningItem item, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.link, size: 60, color: color),
          ),
          const SizedBox(height: 24),
          Text(item.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          if (item.url != null)
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new),
              label: const Text('Abrir en navegador'),
            ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    final t = AppConstants.contentTypes.firstWhere(
      (t) => t.id == type,
      orElse: () => AppConstants.contentTypes.first,
    );
    return Color(t.color);
  }

  String _formatDuration(Duration d) {
    final mins = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }
}
