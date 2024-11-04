import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_snap_desktop/component/layout.dart';
import 'package:twitter_snap_desktop/component/video_viewer.dart';
import 'package:twitter_snap_desktop/controller/twitter_snap_controller.dart';

String removeAnsi(String text) {
  return text.replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), '').trim();
}

class OutputViewPage extends HookConsumerWidget {
  const OutputViewPage({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(twitterSnapNotifierProvider);

    useEffect(
      () {
        Future(() async {
          await ref.read(twitterSnapNotifierProvider.notifier).exec(text);
        });
        return null;
      },
      [],
    );

    return LayoutWidget(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView(
              children: stream.log.map(removeAnsi).map(Text.new).toList(),
            ),
          ),
          for (final file in stream.files) ...[
            Text(file),
            if (file.endsWith('.png'))
              SizedBox(
                height: 500,
                child: Image.file(File(file)),
              ),
            if (file.endsWith('.mp4'))
              SizedBox(
                height: 500,
                child: VideoViewer(
                  file: File(file),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
