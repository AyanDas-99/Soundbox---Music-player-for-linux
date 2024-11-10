import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:soundbox/state/audio_player/audio_player_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:soundbox/state/music_player.dart';

class MusicSliderWidget extends StatefulHookConsumerWidget {
  const MusicSliderWidget({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MusicSliderWidgetState();
  }
}

class _MusicSliderWidgetState extends ConsumerState<MusicSliderWidget> {
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  AudioPlayer get player => ref.read(audioPlayerProvider);

  @override
  void initState() {
    super.initState();
    // Use initial values from player
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      onChanged: (value) {
        final duration = _duration;
        if (duration == null) {
          return;
        }
        final position = value * duration.inMilliseconds;
        ref.read(musicPlayerProvider.notifier).seek(position);
      },
      value: (_position != null &&
              _duration != null &&
              _position!.inMilliseconds > 0 &&
              _position!.inMilliseconds < _duration!.inMilliseconds)
          ? _position!.inMilliseconds / _duration!.inMilliseconds
          : 0.0,
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );
  }
}
