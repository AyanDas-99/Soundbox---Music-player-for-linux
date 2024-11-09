import 'dart:collection';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundbox/state/current_playing_controller.dart';
import 'package:soundbox/state/music_list.dart';
import 'dart:developer' as dev;
part 'playlist.g.dart';

@Riverpod(keepAlive: true)
class Playlist extends _$Playlist {
  @override
  LinkedList<SongListItem> build() {
    return LinkedList<SongListItem>();
  }

  populate() {
    dev.log('populating');
    final music = ref.read(musicListProvider);
    print(music);
    final list = LinkedList<SongListItem>();
    list.addAll(music.map((song) => SongListItem(path: song)));
    state = list;
  }

  addToQueue(SongListItem song) {
    final playingSong = ref.read(currentPlayingControllerProvider);
    state.remove(song);
    if (playingSong == null) {
      state.addFirst(song);
    } else {
      if (state.first.path == playingSong.path) {
        state.first.insertAfter(song);
      } else {
        state.addFirst(song);
      }
    }
    _notifyListeners();
  }

  removeFromQueue(SongListItem song) {
    state.remove(song);

    _notifyListeners();
  }

  moveSong(SongListItem song,
      {required SongListItem relativeTo, required bool after}) {
    state.remove(song);
    if (!after) {
      relativeTo.insertBefore(song);
    } else {
      relativeTo.insertAfter(song);
    }
    _notifyListeners();
  }

  void _notifyListeners() {
    final newList = LinkedList<SongListItem>();
    for (var song in state) {
      newList.add(SongListItem(path: song.path));
    }
    state = newList;
  }
}

final class SongListItem extends LinkedListEntry<SongListItem> {
  final String path;
  SongListItem({required this.path});

  @override
  bool operator ==(covariant SongListItem other) {
    return path == other.path;
  }

  @override
  int get hashCode => Object.hashAll([path]);
}
