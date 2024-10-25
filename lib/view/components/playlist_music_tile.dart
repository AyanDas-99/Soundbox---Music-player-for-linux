import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soundbox/state/current_playing_controller.dart';
import 'package:soundbox/state/playlist.dart';
import 'package:soundbox/view/components/music_image.dart';

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
    return ListTile(
      leading: MusicImage(
        track: File(widget.song.path),
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
