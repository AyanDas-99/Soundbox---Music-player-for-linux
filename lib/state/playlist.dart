import 'dart:collection';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundbox/state/music_list.dart';

part 'playlist.g.dart';

@Riverpod(keepAlive: true)
class Playlist extends _$Playlist {
  @override
  LinkedList<SongListItem> build() {
    return LinkedList<SongListItem>();
  }

  populate() {
    final music = ref.read(musicListProvider);
    final list = LinkedList<SongListItem>();
    list.addAll(music.map((song) => SongListItem(path: song)));
    state = list;
  }

  addToQueue(SongListItem song)   {
  }

}

final class SongListItem extends LinkedListEntry<SongListItem> {
  final String path;
  SongListItem({required this.path});
}
