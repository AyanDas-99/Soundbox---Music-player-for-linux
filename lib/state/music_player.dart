import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundbox/state/audio_player_provider.dart';

part 'music_player.g.dart';

@Riverpod(keepAlive: true)
class MusicPlayer extends _$MusicPlayer {
  @override
  Future<void> build() async {
    return;
  }

  Future play(String path) async {
    final player = ref.read(audioPlayerProvider);
    await player.setSource(DeviceFileSource(path));
    await player.resume();
  }

  Future seek(double position) async {
    final player = ref.read(audioPlayerProvider);
    await player.seek(Duration(milliseconds: position.round()));
  }

  Future pause() async {
    final player = ref.read(audioPlayerProvider);
    await player.pause();
  }

  Future resume() async {
    final player = ref.read(audioPlayerProvider);
    await player.resume();
  }

  Stream<PlayerState> playerState() {
    final player = ref.read(audioPlayerProvider);
    return player.onPlayerStateChanged;
  }

  Future setVolume(double vol) async {
    final player = ref.read(audioPlayerProvider);
    await player.setVolume(vol);
  }
}
