import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:twitter_snap_desktop/utils/temp.dart';

Future<FileSystemEntity> getFfmpeg() async {
  final url = Uri.parse('https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-7.1-essentials_build.zip');

  final ffmpegDir = await getApplicationCacheDirectory().then((dir) => Directory('${dir.path}/ffmpeg'));

  if (ffmpegDir.existsSync() && ffmpegDir.listSync().isNotEmpty) {
    final list = await ffmpegDir.list().toList();
    return list.sorted((a, b) => a.path.compareTo(b.path)).first;
  } else {
    final zipFile = await getTemporary('zip');

    final response = await Dio().downloadUri(url, zipFile.path);
    if (response.statusCode != 200) {
      throw Exception('Failed to download ffmpeg');
    }

    await ffmpegDir.create();
    await extractFileToDisk(zipFile.path, ffmpegDir.path);
    await zipFile.delete();
    return ffmpegDir.listSync().sorted((a, b) => a.path.compareTo(b.path)).first;
  }
}
