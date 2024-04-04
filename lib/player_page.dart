import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'videos_page.dart';

class PlayerPage extends StatefulWidget {
  final int index;
  const PlayerPage({Key? key, required this.index}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late VideoPlayerController _controller;
  late String videoPath;

  get videoNum => 0;

  @override
  void initState() {
    super.initState();
    _initializeVideo(); // Call a method to initialize video
  }

  // Method to initialize video based on videoNum
  void _initializeVideo() {
    switch (videoNum) { // Use widget.index to get videoNum
      case 0:
        videoPath = '0';
        break;
      case 1:
        videoPath = '1';
        break;
      case 2:
        videoPath = '2';
        break;
      case 3:
        videoPath = '3';
        break;
      default:
        videoPath = '0';
        break;
    }
    _controller = VideoPlayerController.asset('lib/assets/videos/$videoPath.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
