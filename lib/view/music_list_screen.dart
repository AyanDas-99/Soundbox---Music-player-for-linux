import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soundbox/state/music_list.dart';
import 'package:path/path.dart' as p;
import 'package:soundbox/state/music_player.dart';

class MusicListScreen extends ConsumerStatefulWidget {
  const MusicListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MusicListScreenState();
}

class _MusicListScreenState extends ConsumerState<MusicListScreen> {
  @override
  Widget build(BuildContext context) {
    final musicList = ref.watch(musicListProvider);
    return ListView.builder(
      itemCount: musicList.length,
      itemBuilder: (context, index) => ListTile(
        textColor: Colors.white,
        title: Text(p.basename(musicList[index])),
        onTap: () {
          ref.read(musicPlayerProvider.notifier).play(musicList[index]);
        },
      ),
    );
  }
}
