import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soundbox/state/favourites/favourites.dart';
import 'package:soundbox/state/music_list.dart';
import 'package:path/path.dart' as p;
import 'package:soundbox/state/music_player.dart';
import 'package:soundbox/state/playlist.dart';
import 'package:soundbox/view/components/music_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                trailing: MusicListItemMenu(
                  songPath: musicList[index],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MusicListItemMenu extends ConsumerStatefulWidget {
  const MusicListItemMenu({
    super.key,
    required this.songPath,
  });

  final String songPath;

  @override
  ConsumerState<MusicListItemMenu> createState() => _MusicListItemMenuState();
}

class _MusicListItemMenuState extends ConsumerState<MusicListItemMenu> {
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blueGrey.shade800),
      ),
      menuChildren: [
        ListTile(
          onTap: () async {
            final messenger = ScaffoldMessenger.of(context);
            final result = await ref
                .read(favouritesProvider.notifier)
                .addToFav(widget.songPath);
            if (result.success) {
              messenger.showSnackBar(
                  const SnackBar(content: Text('Added to favourite')));
            } else {
              messenger.showSnackBar(SnackBar(content: Text(result.msg!)));
            }
            _menuController.close();
          },
          title: const Text(
            'Add to favourites',
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
    );
  }
}
