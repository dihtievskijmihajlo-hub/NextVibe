import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const NextVibeApp());
}

class NextVibeApp extends StatelessWidget {
  const NextVibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NextVibe',
      theme: ThemeData.dark(),
      home: const NextVibeFeedScreen(),
    );
  }
}

class VideoItem {
  final String url;
  final String username;
  final String description;
  final String likes;
  final String comments;

  VideoItem({
    required this.url,
    required this.username,
    required this.description,
    required this.likes,
    required this.comments,
  });
}

class NextVibeFeedScreen extends StatefulWidget {
  const NextVibeFeedScreen({super.key});

  @override
  State<NextVibeFeedScreen> createState() => _NextVibeFeedScreenState();
}

class _NextVibeFeedScreenState extends State<NextVibeFeedScreen> {
  late PageController _pageController;

  final List<VideoItem> videos = [
    VideoItem(
      url:
          'https://commondatastorage.googleapis.com/gtv-videos-library/sample/BigBuckBunny.mp4',
      username: '@nextvibe_official',
      description: 'Welcome to NextVibe 🎬 #nextvibe #videos',
      likes: '245K',
      comments: '3.2K',
    ),
    VideoItem(
      url:
          'https://commondatastorage.googleapis.com/gtv-videos-library/sample/ElephantsDream.mp4',
      username: '@creator_vibes',
      description: 'Amazing content! 🔥 #trending #viral',
      likes: '512K',
      comments: '8.5K',
    ),
    VideoItem(
      url:
          'https://commondatastorage.googleapis.com/gtv-videos-library/sample/ForBiggerBlazes.mp4',
      username: '@video_master',
      description: 'Future of streaming 🚀 #innovation',
      likes: '89K',
      comments: '1.2K',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return NextVibeVideoWidget(video: videos[index]);
        },
      ),
    );
  }
}

class NextVibeVideoWidget extends StatefulWidget {
  final VideoItem video;

  const NextVibeVideoWidget({super.key, required this.video});

  @override
  State<NextVibeVideoWidget> createState() => _NextVibeVideoWidgetState();
}

class _NextVibeVideoWidgetState extends State<NextVibeVideoWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;
  double _playbackSpeed = 1.0;
  bool _showSpeedMenu = false;
  bool _isLiked = false;

  final List<double> _speeds = [0.5, 1.0, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.url),
      httpHeaders: {
        'User-Agent': 'Mozilla/5.0',
      },
    )
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _initialized = true;
          });
          _controller.setLooping(true);
          _controller.play();
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
        debugPrint('Video Error: $error');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setPlaybackSpeed(double speed) {
    if (_initialized) {
      _controller.setPlaybackSpeed(speed);
      setState(() {
        _playbackSpeed = speed;
        _showSpeedMenu = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video Player
        Positioned.fill(
          child: _hasError
              ? Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 50, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load video',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _hasError = false;
                              _initialized = false;
                            });
                            _initializeVideo();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _initialized
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
        ),

        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),
        ),

        // Play/Pause icon
        if (_initialized && !_controller.value.isPlaying)
          Positioned.fill(
            child: Center(
              child: Icon(
                Icons.play_arrow,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),

        // Speed control button
        Positioned(
          right: 15,
          top: 20,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showSpeedMenu = !_showSpeedMenu;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white30),
              ),
              child: Text(
                '${_playbackSpeed}x',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // Speed menu
        if (_showSpeedMenu)
          Positioned(
            right: 15,
            top: 70,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _speeds.map((speed) {
                  final isSelected = speed == _playbackSpeed;
                  return GestureDetector(
                    onTap: () => _setPlaybackSpeed(speed),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.white10 : Colors.transparent,
                        border: isSelected
                            ? Border(
                                left: BorderSide(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            ),
                          if (isSelected) const SizedBox(width: 8),
                          Text(
                            '${speed}x',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        // Action buttons (right side)
        Positioned(
          right: 15,
          bottom: 100,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
                child: Column(
                  children: [
                    Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 35,
                      color: _isLiked ? Colors.red : Colors.white,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.video.likes,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const Icon(
                    Icons.comment,
                    size: 35,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.video.comments,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Column(
                children: [
                  Icon(
                    Icons.share,
                    size: 35,
                    color: Colors.white,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Video description (bottom left)
        Positioned(
          left: 15,
          bottom: 30,
          right: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.video.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.video.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}