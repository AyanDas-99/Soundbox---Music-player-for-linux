import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soundbox/state/music_list.dart';
import 'package:path/path.dart' as p;
import 'package:soundbox/state/music_player.dart';
import 'package:soundbox/view/components/music_image.dart';

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
    return Column(
      children: [
        const SizedBox(
          height: 50,
          child: Text(
            'All songs',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: musicList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                textColor: Colors.white,
                title: Text(p.basenameWithoutExtension(musicList[index])),
                iconColor: Colors.white,
                leading: MusicImage(track: File(musicList[index])),
                onTap: () {
                  ref.read(musicPlayerProvider.notifier).play(musicList[index]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
