import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Services
import 'package:video_player/video_player.dart';

class PlayerPage extends StatefulWidget {
  final int index;
  final int videoNum;
  const PlayerPage({Key? key, required this.index, required this.videoNum}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  late String videoPath;
  double _currentSliderValue = 0.0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    WidgetsBinding.instance.addObserver(this); // Add the observer
  }

  void _initializeVideo() {
    switch ('${widget.videoNum}') {
      case '0':
        videoPath = '0';
        break;
      case '1':
        videoPath = '1';
        break;
      case '2':
        videoPath = '2';
        break;
      case '3':
        videoPath = '3';
        break;
      case '4':
        videoPath = '4';
        break;
      case '5':
        videoPath = '5';
        break;
      case '6':
        videoPath = '6';
        break;
      default:
        videoPath = '0';
        break;
    }
    _controller = VideoPlayerController.asset('lib/assets/videos/$videoPath.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        Timer(const Duration(seconds: 5), () {
          setState(() {
            _showControls = false;
          });
        });
      });
    _controller.addListener(() {
      setState(() {
        _currentSliderValue = _controller.value.position.inSeconds.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  Visibility(
                    visible: _showControls,
                    child: Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Slider(
                        value: _currentSliderValue,
                        min: 0.0,
                        max: _controller.value.duration.inSeconds.toDouble(),
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                          _controller.seekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
                : Container(),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showControls = !_showControls;
                });
              },
            ),
          ),
          Visibility(
            visible: _showControls,
            child: Center(
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                  });
                },
                child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    /* super.dispose();
    _controller.dispose();*/
    WidgetsBinding.instance.removeObserver(this); // Remove the observer
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (!_controller.value.isPlaying) {
        _controller.play();
      }
    }
  }
}