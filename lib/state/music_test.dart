import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundbox/state/error_list.dart';
import 'package:soundbox/state/music_list.dart';
import 'dart:developer' as dev;

part 'music_test.g.dart';

@riverpod
Future<void> musicTest(Ref ref) async {
  final audioPlayer = AudioPlayer(playerId: 'test');
  final allMusic = ref.read(musicListProvider);
  // audioPlayer.onLog.listen((String log) => dev.log(log), onError: (e, st) {
  //   // On error
  //   dev.log('Music Test error');
  //   dev.log(e);
  //   // ref.read(musicListProvider.notifier).remove(path);
  // });
  dev.log('Music test run');
  try {
   for (var path in allMusic) {
      // dev.log('Testing $path');
      // Step 1: Check if the file exists
      final source = BytesSource(File(path).readAsBytesSync());

      if (source.bytes.isEmpty) {
        dev.log('File does not exist at $path');
        ref.read(musicListProvider.notifier).remove(path);
        ref.read(errorListProvider.notifier).add(path);
      } else {
        //Error listener for audioplayer
        // Step 2: Attempt to load the file with AudioPlayer
        await source.setOnPlayer(audioPlayer);
        audioPlayer.release();
      }
    }
  } catch (e) {
    // 
  } finally {
    await audioPlayer.dispose();
  }
}
