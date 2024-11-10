import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soundbox/state/favourites/favourites.dart';
import 'package:path/path.dart' as p;
import 'package:soundbox/state/music_player.dart';
import 'package:soundbox/view/components/music_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favourites = ref.watch(favouritesProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Favourites',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: favourites.isEmpty
                ? const Center(
                    child: Text(
                    'Empty',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ))
                : ListView.builder(
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          textColor: Colors.white,
                          title: Text(
                              p.basenameWithoutExtension(favourites[index])),
                          iconColor: Colors.white,
                          leading: MusicImage(track: File(favourites[index])),
                          onTap: () {
                            ref
                                .read(musicPlayerProvider.notifier)
                                .play(favourites[index]);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
