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
    player.onLog.listen((String log) => print(log), onError: (e, st) {
      // On error
      // ref.read(musicListProvider.notifier).remove(path);
      print(e);
    });

    try {
      await player.setSourceUrl(url);
      return StreamResult(success: true);
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
