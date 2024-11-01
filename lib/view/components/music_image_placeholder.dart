import 'dart:typed_data';

import 'package:flutter/material.dart';

class MusicImagePlaceholder extends StatelessWidget {
  const MusicImagePlaceholder({super.key, required this.image});
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: const BoxDecoration(
        color: Colors.blueGrey,
      ),
      height: 100,
      width: 100,
      duration: const Duration(milliseconds: 500),
      child: image == null
          ? const Center(
              child: Icon(Icons.music_note_rounded, color: Colors.white),
            )
          : Image.memory(
              image!,
              fit: BoxFit.cover,
            ),
    );
  }
}
