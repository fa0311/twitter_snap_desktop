import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:twitter_snap_desktop/utils/temp.dart';

Future<FileSystemEntity> getNodeJs() async {
  final url = Uri.parse('https://nodejs.org/dist/v20.18.0/node-v20.18.0-win-x64.zip');

  final nodeDir = await getApplicationCacheDirectory().then((dir) => Directory('${dir.path}/node'));

  if (nodeDir.existsSync() && nodeDir.listSync().isNotEmpty) {
    final list = await nodeDir.list().toList();
    return list.sorted((a, b) => a.path.compareTo(b.path)).first;
  } else {
    final zipFile = await getTemporary('zip');

    final response = await Dio().downloadUri(url, zipFile.path);
    if (response.statusCode != 200) {
      throw Exception('Failed to download node.js');
    }

    await nodeDir.create();
    await extractFileToDisk(zipFile.path, nodeDir.path);
    await zipFile.delete();
    return nodeDir.listSync().sorted((a, b) => a.path.compareTo(b.path)).first;
  }
}
