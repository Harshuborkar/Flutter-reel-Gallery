import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hive_service.dart';

// Video state
class VideoState {
  final List<String> videos;
  const VideoState(this.videos);
}

// Video notifier
class VideoNotifier extends Notifier<VideoState> {
  static const List<String> initialAssets = [
    'assets/videos/video1.mp4',
    'assets/videos/video2.mp4',
    'assets/videos/video3.mp4',
    'assets/videos/video4.mp4',
  ];

  @override
  VideoState build() {
    return const VideoState([]); // Start empty
  }

  Future<void> loadVideos() async {
    final hiveService = ref.read(hiveServiceProvider);
    final hiveVideos = await hiveService.getAllVideos();

    // Merge assets and Hive, avoid duplicates
    final allVideos = [
      ...initialAssets,
      ...hiveVideos.where((v) => !initialAssets.contains(v)),
    ];

    // Save assets to Hive if not present
    for (final video in initialAssets) {
      if (!hiveVideos.contains(video)) {
        await hiveService.addVideo(video);
      }
    }

    state = VideoState(allVideos);
  }

  Future<void> addVideo(String path) async {
    final hiveService = ref.read(hiveServiceProvider);
    await hiveService.addVideo(path);
    await loadVideos();
  }
}

// Hive service provider
final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

// Video provider
final videoProvider = NotifierProvider<VideoNotifier, VideoState>(
  () => VideoNotifier(),
);
