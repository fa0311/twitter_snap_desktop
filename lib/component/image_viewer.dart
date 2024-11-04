import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({super.key, required this.file});

  final File file;

  @override
  ImageViewerState createState() => ImageViewerState();
}

class ImageViewerState extends State<ImageViewer> {
  late final controller = VideoController(player);
  late final player = Player();

  @override
  void initState() {
    super.initState();
    player
      ..open(Media(widget.file.path))
      ..setVolume(0);
  }

  @override
  Widget build(BuildContext context) {
    return Video(controller: controller);
  }
}
