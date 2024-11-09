import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundbox/state/music_list.dart';

part 'music_directory.g.dart';

// @riverpod
// Future<Directory> musicDirectory(MusicDirectoryRef ref) async {
//   final prefs = await SharedPreferences.getInstance();
//   String? musicDir = await prefs.getString('music-directory');
//   final downloads = await getDownloadsDirectory();
//   final dir = Directory('${downloads?.parent.path}/Music');
//   return dir;
// }

@riverpod
class MusicDirectory extends _$MusicDirectory {
  @override
  Future<Directory> build() async {
    final prefs = await SharedPreferences.getInstance();
    String? musicDir = prefs.getString('music-directory');
    if (musicDir == null) {
      final downloads = await getDownloadsDirectory();
      final dir = Directory('${downloads?.parent.path}/Music');
      return dir;
    }
    return Directory(musicDir);
  }

  Future setMusicDirectory(String path) async {
    state = AsyncValue.data(Directory(path));
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('music-directory', path);
    ref.read(musicListProvider.notifier).load();
  }
}
