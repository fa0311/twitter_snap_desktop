import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:twitter_snap_desktop/component/future/button.dart';
import 'package:twitter_snap_desktop/component/layout.dart';
import 'package:twitter_snap_desktop/utils/ffmpeg.dart';
import 'package:twitter_snap_desktop/utils/node.dart';

String removeAnsi(String text) {
  return text.replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), '').trim();
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = useTextEditingController();
    final log = useState(<String>[]);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final imageList = useState<List<FileSystemEntity>>([]);

    void addLog(String text) {
      log.value = [...log.value, text];
    }

    Future<void> onSnapPressed() async {
      final ffmpeg = await FFmpeg().check();
      if (!ffmpeg.exists) {
        addLog('Downloading ffmpeg');
        await ffmpeg.install();
      }
      final node = await NodeJs().check();
      if (!node.exists) {
        addLog('Downloading node.js');
      }

      final output = await getApplicationCacheDirectory().then((dir) => Directory('${dir.path}/latest'));
      await output.delete(recursive: true);
      final process = await Process.start(
        '${node.path().path}/npx.cmd',
        [
          '-y',
          'twitter-snap@latest',
          text.text,
          '-o',
          '${output.path}/{id}.{if-photo:png:mp4}',
          '--ffmpegPath',
          '${ffmpeg.path().path}/bin/ffmpeg.exe',
          '--ffprobePath',
          '${ffmpeg.path().path}/bin/ffprobe.exe',
        ],
      );
      process.stdout.transform(utf8.decoder).listen(addLog);
      process.stderr.transform(utf8.decoder).listen(addLog);
      await process.exitCode;
      imageList.value = await output.list().toList();
    }

    Future<void> onRemoveTempPressed() async {
      await getApplicationCacheDirectory().then((dir) => dir.delete(recursive: true));
    }

    return LayoutWidget(
      child: Form(
        key: formKey,
        child: Wrap(
          runSpacing: 20,
          children: [
            TextFormField(
              controller: text,
              decoration: const InputDecoration(labelText: 'Text'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(
              width: double.infinity,
              child: FutureButton(
                type: ButtonType.elevatedButton,
                onPressed: () async {
                  log.value = [];
                  if (formKey.currentState!.validate()) {
                    await onSnapPressed();
                  }
                },
                child: const Text('Snap'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FutureButton(
                type: ButtonType.elevatedButton,
                onPressed: onRemoveTempPressed,
                child: const Text('Remove Temp'),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                children: log.value.map(removeAnsi).map(Text.new).toList(),
              ),
            ),
            for (final image in imageList.value)
              SizedBox(
                height: 500,
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: File.fromUri(image.uri).readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.memory(snapshot.data!);
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
