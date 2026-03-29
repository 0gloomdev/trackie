import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pdfx/pdfx.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shadcn_widgets.dart';
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

  Color _getTypeColor(String type) {
    switch (type) {
      case 'pdf':
        return Colors.red;
      case 'video':
        return AppColors.shadcnSecondary;
      case 'audio':
        return Colors.orange;
      default:
        return AppColors.shadcnPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(learningItemsProvider);
    final item = items.firstWhere(
      (i) => i.id == widget.itemId,
      orElse: () => throw Exception('No encontrado'),
    );
    final color = _getTypeColor(item.type);

    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      appBar: AppBar(
        backgroundColor: AppColors.shadcnBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          if (item.type == 'pdf' && _totalPages > 0)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: _buildViewer(item, color),
    );
  }

  Widget _buildViewer(LearningItem item, Color color) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: color),
            const SizedBox(height: 16),
            Text(
              'Cargando...',
              style: TextStyle(color: Colors.white.withAlpha(179)),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, size: 40, color: Colors.red),
            ),
            const SizedBox(height: 24),
            const Text(
              'Error al cargar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(128),
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn();
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
        errorBuilder: (_, error) => Center(
          child: Text('Error: $error', style: TextStyle(color: Colors.red)),
        ),
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

    return Chewie(controller: _chewieController!);
  }

  Widget _buildAudioPlayer(Color color) {
    if (_audioPlayer == null) {
      return Center(
        child: Text(
          'No se pudo cargar el audio',
          style: TextStyle(color: color),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.audiotrack, size: 56, color: color),
          ),
          const SizedBox(height: 32),
          StreamBuilder<Duration>(
            stream: _audioPlayer!.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              return Column(
                children: [
                  Slider(
                    value: position.inSeconds.toDouble(),
                    min: 0,
                    max: _audioPlayer!.duration?.inSeconds.toDouble() ?? 0,
                    onChanged: (value) {
                      _audioPlayer!.seek(Duration(seconds: value.round()));
                    },
                    activeColor: color,
                    inactiveColor: Colors.white.withAlpha(51),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(position),
                          style: TextStyle(color: Colors.white.withAlpha(179)),
                        ),
                        Text(
                          _formatDuration(
                            _audioPlayer!.duration ?? Duration.zero,
                          ),
                          style: TextStyle(color: Colors.white.withAlpha(179)),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.replay_10, color: Colors.white, size: 32),
                onPressed: () {
                  final newPosition =
                      _audioPlayer!.position - const Duration(seconds: 10);
                  _audioPlayer!.seek(newPosition);
                },
              ),
              const SizedBox(width: 16),
              StreamBuilder<PlayerState>(
                stream: _audioPlayer!.playerStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  return GestureDetector(
                    onTap: () =>
                        playing ? _audioPlayer!.pause() : _audioPlayer!.play(),
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        playing ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.forward_10, color: Colors.white, size: 32),
                onPressed: () {
                  final newPosition =
                      _audioPlayer!.position + const Duration(seconds: 10);
                  _audioPlayer!.seek(newPosition);
                },
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildBookViewer(LearningItem item, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 140,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.menu_book, size: 48, color: color),
          ),
          const SizedBox(height: 24),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (item.url != null)
            ShadcnButton(
              onPressed: () => launchUrl(Uri.parse(item.url!)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.open_in_new, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Abrir en navegador',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebViewer(LearningItem item, Color color) {
    if (item.url == null) {
      return Center(
        child: Text('No hay URL para mostrar', style: TextStyle(color: color)),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.language, size: 40, color: color),
          ),
          const SizedBox(height: 24),
          const Text(
            'Contenido web',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ShadcnButton(
            onPressed: () => launchUrl(Uri.parse(item.url!)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.open_in_new, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Abrir en navegador',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
