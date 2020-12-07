import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery_images/exception/permission_deny_exception.dart';
import 'package:gallery_images/model/album.dart';
import 'package:gallery_images/model/photo.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryImageAssert {
  GalleryImageAssert._();

  static GalleryImageAssert _assert;
  static GalleryImageAssert get instance => _assert ??= GalleryImageAssert._();

  DefaultCacheManager manager = new DefaultCacheManager();

  Future<List<GalleryAlbum>> getAllImageAlbums() async {
    var result = await PhotoManager.requestPermission();
    var albumList = await PhotoManager.getAssetPathList(
        type: RequestType.image, hasAll: false);
    List<GalleryAlbum> resultList = [];
    if (result) {
      for (int i = 0; i < albumList.length; i++) {
        var coverFile = (await albumList[i].getAssetListPaged(0, 1))[0];
        var cover = await coverFile.thumbData;
        resultList.add(GalleryAlbum(albumList[i].id, albumList[i].name, cover,
            albumList[i].assetCount));
      }
      return resultList;
    } else {
      throw PermissionDenyException("Storage Permission is Deny");
    }
  }

  Future<List<GalleryPhoto>> getImages(
      String albumId, int count, int pageSize) async {
    var albumList = await PhotoManager.getAssetPathList(
        type: RequestType.image, hasAll: false);
    var photoList = await albumList
        .firstWhere(
            (e) => e.id.replaceAll("-", "") == albumId.replaceAll("-", ""),
            orElse: () => throw "No Found")
        .getAssetListPaged(count, pageSize);
    List<GalleryPhoto> list = [];
    for (var photo in photoList) {
      list.add(GalleryPhoto(
        photo.id,
        photo.width,
        photo.height,
        await photo.file,
        await photo.thumbDataWithSize(200, 200),
        await photo.getMediaUrl(),
        photo.size,
      ));
    }
    return list;
  }

  Future<List<GalleryPhoto>> getAllImages(int count, int pageSize) async {
    var albumList = await PhotoManager.getAssetPathList(
        type: RequestType.image, hasAll: true, onlyAll: true);
    var photoList = await albumList
        .firstWhere((e) => e.id.replaceAll("-", "") == "isAll",
            orElse: () => throw "No Found")
        .getAssetListPaged(count, pageSize);
    List<GalleryPhoto> list = [];
    for (var photo in photoList) {
      list.add(GalleryPhoto(
        photo.id,
        photo.width,
        photo.height,
        await photo.file,
        await photo.thumbDataWithSize(100, 100),
        await photo.getMediaUrl(),
        photo.size,
      ));
    }
    return list;
  }

  Future clearCache() async {
    await manager.emptyCache();
    // await PhotoManager.releaseCache();
  }
}
