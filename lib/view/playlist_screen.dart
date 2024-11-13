import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soundbox/state/playlist.dart';
import 'package:path/path.dart' as p;
import 'package:soundbox/view/components/music_image.dart';
import 'package:soundbox/view/components/playlist_music_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  const PlaylistScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    final playlist = ref.watch(playlistProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Current Playlist",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ref.read(playlistProvider.notifier).populate();
                },
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              ),
              const SizedBox(width: 30),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ReorderableListView.builder(
              proxyDecorator: (child, index, animation) {
                String name =
                    p.basenameWithoutExtension(playlist.elementAt(index).path);
                if (name.length > 50) {
                  name = '${name.substring(0, 30)}...';
                }
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade900,
                          offset: const Offset(-2, 3),
                          blurRadius: 10,
                        )
                      ]),
                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                  child: Row(
                    children: [
                      MusicImage(track: File(playlist.elementAt(index).path)),
                      const SizedBox(width: 20),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
              buildDefaultDragHandles: false,
              itemCount: playlist.length,
              itemBuilder: (context, index) {
                return ReorderableDelayedDragStartListener(
                  // key: Key(playlist.elementAt(index).path),
                  key: Key(index.toString()),
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlaylistMusicTile(
                      playlist.elementAt(index),
                    ),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                final song = playlist.elementAt(oldIndex);
                if (newIndex == 0) {
                  ref
                      .read(playlistProvider.notifier)
                      .moveSong(song, relativeTo: playlist.first, after: false);
                } else if (newIndex == playlist.length) {
                  ref
                      .read(playlistProvider.notifier)
                      .moveSong(song, relativeTo: playlist.last, after: true);
                } else {
                  ref.read(playlistProvider.notifier).moveSong(song,
                      relativeTo: playlist.elementAt(newIndex), after: false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
