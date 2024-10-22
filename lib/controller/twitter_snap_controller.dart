import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_snap_desktop/model/twitter_snap_model.dart';
import 'package:twitter_snap_desktop/utils/ffmpeg.dart';
import 'package:twitter_snap_desktop/utils/node.dart';

part 'twitter_snap_controller.g.dart';

@riverpod
class TwitterSnapNotifier extends _$TwitterSnapNotifier {
  @override
  TwitterSnapModel build() {
    return const TwitterSnapModel(isLoading: false, log: [], files: []);
  }

  void addLog(String text) {
    state = state.copyWith(log: [...state.log, text]);
  }

  String getIdList(String path) {
    final regex = RegExp(r'[-\\/]([\d]+)[-.]');
    final match = regex.allMatches(path).last;
    return match.group(1)!;
  }

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
        'twitter-snap@latest',
        url,
        '-o',
        '${output.path}/{id}.{if-photo:png:mp4}',
        '--ffmpegPath',
        ffmpegPath,
        '--ffprobePath',
        ffprobePath,
      ],
    );
    process.stdout.transform(utf8.decoder).listen(addLog);
    process.stderr.transform(utf8.decoder).listen(addLog);

    final idList = <(String, String)>[];
    output.watch().listen((e) {
      final id = getIdList(e.path);
      final find = idList.firstWhereOrNull((element) => element.$1 == id);
      if (find == null) {
        state = state.copyWith(files: idList.map((e) => e.$2).toList());
        idList.add((id, e.path));
      } else {
        idList
          ..remove(find)
          ..add((id, e.path));
      }
    });
    await process.exitCode;
    state = state.copyWith(isLoading: false, files: idList.map((e) => e.$2).toList());
  }
}