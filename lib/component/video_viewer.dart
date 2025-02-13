import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoViewer extends HookWidget {
  const VideoViewer({super.key, required this.file});
  final File file;

  @override
  Widget build(BuildContext context) {
    final rectState = useState<Rect?>(null);
    final controller = useMemoized(() {
      final player = Player()
        ..open(Media(file.path))
        ..setVolume(0);

      return VideoController(player);
    });

    useEffect(
      () {
        controller.waitUntilFirstFrameRendered.then((_) {
          rectState.value = controller.rect.value;
        });
        return null;
      },
      [],
    );

    return switch (controller.rect.value) {
      null => const SizedBox.shrink(),
      Rect(:final width, :final height) => AspectRatio(
          aspectRatio: width / height,
          child: Video(controller: controller),
        )
    };
  }
}
