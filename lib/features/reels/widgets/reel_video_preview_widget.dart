import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:video_player/video_player.dart';

class ReelVideoPreviewWidget extends StatefulWidget {
  final String videoFile;
  final double? height;
  const ReelVideoPreviewWidget({super.key, required this.videoFile, this.height});

  @override
  State<ReelVideoPreviewWidget> createState() => _ReelVideoPreviewWidgetState();
}

class _ReelVideoPreviewWidgetState extends State<ReelVideoPreviewWidget> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoFile));
    try {
      await _controller!.initialize();
      if (mounted) {
        _chewieController = ChewieController(
          videoPlayerController: _controller!,
          autoInitialize: true,
          aspectRatio: _controller!.value.aspectRatio,
          autoPlay: false,
          looping: false,
        );
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double videoHeight = widget.height ?? 220;

    if (_hasError) {
      return SizedBox(
        height: videoHeight,
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.error_outline, size: 36, color: Theme.of(context).disabledColor),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(
                'video_load_failed'.tr,
                style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
              ),
            ]),
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return SizedBox(
        height: videoHeight,
        child: Shimmer(
          duration: const Duration(seconds: 2),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey.shade700 : Colors.grey.withAlpha(100),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Center(
              child: Icon(Icons.play_circle_fill, size: 40, color: Get.isDarkMode ? Colors.grey : Colors.grey.withAlpha(120), ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: videoHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: Chewie(controller: _chewieController!),
      ),
    );
  }
}
