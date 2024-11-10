import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:soundbox/state/playlist.dart';
import 'package:path/path.dart' as p;
import 'package:soundbox/view/extensions/string_extension.dart';

class AnimatedText extends ConsumerStatefulWidget {
  const AnimatedText({
    super.key,
    required this.currentSong,
    required this.playing,
  });

  final SongListItem? currentSong;
  final bool playing;

  @override
  ConsumerState<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends ConsumerState<AnimatedText>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animation = Tween(begin: -1.0, end: 1.0).animate(controller);
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(
              widget.playing
                  ? animation.value * widget.currentSong?.path.length * 10
                  : 0,
              0),
          child: Text(
            widget.playing
                ? p.basenameWithoutExtension(widget.currentSong?.path ?? '')
                : p.basenameWithoutExtension(
                    widget.currentSong?.path.shortened(limit: 40) ?? ''),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
