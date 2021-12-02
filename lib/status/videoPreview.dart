import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  final _path;
  VideoPreview(this._path);
  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget._path))
      ..setVolume(1)
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (_controller.value.isInitialized)
        ? Stack(
            children: [
              VideoPlayer(_controller),
              Center(
                  child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Icon(
                  Icons.play_circle,
                  size: 36,
                  color: Color.fromRGBO(255, 0, 0, 1),
                ),
              ))
            ],
          )
        : Center(
            child: const Text(
              "...",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
  }
}
