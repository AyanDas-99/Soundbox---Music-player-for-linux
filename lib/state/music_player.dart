import 'dart:io';

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

  Future<bool> play(String path) async {
    final player = ref.read(audioPlayerProvider);

    // final source = DeviceFileSource(path);
    // await player.setSource(source);
    try {
      final source = BytesSource(File(path).readAsBytesSync());
      if (source.bytes.isEmpty) {
        return false;
      }
      await source.setOnPlayer(player);
      await player.resume();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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
