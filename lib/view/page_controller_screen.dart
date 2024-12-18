import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:soundbox/state/image_color/image_color.dart';
import 'package:soundbox/state/loading/loading.dart';
import 'package:soundbox/state/music_controller/music_list_initializer.dart';
import 'package:soundbox/view/components/app_loader.dart';
import 'package:soundbox/view/components/nav_button.dart';
import 'package:soundbox/view/error_list_screen.dart';
import 'package:soundbox/view/favourites_screen.dart';
import 'package:soundbox/view/music_controls_widget.dart';
import 'package:soundbox/view/music_list_screen.dart';
import 'package:soundbox/view/playlist_screen.dart';
import 'package:soundbox/view/settings/settings_screen.dart';
import 'package:soundbox/view/stream/stream_screen.dart';
import 'package:split_view/split_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/scheduler.dart';

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
    const StreamScreen(),
    const SettingsScreen(),
  ];

  int currentScreen = 0;

  SplitViewController controller = SplitViewController(
    weights: [0.2, 0.8],
    limits: [WeightLimit(max: 0.4, min: 0.2)],
  );

  bool searching = false;

  Stream<String>? currentSearching;

  @override
  void initState() {
    super.initState();
    load();
  }

  // Initialize music list after UI finishes building
  load() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(musicListInitializerProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLoading = ref.watch(loadingProvider);

    final colorScheme = ref.watch(imageColorProvider);

    if (isLoading) {
      // Loading page
      return AppLoader();
    }

    // Real Page
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
                  NavButton(
                      icon: const Icon(CupertinoIcons.wifi),
                      selected: currentScreen == 4,
                      text: 'Stream',
                      onPress: () {
                        setState(() {
                          currentScreen = 4;
                        });
                      }),
                  NavButton(
                      icon: const Icon(CupertinoIcons.wrench_fill),
                      selected: currentScreen == 5,
                      text: 'Settings',
                      onPress: () {
                        setState(() {
                          currentScreen = 5;
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
                                NavButton(
                                    icon: const Icon(CupertinoIcons.wifi),
                                    selected: currentScreen == 4,
                                    text: 'Stream',
                                    onPress: () {
                                      setState(() {
                                        currentScreen = 4;
                                      });
                                    }),
                                NavButton(
                                    icon:
                                        const Icon(CupertinoIcons.wrench_fill),
                                    selected: currentScreen == 5,
                                    text: 'Settings',
                                    onPress: () {
                                      setState(() {
                                        currentScreen = 5;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                              colorScheme.tertiary,
                            ])),
                            duration: const Duration(milliseconds: 500),
                            child: screens[currentScreen],
                          ),
                        ],
                      )
                    : Container(
                        // color: Colors.blueGrey.shade900,
                        child: screens[currentScreen],
                      ),
              ),
              const SizedBox(height: 10),
              const MusicControlsWidget()
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
