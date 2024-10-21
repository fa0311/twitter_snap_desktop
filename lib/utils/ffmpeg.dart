import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:twitter_snap_desktop/utils/temp.dart';

class FFmpeg {
  FFmpeg();

  Future<FFmpegChecked> check() async {
    final ffmpegDir = await getApplicationCacheDirectory().then((dir) => Directory('${dir.path}/ffmpeg'));
    final exists = await ffmpegDir.exists() && (await ffmpegDir.list().toList()).isNotEmpty;
    return FFmpegChecked(ffmpegDir: ffmpegDir, exists: exists);
  }
}

class FFmpegChecked {
  FFmpegChecked({required this.ffmpegDir, required this.exists});
  static Uri url = Uri.parse('https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-7.1-essentials_build.zip');
  final Directory ffmpegDir;
  final bool exists;

  FileSystemEntity path() {
    return ffmpegDir.listSync().sorted((a, b) => a.path.compareTo(b.path)).first;
  }

  Future<void> install() async {
    final zipFile = await getTemporary('zip');

    final response = await Dio().downloadUri(url, zipFile.path);
    if (response.statusCode != 200) {
      throw Exception('Failed to download ffmpeg');
    }

    await ffmpegDir.create();
    await extractFileToDisk(zipFile.path, ffmpegDir.path);
    await zipFile.delete();
  }
}
