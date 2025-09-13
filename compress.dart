import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_compress/video_compress.dart';

class CompressedVideoPlayer extends StatefulWidget {
  final String filePath; // original video path
  const CompressedVideoPlayer({super.key, required this.filePath});

  @override
  State<CompressedVideoPlayer> createState() => _CompressedVideoPlayerState();
}

class _CompressedVideoPlayerState extends State<CompressedVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _compressAndLoad();
  }

  Future<void> _compressAndLoad() async {
    final compressed = await VideoCompress.compressVideo(
      widget.filePath,
      quality: VideoQuality.MediumQuality, // You can use Low/High as well
      deleteOrigin: false, // keep original file
    );

    if (compressed != null && compressed.path != null) {
      _controller = VideoPlayerController.file(compressed.file!)
        ..initialize().then((_) {
          setState(() {
            _isLoading = false;
          });
          _controller!.play();
          _controller!.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    VideoCompress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller!.value.size.width,
        height: _controller!.value.size.height,
        child: VideoPlayer(_controller!),
      ),
    );
  }
}
