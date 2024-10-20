import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:twitter_snap_desktop/component/future/button.dart';
import 'package:twitter_snap_desktop/utils/ffmpeg.dart';
import 'package:twitter_snap_desktop/utils/node.dart';

String removeAnsi(String text) {
  return text.replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), '').trim();
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = useState(0);
    final text = useTextEditingController();
    final log = useState(<String>[]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Wrap(
              runSpacing: 20,
              children: [
                TextField(
                  controller: text,
                  decoration: const InputDecoration(
                    hintText: 'Tweet URL',
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FutureButton(
                    type: ButtonType.elevatedButton,
                    onPressed: () async {
                      log.value = [];
                      final ffmpeg = await getFfmpeg();
                      log.value = [...log.value, 'ffmpeg: ${ffmpeg.path}'];
                      final node = await getNodeJs();
                      log.value = [...log.value, 'node: ${node.path}'];
                      final output = await getDownloadsDirectory();

                      final process = await Process.start(
                        '${node.path}/npx.cmd',
                        [
                          '-y',
                          'twitter-snap@latest',
                          text.text,
                          '-o',
                          '${output!.path}/twitter-snap/{id}.{if-photo:png:mp4}',
                          '--ffmpegPath',
                          '${ffmpeg.path}/bin/ffmpeg.exe',
                          '--ffprobePath',
                          '${ffmpeg.path}/bin/ffprobe.exe',
                        ],
                      );

                      process.stdout.transform(utf8.decoder).listen((e) => log.value = [...log.value, e]);
                      process.stderr.transform(utf8.decoder).listen((e) => log.value = [...log.value, e]);
                      await process.exitCode;
                    },
                    child: const Text('Snap'),
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: ListView(
                    children: log.value.map(removeAnsi).map(Text.new).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.value++,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}