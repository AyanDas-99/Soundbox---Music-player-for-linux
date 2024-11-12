import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_color.g.dart';

@Riverpod(keepAlive: true)
class ImageColor extends _$ImageColor {
  @override
  ColorScheme build() {
    return ColorScheme.fromSeed(seedColor: Colors.grey.shade900);
  }

  Future<void> buildFromImage(Uint8List image) async {
    final scheme =
        await ColorScheme.fromImageProvider(provider: MemoryImage(image));
    print(scheme);
    state = scheme;
  }

  Future<void> reset() async {
    final scheme = ColorScheme.fromSeed(seedColor: Colors.grey.shade900);
    print(scheme);
    state = scheme;
  }
}
