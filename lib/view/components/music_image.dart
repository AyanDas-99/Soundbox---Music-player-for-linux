import 'dart:io';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/material.dart';
import 'package:soundbox/view/components/music_image_placeholder.dart';

class MusicImage extends StatefulWidget {
  final File track;
  const MusicImage({super.key, required this.track});

  @override
  State<MusicImage> createState() => _MusicImageState();
}

class _MusicImageState extends State<MusicImage> {
  Uint8List? image;

  getCover() async {
    final data = await readMetadata(widget.track, getImage: true);
    if (data.pictures.isNotEmpty) {
      if (mounted) {
        setState(() {
          image = data.pictures.first.bytes;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCover();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50, width: 50, child: MusicImagePlaceholder(image: image));
  }
}
