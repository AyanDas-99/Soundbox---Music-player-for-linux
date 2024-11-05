import 'package:flutter/material.dart';
import 'package:soundbox/state/music_list.dart';
import 'package:soundbox/view/components/nav_button.dart';
import 'package:soundbox/view/error_list_screen.dart';
import 'package:soundbox/view/favourites_screen.dart';
import 'package:soundbox/view/music_controls_widget.dart';
import 'package:soundbox/view/music_list_screen.dart';
import 'package:soundbox/view/playlist_screen.dart';
import 'package:split_view/split_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PageControllerScreen extends ConsumerStatefulWidget {
  const PageControllerScreen({super.key});

  @override
  ConsumerState<PageControllerScreen> createState() =>
      _PageControllerScreenState();
}

class _PageControllerScreenState extends ConsumerState<PageControllerScreen> {
  final List<Widget> screens = [
    const PlaylistScreen(),
    const FavouritesScreen(),
    const MusicListScreen(),
    const ErrorListScreen(),
  ];

  int currentScreen = 0;

  SplitViewController controller = SplitViewController(
    weights: [0.3, 0.7],
    limits: [WeightLimit(max: 0.4, min: 0.2)],
  );

  bool searching = false;

  Stream<String>? currentSearching;

  @override
  void initState() {
    super.initState();
    loadMusic();
  }

  loadMusic() async {
    currentSearching = await ref.read(musicListProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: screenWidth < 700
            ? Builder(builder: (context) {
                return IconButton(
                  iconSize: 15,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                );
              })
            : null,
        backgroundColor: Colors.grey.shade900,
        iconTheme: const IconThemeData(color: Colors.grey),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searching = !searching;
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
        bottom: searching
            ? PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const SearchBar(),
                ),
              )
            : null,
      ),
      drawer: screenWidth < 700
          ? Drawer(
              backgroundColor: Colors.blueGrey.shade800,
              child: Column(
                children: [
                  NavButton(
                    icon: const Icon(Icons.view_list_rounded),
                    selected: currentScreen == 0,
                    text: 'Current Playlist',
                    onPress: () {
                      setState(() {
                        currentScreen = 0;
                      });
                    },
                  ),
                  NavButton(
                    icon: const Icon(Icons.favorite_rounded),
                    selected: currentScreen == 1,
                    text: 'Favourites',
                    onPress: () {
                      setState(() {
                        currentScreen = 1;
                      });
                    },
                  ),
                  NavButton(
                      icon: const Icon(Icons.music_note_rounded),
                      selected: currentScreen == 2,
                      text: 'All Songs',
                      onPress: () {
                        setState(() {
                          currentScreen = 2;
                        });
                      }),
                  NavButton(
                      icon: const Icon(Icons.music_off_outlined),
                      selected: currentScreen == 3,
                      text: 'Import Errors',
                      onPress: () {
                        setState(() {
                          currentScreen = 3;
                        });
                      }),
                ],
              ),
            )
          : null,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: (screenWidth > 700)
                    ? SplitView(
                        controller: controller,
                        viewMode: SplitViewMode.Horizontal,
                        gripColor: Colors.blueGrey.shade900,
                        gripColorActive: Colors.grey.shade900,
                        gripSize: 7,
                        children: [
                          Container(
                            color: Colors.blueGrey.shade800,
                            child: ListView(
                              children: [
                                NavButton(
                                  icon: const Icon(Icons.view_list_rounded),
                                  selected: currentScreen == 0,
                                  text: 'Current Playlist',
                                  onPress: () {
                                    setState(() {
                                      currentScreen = 0;
                                    });
                                  },
                                ),
                                NavButton(
                                    icon: const Icon(Icons.favorite_rounded),
                                    selected: currentScreen == 1,
                                    text: 'Favourites Screen',
                                    onPress: () {
                                      setState(() {
                                        currentScreen = 1;
                                      });
                                    }),
                                NavButton(
                                    icon: const Icon(Icons.music_note_rounded),
                                    selected: currentScreen == 2,
                                    text: 'All Songs',
                                    onPress: () {
                                      setState(() {
                                        currentScreen = 2;
                                      });
                                    }),
                                NavButton(
                                    icon: const Icon(Icons.music_off_outlined),
                                    selected: currentScreen == 3,
                                    text: 'Import Errors',
                                    onPress: () {
                                      setState(() {
                                        currentScreen = 3;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.blueGrey.shade900,
                            child: screens[currentScreen],
                          ),
                        ],
                      )
                    : Container(
                        color: Colors.blueGrey.shade900,
                        child: screens[currentScreen],
                      ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Colors.blueGrey.shade800,
                    Colors.grey.shade900,
                  ],
                )),
                // height: 120,
                child: const MusicControlsWidget(),
              )
            ],
          ),
          StreamBuilder(
            stream: currentSearching,
            builder: (context, snapshot) {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Container();
              }
              return Positioned(
                bottom: 2,
                right: 2,
                child: Material(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    height: 25,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      border: Border.all(),
                    ),
                    child: Text(
                      snapshot.data!,
                      style: const TextStyle(
                          color: Colors.white60, fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
