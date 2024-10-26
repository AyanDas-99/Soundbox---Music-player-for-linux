import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:soundbox/state/audio_player_provider.dart';

class VolumeRocker extends ConsumerWidget {
  const VolumeRocker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    return MenuAnchor(
      menuChildren: [
        Slider(
            value: player.volume,
            onChanged: (val) {
              player.setVolume(val);
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
