import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  final String videoPath;
  final String username;
  final String caption;
  final int likes;
  final int comments;
  final int shares;

  const VideoItem({
    super.key,
    required this.videoPath,
    this.username = "@Pet.life",
    this.caption = " Paws, purrs, and wagging tails — life is cuter with furry little angels around 🐶🐱💕",
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  bool isLiked = false;
  final List<String> _comments = []; // ✅ store comments

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ✅ Comment hoverboard (bottom sheet)
  void _openComments() {
    TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // makes it full-screen
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Column(
              children: [
                // ✅ Drag handle
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // ✅ Comment List
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                        title: Text(
                          _comments[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),

                // ✅ Input field
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 12,
                    right: 12,
                    top: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Add a comment...",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.white12,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          if (commentController.text.trim().isNotEmpty) {
                            setState(() {
                              _comments.add(commentController.text.trim());
                            });
                            Navigator.pop(context); // close sheet
                            _openComments(); // reopen updated
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: _controller.value.isInitialized
          ? Stack(
              alignment: Alignment.center,
              children: [
                // ✅ Centered Video
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),

                // ✅ Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),

                // ✅ Right-side controls
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ❤️ Like
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 32,
                        ),
                      ),
                      Text(
                        "${widget.likes + (isLiked ? 1 : 0)}",
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                      // 💬 Comments
                      IconButton(
                        onPressed: _openComments,
                        icon: const Icon(Icons.comment,
                            color: Colors.white, size: 32),
                      ),
                      Text(
                        "${_comments.length + widget.comments}",
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                      // 🔄 Share
                      IconButton(
                        onPressed: () {
                          debugPrint("Share pressed");
                        },
                        icon: const Icon(Icons.share,
                            color: Colors.white, size: 32),
                      ),
                      Text(
                        "${widget.shares}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // ✅ Bottom info
                Positioned(
                  left: 16,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.caption,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
