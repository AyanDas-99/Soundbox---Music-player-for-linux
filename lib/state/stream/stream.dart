import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundbox/state/audio_player/audio_player_provider.dart';

part 'stream.g.dart';

@riverpod
class Stream extends _$Stream {
  @override
  Future<void> build() async {
    return;
  }

  Future<StreamResult> play(String url) async {
    final player = ref.read(audioPlayerProvider);
    try {
      await player.play(UrlSource(url));
      return StreamResult(success: true);
    } on AudioPlayerException catch (audioException) {
      return StreamResult(
          success: false, error: audioException.cause.toString());
    } on PlatformException catch (platformException) {
      return StreamResult(success: false, error: platformException.message);
    } catch (e) {
      return StreamResult(success: false, error: e.toString());
    }
  }
}

class StreamResult {
  final bool success;
  final String? error;

  StreamResult({required this.success, this.error});

  @override
  String toString() {
    return "StreamResult(success: $success error: $error)";
  }
}
