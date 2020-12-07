import 'dart:typed_data';

class GalleryAlbum {
  final String id;
  final String name;
  final Uint8List coverUri;
  final int photosCount;
  const GalleryAlbum(this.id, this.name, this.coverUri, this.photosCount);
}
