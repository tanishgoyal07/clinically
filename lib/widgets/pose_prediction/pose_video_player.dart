import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PoseVideoPlayer extends StatelessWidget {
  final VideoPlayerController videoController;

  PoseVideoPlayer({required this.videoController});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: videoController.value.aspectRatio,
      child: VideoPlayer(videoController),
    );
  }
}
