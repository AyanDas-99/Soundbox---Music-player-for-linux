import 'dart:async';
import 'dart:io';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundbox/state/music_directory.dart';

part 'music_list.g.dart';

@Riverpod(keepAlive: true)
class MusicList extends _$MusicList {
  @override
  List<String> build() {
    return [];
  }

  Future<Stream<String>> load() async {
    state = [];
    StreamController<String> controller = StreamController<String>();
    final dir = await ref.read(musicDirectoryProvider.future);
    final music = _search(dir).asBroadcastStream();
    music.listen(
      (data) {
        state = [...state, data.path];
        controller.sink.add(data.path);
      },
      onDone: () {
        controller.sink.add('');
        // ref.read(musicTestProvider);
        controller.sink.close();
      },
    );
    return controller.stream;
  }

  Future<bool> remove(String path) async {
    if (!state.contains(path)) {
      return false;
    }
    final values = state;
    values.remove(path);
    state = values;
    return true;
  }

  Stream<File> _search(Directory dir) {
    return Glob("**.{mp3,wav,m4a}")
        .list(root: dir.path)
        .where((entity) => entity is File)
        .cast<File>();
  }
}
