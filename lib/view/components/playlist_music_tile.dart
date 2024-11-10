import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:soundbox/state/audio_player/audio_player_provider.dart';
import 'package:soundbox/state/current_playing_controller.dart';
import 'package:soundbox/state/favourites/favourites.dart';
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

  StreamSubscription? _playerStateChangeSubscription;

  bool playing = false;

  @override
  void initState() {
    super.initState();
    _playerStateChangeSubscription =
        ref.read(audioPlayerProvider).onPlayerStateChanged.listen((state) {
      setState(() {
        playing = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = ref.watch(currentPlayingControllerProvider);
    return ListTile(
      leading: MusicImage(
        track: File(widget.song.path),
      ),
      textColor: Colors.white,
      iconColor: Colors.white,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentSong == widget.song)
            MiniMusicVisualizer(
              radius: 10,
              color: Colors.purple,
              width: 8,
              height: 20,
              animate: playing,
            ),
            const SizedBox(width: 10),
          MenuAnchor(
            controller: _menuController,
            style: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blueGrey.shade800),
            ),
            menuChildren: [
              ListTile(
                onTap: () async {
                  ref
                      .read(favouritesProvider.notifier)
                      .addToFav(widget.song.path);
                  _menuController.close();
                },
                title: const Text(
                  'Add to favourites',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ListTile(
                onTap: () async {
                  ref
                      .read(playlistProvider.notifier)
                      .removeFromQueue(widget.song);
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
        ],
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
