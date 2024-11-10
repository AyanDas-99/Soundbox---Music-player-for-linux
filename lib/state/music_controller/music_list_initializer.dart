import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundbox/state/music_list.dart';
import 'package:soundbox/state/music_test.dart';
import 'package:soundbox/state/playlist.dart';

part 'music_list_initializer.g.dart';

@riverpod
class MusicListInitializer extends _$MusicListInitializer {
  @override
  Future<Null> build() async {
    return null;
  }

  Future initialize() async {
    final allSongsLoadController =
        await ref.read(musicListProvider.notifier).load();
    await for (var _ in allSongsLoadController) {}
    await ref.read(musicTestProvider.future);
    ref.read(playlistProvider.notifier).populate();
  }
}
