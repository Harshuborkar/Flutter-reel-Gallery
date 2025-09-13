# Flutter-reel-Gallery
# 🎥 Reels Style Gallery App

A Flutter app inspired by Instagram Reels / TikTok — built with **Riverpod**, **Hive**, and **Video Player**.  
Users can scroll through short videos, like them, view counts, and open a comment overlay.

---

## 🚀 Features
- Vertical scroll feed of videos (PageView).
- Preloaded videos + persistent storage via Hive.
- Video playback using `video_player` package.
- TikTok-style UI with:
  - Like ❤️, Views 👁, and Profile Avatar 👤.
  - Caption and username at the bottom.
- Dynamic comments with a bottom sheet (hoverboard style).
- Black background + gradient overlays for better visuals.

---

## 📂 Project Structure
lib/
├── main.dart
├── screen/
│ └── home.dart # Home screen with vertical video feed
├── video_item.dart # Widget to render video with overlay controls
├── providers.dart # Riverpod state (videos, likes, comments)
├── hive_service.dart # Hive storage manager


---

## 🛠 Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  video_player: ^2.8.2
  logger: ^2.0.2



🔮 To-Do
 Add Firebase backend for real-time likes/comments.

 Support picking videos from gallery.

 Compress large videos before adding.

 User authentication
