///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 11:00
///
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import 'log_util.dart';

/// Just do nothing. :)
void doNothing() {}

/// Check permissions and only return whether they succeed or not.
Future<bool> checkPermissions(List<Permission> permissions) async {
  try {
    final Map<Permission, PermissionStatus> status =
        await permissions.request();
    return !status.values.any(
      (PermissionStatus p) => p != PermissionStatus.granted,
    );
  } catch (e) {
    LogUtil.e('Error when requesting permission: $e');
    return false;
  }
}

/// Iterate element and its children to request rebuild.
void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}

/// Obtain the screenshot data from a [GlobalKey] with [RepaintBoundary].
Future<ByteData> obtainScreenshotData(GlobalKey key) async {
  final RenderRepaintBoundary boundary =
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final ui.Image image = await boundary.toImage(
    pixelRatio: ui.window.devicePixelRatio,
  );
  final ByteData? byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  return byteData!;
}

/// 将图片数据递归压缩至符合条件为止
///
/// GIF 动图不压缩
/// 最低质量为 4
Future<Uint8List?> compressEntity(
  AssetEntity entity,
  String extension, {
  int quality = 99,
}) async {
  const int limitation = 5242880; // 5M
  if (extension.contains('gif')) {
    return entity.originBytes;
  }
  Uint8List? data;
  if (entity.width > 0 && entity.height > 0) {
    if (entity.width >= 4000 || entity.height >= 5000) {
      data = await entity.thumbDataWithSize(
        entity.width ~/ 3,
        entity.height ~/ 3,
        quality: quality,
      );
    } else if (entity.width >= 2500 || entity.height >= 3500) {
      data = await entity.thumbDataWithSize(
        entity.width ~/ 2,
        entity.height ~/ 2,
        quality: quality,
      );
    } else {
      data = await entity.thumbDataWithSize(
        entity.width,
        entity.height,
        quality: quality,
      );
    }
  } else {
    data = await entity.thumbData;
  }
  if (data == null) {
    return data;
  }
  if (data.lengthInBytes >= limitation && quality > 5) {
    return compressEntity(entity, extension, quality: quality - 5);
  }
  return data;
}
