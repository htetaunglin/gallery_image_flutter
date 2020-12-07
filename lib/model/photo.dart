import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class GalleryPhoto {
  final String id;
  final int width;
  final int height;
  final File file;
  final Uint8List thumb;
  final Size size;
  final String mediaUrl;
  const GalleryPhoto(
    this.id,
    this.width,
    this.height,
    this.file,
    this.thumb,
    this.mediaUrl,
    this.size,
  );
}
