import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

String generateRandomString([int length = 32]) {
  const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  final randomStr = List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  return randomStr;
}

Future<File> getTemporary(String ext) async {
  final appCacheDir = await getTemporaryDirectory();
  final path = Directory('${appCacheDir.path}/${generateRandomString()}');
  return File('${path.path}.$ext');
}

Future<File> getDownloads(String filename) async {
  final appDocDir = await getDownloadsDirectory();
  return File('${appDocDir!.path}/$filename');
}
