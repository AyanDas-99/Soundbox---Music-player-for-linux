import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundbox/state/music_player.dart';
import 'package:soundbox/state/playlist.dart';

part 'current_playing_controller.g.dart';

@Riverpod(keepAlive: true)
class CurrentPlayingController extends _$CurrentPlayingController {
  @override
  SongListItem? build() {
    _listenToStates();
    if (ref.read(playlistProvider).isEmpty) {
      return null;
    }
    return ref.read(playlistProvider).first;
  }

  void playPrev() {
    if (state == null) return;
    if (state!.previous == null) {
      return;
    }

    ref.read(musicPlayerProvider.notifier).play(state!.previous!.path);
    state = state!.previous!;
  }

  Future<bool> playFirst() async {
    final playlist = ref.read(playlistProvider);
    if (playlist.isEmpty) {
      return false;
    }

    state = playlist.first;
    ref.read(musicPlayerProvider.notifier).play(state!.path);

    return true;
  }

  void playNext() {
    final playlist = ref.read(playlistProvider);
    if (playlist.isEmpty) {
      return;
    }

    if (state == null || state?.next == null) {
      state = playlist.first;
      ref.read(musicPlayerProvider.notifier).play(state!.path);
      return;
    }

    state = state?.next;
    ref.read(musicPlayerProvider.notifier).play(state!.path);
  }

  void play(SongListItem song) {
    state = song;
    ref.read(musicPlayerProvider.notifier).play(song.path);
  }

  _listenToStates() {
    final playerState = ref.read(musicPlayerProvider.notifier).playerState();
    playerState.listen((event) {
      switch (event) {
        case PlayerState.stopped:
        // TODO: Handle this case.
        case PlayerState.playing:
        // TODO: Handle this case.
        case PlayerState.paused:
          // TODO: Handle this case.
          print('Paused');
        case PlayerState.completed:
          print('Completed song $state');
          playNext();
        case PlayerState.disposed:
          // TODO: Handle this case.
          print('disposed');
      }
    });
  }
}
