import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Renders the first frame of a network video (paused at position zero) so it
/// can be used as a static background while editing a reel.
class VideoFirstFrameWidget extends StatefulWidget {
  final String videoUrl;
  const VideoFirstFrameWidget({super.key, required this.videoUrl});

  @override
  State<VideoFirstFrameWidget> createState() => _ReelVideoFirstFrameWidgetState();
}

class _ReelVideoFirstFrameWidgetState extends State<VideoFirstFrameWidget> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    try {
      await _controller!.initialize();
      await _controller!.seekTo(Duration.zero);
      if (mounted) {
        setState(() => _initialized = true);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _controller == null) {
      return const SizedBox.shrink();
    }
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: _controller!.value.size.width,
        height: _controller!.value.size.height,
        child: VideoPlayer(_controller!),
      ),
    );
  }
}
