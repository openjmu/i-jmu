///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 15:31
///
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:i_jmu/internal/instances.dart';
import 'package:i_jmu/constants/styles.dart';
import 'package:i_jmu/extensions/build_context_extension.dart';
import 'package:i_jmu/utils/log_util.dart';
import 'package:i_jmu/utils/other_utils.dart';
import 'package:i_jmu/utils/toast_util.dart';
import 'package:photo_manager/photo_manager.dart';

import 'gaps.dart';

class JMUErrorWidget extends StatelessWidget {
  const JMUErrorWidget(this.details, {Key? key}) : super(key: key);

  final FlutterErrorDetails details;

  static void takeOver() {
    ErrorWidget.builder = (FlutterErrorDetails d) {
      LogUtil.e(
        'Error has been delivered to the ErrorWidget: ${d.exception}',
        stackTrace: d.stack,
      );
      return JMUErrorWidget(d);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Color.lerp(context.theme.canvasColor, defaultLightColor, 0.1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const FractionallySizedBox(
              widthFactor: 0.25,
              child: Icon(Icons.error_outline_rounded),
            ),
            const Gap.v(20),
            Text(
              '出现了不可预料的错误 (>_<)',
              style: TextStyle(
                color: context.textTheme.caption!.color,
                fontSize: 20,
              ),
            ),
            const Gap.v(10),
            Text(
              details.exception.toString(),
              style: TextStyle(
                color: context.textTheme.caption!.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap.v(10),
            Text(
              details.stack.toString(),
              style: TextStyle(
                color: context.textTheme.caption!.color,
                fontSize: 13,
              ),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap.v(20),
            GestureDetector(
              onTap: _takeAppScreenshot,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: defaultLightColor,
                ),
                child: const Text(
                  '保存当前位置错误截图',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.24,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _takeAppScreenshot() async {
  try {
    final ByteData byteData = await obtainScreenshotData(
      Instances.appRepaintBoundaryKey,
    );
    await PhotoManager.editor.saveImage(byteData.buffer.asUint8List());
    showToast('截图保存成功');
  } catch (e) {
    LogUtil.e('Error when taking app\'s screenshot: $e');
    showCenterErrorToast('截图保存失败');
  }
}
