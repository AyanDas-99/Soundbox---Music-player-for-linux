import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_player_provider.g.dart';

@Riverpod(keepAlive: true)
AudioPlayer audioPlayer(AudioPlayerRef ref) {
  final audioPlayer = AudioPlayer();

  ref.onDispose(() {
    audioPlayer.dispose();
  });

  return audioPlayer;
}
