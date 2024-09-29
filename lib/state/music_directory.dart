import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'music_directory.g.dart';

@riverpod
Future<Directory> musicDirectory(MusicDirectoryRef ref) async {
  final downloads = await getDownloadsDirectory();
  final dir = Directory('${downloads?.parent.path}/Music');
  return dir;
}
