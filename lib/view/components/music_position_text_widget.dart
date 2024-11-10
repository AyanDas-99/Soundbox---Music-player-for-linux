import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:soundbox/state/audio_player/audio_player_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MusicPositionTextWidget extends StatefulHookConsumerWidget {
  const MusicPositionTextWidget({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MusicPositionTextWidgetState();
  }
}

class _MusicPositionTextWidgetState
    extends ConsumerState<MusicPositionTextWidget> {
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  AudioPlayer get player => ref.read(audioPlayerProvider);
  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

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
    return Text(
      _position != null
          ? '$_positionText / $_durationText'
          : _duration != null
              ? _durationText
              : '',
      style: const TextStyle(fontSize: 16.0, color: Colors.white),
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
