import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:twitter_snap_desktop/utils/temp.dart';

class NodeJs {
  NodeJs();

  Future<NodeJsChecked> check() async {
    final nodeDir = await getApplicationCacheDirectory().then((dir) => Directory('${dir.path}/node'));
    final exists = await nodeDir.exists() && (await nodeDir.list().toList()).isNotEmpty;
    return NodeJsChecked(nodeDir: nodeDir, exists: exists);
  }
}

class NodeJsChecked {
  NodeJsChecked({required this.nodeDir, required this.exists});
  static Uri url = Uri.parse('https://nodejs.org/dist/v20.18.0/node-v20.18.0-win-x64.zip');
  final Directory nodeDir;
  final bool exists;

  FileSystemEntity path() {
    return nodeDir.listSync().sorted((a, b) => a.path.compareTo(b.path)).first;
  }

  Future<void> install() async {
    final zipFile = await getTemporary('zip');

    final response = await Dio().downloadUri(url, zipFile.path);
    if (response.statusCode != 200) {
      throw Exception('Failed to download node.js');
    }

    await nodeDir.create();
    await extractFileToDisk(zipFile.path, nodeDir.path);
    await zipFile.delete();
  }
}
