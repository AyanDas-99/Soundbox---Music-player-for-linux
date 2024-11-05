import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soundbox/state/audio_player_provider.dart';
import 'package:soundbox/state/current_playing_controller.dart';
import 'package:soundbox/view/components/music_image_placeholder.dart';
import 'package:path/path.dart' as p;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:soundbox/view/components/music_position_text_widget.dart';
import 'package:soundbox/view/components/music_slider_widget.dart';
import 'package:soundbox/view/components/volume_rocker.dart';
import 'package:soundbox/view/extensions/string_extension.dart';

// ignore: must_be_immutable
class DetailedScreen extends StatefulHookConsumerWidget {
  DetailedScreen({
    super.key,
    required this.image,
  });

  Uint8List? image;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DetailedScreenState();
  }
}

class _DetailedScreenState extends ConsumerState<DetailedScreen> {
  double opacity = 1;
  late Key pageKey;

  getCover() async {
    final current = ref.read(currentPlayingControllerProvider);
    if (current == null) return;
    final data = await readMetadata(File(current.path), getImage: true);
    if (data.pictures.isNotEmpty) {
      setState(() {
        widget.image = data.pictures.first.bytes;
      });
    } else {
      widget.image = null;
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
    pageKey = UniqueKey();
    // Use initial values from player
    _playerState = player.state;

    _initStreams();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        opacity = 0.5;
      });
    });
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
    useEffect(() {
      getCover();
      return null;
    }, [currentSong]);

    final size = min(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return Dismissible(
      key: pageKey,
      direction: DismissDirection.vertical,
      onDismissed: (direction) {
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade800,
              Colors.grey.shade900,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                CupertinoIcons.chevron_down,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: opacity,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 500),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: 'image',
                          child: Container(
                              height: size * 0.6,
                              width: size * 0.6,
                              constraints: const BoxConstraints(
                                  maxWidth: 650, maxHeight: 650),
                              child:
                                  MusicImagePlaceholder(image: widget.image)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: min(400, size * 0.4),
                      child: Container(
                        width: size * 0.5,
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: AnimatedOpacity(
                          opacity: (1 - opacity) / 0.5,
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            p.basenameWithoutExtension(
                                currentSong?.path.shortened() ?? ''),
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                const Row(
                  children: [
                    MusicPositionTextWidget(),
                    // Slider
                    Expanded(
                      child: MusicSliderWidget(),
                    ),
                  ],
                ),
                // Controls
                Row(
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: SizedBox(
                          width: 170,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                key: const Key('prev_button'),
                                onPressed: currentSong?.previous == null
                                    ? null
                                    : _prev,
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
                                onPressed:
                                    currentSong?.next == null ? null : _next,
                                iconSize: 38.0,
                                icon: const Icon(Icons.skip_next),
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: VolumeRocker()),
                  ],
                ),
              ],
            ),
          ),
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
