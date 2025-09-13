import 'package:hive/hive.dart';

class HiveService {
  static const String _videoBoxName = 'videoBox';
  static const String _likesBoxName = 'likesBox';
  static const String _viewsBoxName = 'viewsBox';

  /// Ensure all boxes are open
  static Future<void> init() async {
    await Hive.openBox<String>(_videoBoxName);
    await Hive.openBox<int>(_likesBoxName);
    await Hive.openBox<int>(_viewsBoxName);
  }

  // ---- Video management ----
  Future<List<String>> getAllVideos() async {
    final box = Hive.box<String>(_videoBoxName);
    return box.values.toList();
  }

  Future<void> addVideo(String path) async {
    final box = Hive.box<String>(_videoBoxName);
    await box.add(path);
  }

  // ---- Likes ----
  int getLikes(String videoKey) {
    final box = Hive.box<int>(_likesBoxName);
    return box.get(videoKey, defaultValue: 0)!;
  }

  Future<void> toggleLike(String videoKey) async {
    final box = Hive.box<int>(_likesBoxName);
    final current = box.get(videoKey, defaultValue: 0) ?? 0;
    await box.put(videoKey, current == 0 ? 1 : 0);
  }

  // ---- Views ----
  int getViews(String videoKey) {
    final box = Hive.box<int>(_viewsBoxName);
    return box.get(videoKey, defaultValue: 0)!;
  }

  Future<void> incrementViews(String videoKey) async {
    final box = Hive.box<int>(_viewsBoxName);
    final current = box.get(videoKey, defaultValue: 0) ?? 0;
    await box.put(videoKey, current + 1);
  }
}
