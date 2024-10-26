import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:soundbox/state/current_playing_controller.dart';
import 'package:soundbox/state/playlist.dart';
import 'package:soundbox/view/components/music_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlaylistMusicTile extends ConsumerStatefulWidget {
  const PlaylistMusicTile(this.song, {super.key});

  @override
  ConsumerState<PlaylistMusicTile> createState() => _PlaylistMusicTileState();
  final SongListItem song;
}

class _PlaylistMusicTileState extends ConsumerState<PlaylistMusicTile> {
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    final currentSong = ref.watch(currentPlayingControllerProvider);
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentSong == widget.song) ...[
            Container(
              height: double.infinity,
              width:5 ,
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(width: 5),
          ],
          MusicImage(
            track: File(widget.song.path),
          ),
        ],
      ),
      textColor: Colors.white,
      iconColor: Colors.white,
      trailing: MenuAnchor(
        controller: _menuController,
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.blueGrey.shade800),
        ),
        menuChildren: [
          ListTile(
            onTap: () async {
              ref.read(playlistProvider.notifier).removeFromQueue(widget.song);
            },
            title: const Text(
              'Remove from playlist',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ListTile(
            onTap: () async {
              _menuController.close();
              // ref.read(playlistProvider.notifier).moveSong(widget.song,
              //     relativeTo: ref.read(playlistProvider).first, after: false);
              ref.read(playlistProvider.notifier).addToQueue(widget.song);
            },
            title: const Text(
              'Move to top',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
        builder: (context, controller, child) => IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.more_vert)),
      ),
      onTap: () {
        ref.read(currentPlayingControllerProvider.notifier).play(widget.song);
      },
      title: Text(
        p.basenameWithoutExtension(widget.song.path),
      ),
    );
  }
}
