import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:soundbox/state/audio_player/audio_player_provider.dart';
import 'package:soundbox/state/current_playing_controller.dart';
import 'package:soundbox/view/components/music_image_placeholder.dart';
import 'package:path/path.dart' as p;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:soundbox/view/components/music_position_text_widget.dart';
import 'package:soundbox/view/components/music_slider_widget.dart';
import 'package:soundbox/view/components/volume_rocker.dart';
import 'package:soundbox/view/detailed_screen.dart';

class MusicControlsWidget extends StatefulHookConsumerWidget {
  const MusicControlsWidget({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MusicControlsWidgetState();
  }
}

class _MusicControlsWidgetState extends ConsumerState<MusicControlsWidget> {
  Uint8List? image;

  getCover() async {
    final current = ref.watch(currentPlayingControllerProvider);
    if (current == null) return;
    final data = await readMetadata(File(current.path), getImage: true);
    if (data.pictures.isNotEmpty) {
      setState(() {
        image = data.pictures.first.bytes;
      });
    } else {
      image = null;
    }
  }

  PlayerState? _playerState;

  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  AudioPlayer get player => ref.read(audioPlayerProvider);

  @override
  void initState() {
    super.initState();
    // Use initial values from player
    _playerState = player.state;
   _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = ref.watch(currentPlayingControllerProvider);

    final screenWidth = MediaQuery.of(context).size.width;


    useEffect(() {
      getCover();
      return null;
    }, [currentSong]);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(_createRoute(image));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (screenWidth < 650) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: 'image',
                  child: SizedBox(
                      height: 70,
                      width: 70,
                      child: MusicImagePlaceholder(image: image)),
                ),
              ),
              const SizedBox(height: 20),
              const MusicPositionTextWidget(),
              // Slider
              const MusicSliderWidget(),
              // Controls
              SizedBox(
                width: 170,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: const Key('prev_button'),
                      onPressed: currentSong?.previous == null ? null : _prev,
                      iconSize: 38.0,
                      color: Colors.grey,
                      icon: const Icon(Icons.skip_previous),
                    ),
                    IconButton(
                      key: const Key('play_button'),
                      onPressed: _isPlaying ? _pause : _play,
                      iconSize: 38.0,
                      icon: _isPlaying
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                      color: Colors.grey,
                    ),
                    IconButton(
                      key: const Key('next_button'),
                      onPressed: currentSong?.next == null ? null : _next,
                      iconSize: 38.0,
                      icon: const Icon(Icons.skip_next),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
            if (screenWidth >= 650)
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: 'image',
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: MusicImagePlaceholder(image: image),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const MusicPositionTextWidget(),
                  // Slider
                  const Expanded(
                    child: MusicSliderWidget(),
                  ),
                  // Controls
                  SizedBox(
                    width: 170,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          key: const Key('prev_button'),
                          onPressed:
                              currentSong?.previous == null ? null : _prev,
                          iconSize: 38.0,
                          color: Colors.grey,
                          icon: const Icon(Icons.skip_previous),
                        ),
                        IconButton(
                          key: const Key('play_button'),
                          onPressed: _isPlaying ? _pause : _play,
                          iconSize: 38.0,
                          icon: _isPlaying
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow),
                          color: Colors.grey,
                        ),
                        IconButton(
                          key: const Key('next_button'),
                          onPressed: currentSong?.next == null ? null : _next,
                          iconSize: 38.0,
                          icon: const Icon(Icons.skip_next),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const VolumeRocker(),
                ],
              ),
            Text(
              p.basenameWithoutExtension(currentSong?.path ?? ''),
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  void _initStreams() {
    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    if (player.source == null) {
      ref.read(currentPlayingControllerProvider.notifier).playFirst();
    }
    await player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _next() async {
    ref.read(currentPlayingControllerProvider.notifier).playNext();
  }

  Future<void> _prev() async {
    ref.read(currentPlayingControllerProvider.notifier).playPrev();
  }
}

Route _createRoute(Uint8List? image) {
  return PageRouteBuilder(
    barrierDismissible: false,
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation) =>
        DetailedScreen(image: null,),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0, 1);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
