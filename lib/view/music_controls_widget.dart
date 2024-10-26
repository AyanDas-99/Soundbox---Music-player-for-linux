import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:soundbox/state/audio_player_provider.dart';
import 'package:soundbox/state/current_playing_controller.dart';
import 'package:soundbox/view/components/music_image_placeholder.dart';
import 'package:path/path.dart' as p;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    print('Reading meta');
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
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  AudioPlayer get player => ref.read(audioPlayerProvider);

  @override
  void initState() {
    super.initState();
    // Use initial values from player
    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
            _duration = value;
          }),
        );
    player.getCurrentPosition().then(
          (value) => setState(() {
            _position = value;
          }),
        );
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
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
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

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (screenWidth < 650) ...[
            SizedBox(
              height: 70,
              width: 70,
              child: image == null
                  ? const MusicImagePlaceholder()
                  : Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.memory(
                        image!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              _position != null
                  ? '$_positionText / $_durationText'
                  : _duration != null
                      ? _durationText
                      : '',
              style: const TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            // Slider
            Slider(
              onChanged: (value) {
                final duration = _duration;
                if (duration == null) {
                  return;
                }
                final position = value * duration.inMilliseconds;
                player.seek(Duration(milliseconds: position.round()));
              },
              value: (_position != null &&
                      _duration != null &&
                      _position!.inMilliseconds > 0 &&
                      _position!.inMilliseconds < _duration!.inMilliseconds)
                  ? _position!.inMilliseconds / _duration!.inMilliseconds
                  : 0.0,
            ),
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
                SizedBox(
                  height: 70,
                  width: 70,
                  child: image == null
                      ? const MusicImagePlaceholder()
                      : Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.memory(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(width: 20),
                Text(
                  _position != null
                      ? '$_positionText / $_durationText'
                      : _duration != null
                          ? _durationText
                          : '',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                // Slider
                Expanded(
                  child: Slider(
                    onChanged: (value) {
                      final duration = _duration;
                      if (duration == null) {
                        return;
                      }
                      final position = value * duration.inMilliseconds;
                      player.seek(Duration(milliseconds: position.round()));
                    },
                    value: (_position != null &&
                            _duration != null &&
                            _position!.inMilliseconds > 0 &&
                            _position!.inMilliseconds <
                                _duration!.inMilliseconds)
                        ? _position!.inMilliseconds / _duration!.inMilliseconds
                        : 0.0,
                  ),
                ),
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
            ),
          Text(
            p.basenameWithoutExtension(currentSong?.path ?? ''),
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
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
