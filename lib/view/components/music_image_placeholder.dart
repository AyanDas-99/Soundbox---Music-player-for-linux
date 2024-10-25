import 'package:flutter/material.dart';

class MusicImagePlaceholder extends StatelessWidget {
  const MusicImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10)
      ),
      height: 100,
      width: 100,
      child: const Center(
        child: Icon(Icons.music_note_rounded),
      ),
    );
  }
}
