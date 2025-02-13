import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_snap_desktop/model/twitter_snap_model.dart';
import 'package:twitter_snap_desktop/utils/ffmpeg.dart';
import 'package:twitter_snap_desktop/utils/node.dart';

part 'twitter_snap_controller.g.dart';

@Riverpod(keepAlive: true)
class TwitterSnapNotifier extends _$TwitterSnapNotifier {
  @override
  TwitterSnapModel build() {
    return const TwitterSnapModel(isLoading: false, log: [], files: []);
  }

  void addLog(String text) {
    state = state.copyWith(log: [...state.log, text]);
  }

  // String getIdList(String path) {
  //   final regex = RegExp(r'[-\\/]([\d]+)[-.]');
  //   final match = regex.allMatches(path).last;
  //   return match.group(1)!;
  // }

  Future<void> exec(String url) async {
    if (state.isLoading) {
      return;
    }

    state = const TwitterSnapModel(isLoading: true, log: [], files: []);

    final ffmpeg = await FFmpeg().check();
    if (!ffmpeg.exists) {
      addLog('Downloading ffmpeg');
      await ffmpeg.install();
    }
    final ffmpegPath = '${ffmpeg.path().path}/bin/ffmpeg.exe';
    final ffprobePath = '${ffmpeg.path().path}/bin/ffprobe.exe';

    final node = await NodeJs().check();
    if (!node.exists) {
      addLog('Downloading node');
      await node.install();
    }
    final npxPath = '${node.path().path}/npx.cmd';

    final output = await getApplicationCacheDirectory().then((dir) => Directory('${dir.path}/latest'));

    if (await output.exists()) {
      await output.delete(recursive: true);
    }
    await output.create(recursive: true);

    final process = await Process.start(
      npxPath,
      [
        '-y',
        'twitter-snap@0.0.67',
        url,
        '-o',
        '${output.path}/{id}-{count}.{if-type:png:mp4:json:}',
        '--ffmpegPath',
        ffmpegPath,
        '--ffprobePath',
        ffprobePath,
        '--simpleLog',
      ],
    );
    process.stdout.transform(utf8.decoder).listen(addLog);
    process.stderr.transform(utf8.decoder).listen(addLog);

    final logStream = output.watch().listen((event) {
      final path = Uri.file(event.path).pathSegments.last;
      final type = switch (event) {
        FileSystemCreateEvent() => 'Create',
        FileSystemModifyEvent() => 'Modify',
        FileSystemDeleteEvent() => 'Delete',
        FileSystemMoveEvent() => 'Move',
      };
      addLog('$type: $path');
    });

    final imageStream = output.watch(events: FileSystemEvent.modify).listen((event) async {
      final list = await output.list().toList();
      final tempIgnore = list.whereType<File>().where((e) => !e.uri.pathSegments.last.startsWith('temp'));
      state = state.copyWith(files: tempIgnore.map((e) => e.path).toList());
    });
    await process.exitCode;
    await imageStream.cancel();
    await logStream.cancel();
    state = state.copyWith(isLoading: false);
  }
}
