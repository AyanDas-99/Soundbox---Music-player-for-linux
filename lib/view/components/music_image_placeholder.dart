import 'dart:typed_data';

import 'package:flutter/material.dart';

class MusicImagePlaceholder extends StatelessWidget {
  const MusicImagePlaceholder({super.key, required this.image});
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 100,
      width: 100,
      child: image == null
          ? const Center(
              child: Icon(Icons.music_note_rounded),
            )
          : Image.memory(
              image!,
              fit: BoxFit.cover,
            ),
    );
  }
}
