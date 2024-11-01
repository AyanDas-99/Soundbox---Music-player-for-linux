import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:soundbox/state/audio_player_provider.dart';
import 'package:soundbox/state/music_player.dart';

class VolumeRocker extends ConsumerStatefulWidget {
  const VolumeRocker({super.key});

  @override
  ConsumerState<VolumeRocker> createState() => _VolumeRockerState();
}

class _VolumeRockerState extends ConsumerState<VolumeRocker> {
  late double rockerValue;

  @override
  void initState() {
    super.initState();
    rockerValue = ref.read(audioPlayerProvider).volume;
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(audioPlayerProvider);
    return MenuAnchor(
      menuChildren: [
        Slider(
            inactiveColor: Colors.grey,
            activeColor: Colors.blue,
            value: rockerValue,
            onChanged: (val) {
              ref.read(musicPlayerProvider.notifier).setVolume(val);
              setState(() {
                rockerValue = val;
              });
            })
      ],
      builder: (context, controller, child) => IconButton(
        color: Colors.grey,
        iconSize: 30,
        icon: Icon(
          iconFromVol(player.volume),
        ),
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
      ),
    );
  }

  IconData iconFromVol(double val) {
    if (val == 0.0) {
      return Icons.volume_off_rounded;
    } else if (val < 0.3) {
      return Icons.volume_mute_rounded;
    } else if (val < 0.6) {
      return Icons.volume_down_rounded;
    } else {
      return Icons.volume_up_rounded;
    }
  }
}
