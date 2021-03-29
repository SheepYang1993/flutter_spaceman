import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String videoAssetsUrl;

  @override
  _VideoViewState createState() => _VideoViewState(videoAssetsUrl);

  VideoView(this.videoAssetsUrl);
}

class _VideoViewState extends State<VideoView> {
  String videoAssetsUrl;
  late VideoPlayerController _controller;

  _VideoViewState(this.videoAssetsUrl);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(this.videoAssetsUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
